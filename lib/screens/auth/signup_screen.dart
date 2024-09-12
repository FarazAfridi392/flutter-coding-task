import 'package:coding_task/providers/auth_providers.dart';
import 'package:coding_task/screens/auth/login_screen.dart';
import 'package:coding_task/screens/auth/widgets/custom_auth_form.dart';
import 'package:coding_task/screens/auth/widgets/custom_button.dart';
import 'package:coding_task/screens/auth/widgets/custom_textfield.dart';
import 'package:coding_task/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo

              CommonAuthForm(
                emailController: emailController,
                passwordController: passwordController,
                isLoading: isLoading,
                buttonText: 'Signup',
                onSubmit: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  try {
                    isLoading
                        ? null
                        : ref.read(loadingProvider.notifier).state = true;
                    ref.read(loadingProvider.notifier).state = true;

                    await authService
                        .signUpWithEmail(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        )
                        .then((user) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            ));
                  } catch (e) {
                    ref.read(loadingProvider.notifier).state = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("SignUp failed: ${e.toString()}")),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // Forgot Password and Sign Up

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
