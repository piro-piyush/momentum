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

  String get token {
    final token = SpService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }
    return token;
  }

  Future<void> checkAuth() async {
    emit(AuthChecking());

    try {
      final remoteUser = await authRemoteRepository.getUser(token: token);

      if (remoteUser != null) {
        await authLocalRepository.saveUser(remoteUser);
        emit(AuthLoggedIn(remoteUser));
        return;
      }

      final localUser = await authLocalRepository.getUser();

      if (localUser == null) {
        emit(AuthLoggedOut());
        return;
      }

      emit(AuthLoggedIn(localUser));
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

      if (token.isNotEmpty) {
        await SpService.setToken(token);
      }
      await authLocalRepository.saveUser(user);
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
