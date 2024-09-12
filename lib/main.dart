import 'package:coding_task/providers/auth_providers.dart';
import 'package:coding_task/providers/theme_provider.dart';
import 'package:coding_task/screens/auth/login_screen.dart';

import 'package:coding_task/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen(); // User is logged in
          } else {
            return LoginScreen(); // User is logged out
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
