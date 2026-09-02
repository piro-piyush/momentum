import 'package:momentum/lib.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();
  bool isObsecureText = true;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // if (state is AuthLoggedIn) {
        //   Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     AppRoutes.home,
        //     (route) => false,
        //   );
        // }

        if (state is AuthError) {
          SnackBarUtils.error(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      Text(
                        'Create account.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Start your journey with Momentum.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 40),

                      const TextFieldLabelWidget(label: 'Name'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: ValidatorUtils.name,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          hintText: 'Your name',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const TextFieldLabelWidget(label: 'Email'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: ValidatorUtils.email,
                        autocorrect: false,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          hintText: 'you@example.com',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const TextFieldLabelWidget(label: 'Password'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: passwordController,
                        obscureText: isObsecureText,
                        textInputAction: TextInputAction.done,
                        validator: ValidatorUtils.password,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          hintText: 'Create a password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObsecureText = !isObsecureText;
                              });
                            },
                            icon: Icon(
                              !isObsecureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading ? null : _register,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text('Create account'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!(await ConnectivityService.instance.isConnected)) {
      SnackBarUtils.error(
        context,
        'No internet connection. Please check your network.',
      );
      return;
    }

    await context.read<AuthCubit>().register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;
    SnackBarUtils.success(
      context,
      'Account created successfully. Please login.',
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
