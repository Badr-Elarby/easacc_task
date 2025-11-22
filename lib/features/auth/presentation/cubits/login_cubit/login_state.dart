/// Login State
///
/// Defines all possible states for the login feature.
/// Used by LoginCubit to emit state changes during authentication.

import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no authentication attempted
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Loading state - authentication in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Success state - user authenticated successfully
class LoginSuccess extends LoginState {
  final UserModel user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Error state - authentication failed
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
