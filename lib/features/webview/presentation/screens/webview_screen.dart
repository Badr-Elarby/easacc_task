/// WebView Screen
///
/// Displays web content within the application.
/// Receives URL as a parameter from the router.
/// Handles internal navigation history and proper back navigation.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();

    // Initialize controller safely
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
            },
            onPageFinished: (url) async {
              try {
                final canGoBack = await _controller.canGoBack();
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _canGoBack = canGoBack;
                  });
                }
              } catch (e) {
                debugPrint('Error checking canGoBack: $e');
              }
            },
            onWebResourceError: (error) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to load page: ${error.description}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } catch (e) {
      debugPrint('Error initializing WebView: $e');
    }
  }

  Future<void> _handleBackNavigation() async {
    try {
      if (await _controller.canGoBack()) {
        await _controller.goBack();
      } else {
        if (mounted) {
          // Safe navigation prevents crash
          context.go('/settings');
        }
      }
    } catch (e) {
      // Fallback if controller fails
      if (mounted) {
        context.go('/settings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use WillPopScope to intercept system back button
    return WillPopScope(
      onWillPop: () async {
        try {
          if (await _controller.canGoBack()) {
            await _controller.goBack();
            return false; // Prevent app from exiting
          }
        } catch (e) {
          // Ignore error and proceed to safe navigation
        }

        // Navigate to settings instead of allowing default pop
        if (mounted) {
          context.go('/settings');
        }
        return false; // Prevent default pop since we handled navigation manually
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebView'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackNavigation,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                try {
                  _controller.reload();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to reload')),
                  );
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
