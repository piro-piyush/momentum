import 'package:momentum/lib.dart';

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
      final token = SpService.getToken();

      if (token == null || token.isEmpty) {
        emit(AuthLoggedOut());
        return;
      }

      final user = await authRemoteRepository.getUser(token: token);

      emit(AuthLoggedIn(user));
    } catch (_) {
      await SpService.clearToken();
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

      await authRemoteRepository.register(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthLoggedOut());
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final (user, token) = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      await SpService.setToken(token);

      emit(AuthLoggedIn(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await SpService.clearToken();
      emit(AuthLoggedOut());
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
