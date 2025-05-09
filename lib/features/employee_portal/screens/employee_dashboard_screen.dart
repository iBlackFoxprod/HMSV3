// lib/features/employee_portal/screens/employee_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmsv3/features/auth/providers/auth_providers.dart';

class EmployeeDashboardScreen extends ConsumerWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    final userAsyncValue = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
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
            'Welcome, ${user?.displayName ?? 'Employee'}!\nRole: ${user?.role.toString() ?? 'N/A'}\nDepartment: ${user?.department ?? 'N/A'}',
            textAlign: TextAlign.center,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error loading user: $err'),
        ),
      ),
      // TODO: Implement role-specific dashboard features
    );
  }
}