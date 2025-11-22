import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/settings_cubit/settings_cubit.dart';

class UrlInputSection extends StatefulWidget {
  const UrlInputSection({super.key});

  @override
  State<UrlInputSection> createState() => _UrlInputSectionState();
}

class _UrlInputSectionState extends State<UrlInputSection> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Web URL',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: 'Enter URL (e.g., https://google.com)',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final url = _urlController.text.trim();
                if (url.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a URL'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Add https:// if not present
                String finalUrl = url;
                if (!url.startsWith('http://') && !url.startsWith('https://')) {
                  finalUrl = 'https://$url';
                }

                // Save URL and navigate to WebView
                context.read<SettingsCubit>().saveUrl(finalUrl);
                // Use push to maintain navigation stack
                context.push('/webview?url=${Uri.encodeComponent(finalUrl)}');
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Save and Open in WebView'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
