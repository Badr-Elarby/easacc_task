import 'package:bloc/bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
