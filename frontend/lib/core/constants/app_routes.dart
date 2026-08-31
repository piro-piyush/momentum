import 'package:momentum/lib.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String newTask = '/new-task';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    splash: (_) => const SplashPage(),
    home: (_) => const HomePage(),
    profile: (_) => const ProfilePage(),
    newTask: (_) => const NewTaskPage(),
  };
}
