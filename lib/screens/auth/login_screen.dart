import 'package:coding_task/providers/auth_providers.dart';
import 'package:coding_task/screens/auth/signup_screen.dart';
import 'package:coding_task/screens/auth/widgets/custom_auth_form.dart';
import 'package:coding_task/screens/auth/widgets/custom_button.dart';
import 'package:coding_task/screens/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
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
                buttonText: 'Login',
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

                    await authService
                        .signInWithEmail(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    )
                        .then((_) {
                      ref.read(loadingProvider.notifier).state = false;
                    });

                    // Navigate to home after login
                  } catch (e) {
                    ref.read(loadingProvider.notifier).state = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login failed: ${e.toString()}")),
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
                      builder: (_) => SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Sign Up',
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
