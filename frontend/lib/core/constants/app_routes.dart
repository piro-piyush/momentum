import 'package:momentum/lib.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String splash = '/splash';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    splash: (_) => const SplashPage(),
    home: (_) => const HomePage(),
  };
}
