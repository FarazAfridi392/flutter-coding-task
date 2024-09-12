import 'package:coding_task/providers/theme_provider.dart';
import 'package:coding_task/screens/auth/widgets/custom_button.dart';
import 'package:coding_task/screens/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonAuthForm extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String buttonText;
  final VoidCallback onSubmit;

  const CommonAuthForm({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: ref.watch(themeProvider) == ThemeMode.dark
                ? Colors.black
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              ref.watch(themeProvider) == ThemeMode.dark
                  ? BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email TextField
              const Text(
                "Email Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // Password TextField
              const Text(
                "Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                isObscure: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 30),

              // Submit Button (Login/Sign Up)
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
                      text: buttonText,
                      onPressed: onSubmit,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
