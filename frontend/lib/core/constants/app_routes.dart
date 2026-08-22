import 'package:momentum/lib.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
  };
}