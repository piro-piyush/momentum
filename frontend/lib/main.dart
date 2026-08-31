import 'package:momentum/lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // final preferences = await SharedPreferences.getInstance();
  await SpService.init();
  runApp(MomentumApp());
}

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(
            authRemoteRepository: AuthRemoteRepository(ApiService()),
            authLocalRepository: AuthLocalRepository(),
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
