// lib/features/patient_portal/screens/patient_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmsv3/features/auth/providers/auth_providers.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    final userAsyncValue = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              // GoRouter will handle navigation to login via redirect
            },
          ),
        ],
      ),
      body: Center(
        child: userAsyncValue.when(
          data: (user) => Text(
            'Welcome, ${user?.displayName ?? 'Patient'}!\nRole: ${user?.role.toString() ?? 'N/A'}',
            textAlign: TextAlign.center,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error loading user: $err'),
        ),
      ),
      // TODO: Implement BottomNavigationBar and actual patient features
    );
  }
}