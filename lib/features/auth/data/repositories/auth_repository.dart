/// Auth Repository
///
/// Implements the repository pattern for authentication operations.
/// Acts as a mediator between the presentation layer and data sources.

import '../datasources/auth_firebase_data_source.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign out
  Future<void> signOut();
}

/// Implementation of AuthRepository
/// Delegates authentication operations to AuthFirebaseDataSource
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource authFirebaseDataSource;

  AuthRepositoryImpl({required this.authFirebaseDataSource});

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      return await authFirebaseDataSource.signInWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authFirebaseDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
