/// Login Screen
///
/// Presentation layer for user authentication.
/// Provides UI for Google and Facebook sign-in.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../cubits/login_cubit/login_cubit.dart';
import '../cubits/login_cubit/login_state.dart';
import 'facebook_web_login_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigate to settings on successful login
              context.go('/settings');
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();
            final isLoading = state is LoginLoading;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo/Title
                    const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 48),

                    // Google Sign-In Button
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => cubit.signInWithGoogle(),
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text('Sign in with Google'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Facebook Sign-In Button
                    ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final token = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FacebookWebLoginPage(
                                    appId: "891124620012084",
                                  ),
                                ),
                              );

                              if (context.mounted) {
                                if (token != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Facebook Login Success"),
                                    ),
                                  );
                                  print("FB token: $token");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Facebook Login Cancelled"),
                                    ),
                                  );
                                }
                              }
                            },
                      icon: const Icon(Icons.facebook),
                      label: const Text('Sign in with Facebook'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: const Color(0xFF1877F2),
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Loading Indicator
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
