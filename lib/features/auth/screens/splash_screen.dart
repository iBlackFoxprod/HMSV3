// lib/features/auth/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hmsv3/app/navigation/app_routes.dart';
import 'package:hmsv3/core/models/user_model.dart'; // <<< ADD THIS LINE
import 'package:hmsv3/features/auth/providers/auth_providers.dart';
import 'package:hmsv3/core/enums/user_role_enum.dart';


class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes
    // Note: Ensure UserModel is imported for AsyncValue<UserModel?> to work
    ref.listen<AsyncValue<UserModel?>>(authStateChangesProvider, (_, state) { // UserModel? needs UserModel to be defined
      state.when(
        data: (user) {
          if (user != null) {
            // User is logged in, navigate based on role
            if (user.role == UserRole.patient) {
              context.go(AppRoutes.patientHome);
            } else {
              // TODO: Navigate to employee dashboard or other relevant screen
              context.go(AppRoutes.employeeDashboard); // Placeholder
            }
          } else {
            // User is not logged in, navigate to login
            Future.delayed(const Duration(seconds: 1), () {
               context.go(AppRoutes.login);
            });
          }
        },
        loading: () {
          // Loading state
        },
        error: (err, stack) {
          print("Error in authStateChangesProvider on Splash: $err");
          Future.delayed(const Duration(seconds: 1), () {
            context.go(AppRoutes.login);
          });
        },
      );
    });

    // Your splash screen UI
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 100),
            const SizedBox(height: 20),
            const Text('HEALTHLY!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}