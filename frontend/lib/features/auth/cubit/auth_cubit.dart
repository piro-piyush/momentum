import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momentum/core/exceptions/auth_exception.dart';
import 'package:momentum/features/auth/auth.dart';
import 'package:momentum/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.authRemoteRepository,
    required this.authLocalRepository,
  }) : super(AuthInitial()) {
    checkAuth();
  }

  final AuthRemoteRepository authRemoteRepository;
  final AuthLocalRepository authLocalRepository;

  Future<void> checkAuth() async {
    emit(AuthChecking());

    try {
      final user = await authLocalRepository.getUser();

      if (user == null) {
        emit(AuthLoggedOut());
        return;
      }

      emit(AuthLoggedIn(user));
    } catch (e) {
      emit(AuthLoggedOut());
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final UserModel user = await authRemoteRepository.register(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthLoggedIn(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final user = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      await authLocalRepository.saveUser(user);

      emit(AuthLoggedIn(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    authRemoteRepository.dispose();
    return super.close();
  }
}
