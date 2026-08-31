part of "auth_cubit.dart";

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthChecking extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoggedIn extends AuthState {
  AuthLoggedIn(this.user);

  final UserModel user;
}

final class AuthLoggedOut extends AuthState {}

final class AuthError extends AuthState {
  AuthError(this.message);

  final String message;
}