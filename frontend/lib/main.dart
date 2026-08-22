import 'package:momentum/lib.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MomentumApp());
}

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momentum',
      debugShowCheckedModeBanner: false,

      // App theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      // Initial screen
      home: const RegisterPage(),
    );
  }
}
