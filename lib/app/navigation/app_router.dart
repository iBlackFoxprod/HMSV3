import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hmsv3/app/navigation/app_routes.dart';
import 'package:hmsv3/core/models/user_model.dart';
import 'package:hmsv3/core/enums/user_role_enum.dart';
import 'package:hmsv3/features/auth/providers/auth_providers.dart';
import 'package:hmsv3/features/auth/screens/login_screen.dart';
import 'package:hmsv3/features/auth/screens/registration_screen.dart';
import 'package:hmsv3/features/auth/screens/splash_screen.dart';
import 'package:hmsv3/features/patient_portal/screens/patient_home_screen.dart';
import 'package:hmsv3/features/employee_portal/screens/employee_dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;

      // Wait for auth to finish loading before redirecting
      if (authState.isLoading || authState.hasError) return null;

      final user = authState.asData?.value;
      final isLoggedIn = user != null;

      final publicRoutes = {
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
      };

      final isPublicRoute = publicRoutes.contains(location);

      // If on splash, let the SplashScreen decide where to go
      if (location == AppRoutes.splash) return null;

      // Not logged in and trying to access protected routes
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.login;
      }

      // Logged in and trying to go to login or register
      if (isLoggedIn && (location == AppRoutes.login || location == AppRoutes.register)) {
        return user.role == UserRole.patient
            ? AppRoutes.patientHome
            : AppRoutes.employeeDashboard;
      }

      return null; // no redirect
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientHome,
        builder: (context, state) => const PatientHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.employeeDashboard,
        builder: (context, state) => const EmployeeDashboardScreen(),
      ),
    ],
  );
});
