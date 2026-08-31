import 'package:http/http.dart' as http;
import 'package:momentum/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final preferences = await SharedPreferences.getInstance();
  runApp(MomentumApp(preferences: preferences));
}

class MomentumApp extends StatelessWidget {
  const MomentumApp({required this.preferences, super.key});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(
            authRemoteRepository: AuthRemoteRepository(http.Client()),
            authLocalRepository: AuthLocalRepository(preferences),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Momentum',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return switch (state) {
              AuthInitial() || AuthChecking() => const SplashPage(),
              AuthLoggedIn() => const HomePage(),
              AuthLoggedOut() || AuthError() => const LoginPage(),
              AuthLoading() => const LoginPage(),
            };
          },
        ),
      ),
    );
  }
}
