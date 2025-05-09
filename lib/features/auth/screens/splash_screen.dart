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
    ref.listen<AsyncValue<UserModel?>>(authStateChangesProvider, (_, state) {
      state.when(
        data: (user) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (user != null) {
              if (user.role == UserRole.patient) {
                context.go(AppRoutes.patientHome);
              } else {
                context.go(AppRoutes.employeeDashboard);
              }
            } else {
              context.go(AppRoutes.login);
            }
          });
        },
        loading: () {
          // Optional: handle loading state if needed
        },
        error: (err, stack) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(AppRoutes.login);
          });
        },
      );
    });

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
