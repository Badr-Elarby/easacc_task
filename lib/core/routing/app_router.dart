/// Application Routing Configuration
///
/// This file contains the GoRouter setup for the entire application.
/// All routes are defined here with their corresponding screens.
///
/// Routes:
/// - /login: Authentication screen with Google/Facebook login
/// - /settings: Device settings and scanning screen
/// - /webview: WebView screen for displaying external content
///
/// Usage:
/// - Access router via appRouter in main.dart
/// - Navigate using context.go('/route-name')
/// - Pass parameters using GoRouterState

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/webview/presentation/screens/webview_screen.dart';

/// Application router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const SettingsScreen()),
    ),
    GoRoute(
      path: '/webview',
      name: 'webview',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: WebViewScreen(url: state.uri.queryParameters['url'] ?? ''),
      ),
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.path}')),
    ),
  ),
);
