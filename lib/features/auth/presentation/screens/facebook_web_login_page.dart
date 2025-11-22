import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FacebookWebLoginPage extends StatefulWidget {
  final String appId;

  const FacebookWebLoginPage({super.key, required this.appId});

  @override
  State<FacebookWebLoginPage> createState() => _FacebookWebLoginPageState();
}

class _FacebookWebLoginPageState extends State<FacebookWebLoginPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    const redirectUrl = "https://www.facebook.com/connect/login_success.html";
    final authUrl =
        "https://www.facebook.com/v18.0/dialog/oauth?client_id=${widget.appId}&redirect_uri=$redirectUrl&response_type=token&scope=email,public_profile";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(redirectUrl)) {
              _handleRedirect(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null && change.url!.startsWith(redirectUrl)) {
              _handleRedirect(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(authUrl));
  }

  void _handleRedirect(String url) {
    final uri = Uri.parse(url);
    final fragment = uri.fragment;
    if (fragment.contains("access_token=")) {
      try {
        final token = fragment
            .split("&")
            .firstWhere((element) => element.startsWith("access_token="))
            .split("=")[1];
        Navigator.pop(context, token);
      } catch (e) {
        // Handle parsing error if needed
        Navigator.pop(context, null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Facebook Login")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
