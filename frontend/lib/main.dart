import 'package:momentum/lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final db = await DatabaseService.instance.database;
  await SpService.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authRemoteRepository: AuthRemoteRepository(ApiService()),
            authLocalRepository: AuthLocalRepository(db),
          ),
        ),
        BlocProvider<TasksCubit>(
          create: (_) => TasksCubit(
            taskLocalRepository: TaskLocalRepository(db),
            taskRemoteRepository: TaskRemoteRepository(ApiService()),
          ),
        ),
        BlocProvider<TaskMutationCubit>(
          create: (_) => TaskMutationCubit(
            taskLocalRepository: TaskLocalRepository(db),
            taskRemoteRepository: TaskRemoteRepository(ApiService()),
          ),
        ),
      ],
      child: MomentumApp(),
    ),
  );
}

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
