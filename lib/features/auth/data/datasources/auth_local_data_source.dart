/// Authentication Local Data Source
///
/// Defines the contract for authentication operations with external providers.
/// Implementations handle Google and Facebook sign-in functionality.

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Sign in with Google account
  /// Returns UserModel on success, null on failure or cancellation
  Future<UserModel?> signInWithGoogle();

  /// Sign out from current session
  Future<void> signOut();
}

/// Implementation of AuthLocalDataSource
/// Integrates with Google Sign-In and Facebook Login SDKs
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<UserModel?> signInWithGoogle() async {
    // Implementation will integrate with google_sign_in package
    // For now, returns null as placeholder
    throw UnimplementedError('Google Sign-In not yet implemented');
  }

  @override
  Future<void> signOut() async {
    // Implementation will sign out from all providers
    throw UnimplementedError('Sign out not yet implemented');
  }
}
