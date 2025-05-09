import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hmsv3/app/navigation/app_routes.dart';
import 'package:hmsv3/core/models/user_model.dart'; // Ensure this is correct
import 'package:hmsv3/core/enums/user_role_enum.dart'; // Ensure this is correct
import 'package:hmsv3/features/auth/providers/auth_providers.dart';
import 'package:hmsv3/features/auth/screens/login_screen.dart';
import 'package:hmsv3/features/auth/screens/registration_screen.dart';
import 'package:hmsv3/features/auth/screens/splash_screen.dart';
import 'package:hmsv3/features/patient_portal/screens/patient_home_screen.dart';
import 'package:hmsv3/features/employee_portal/screens/employee_dashboard_screen.dart'; // Placeholder screen

// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true, // Helpful for debugging routes
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.asData?.value != null;
      final user = authState.asData?.value;

      // Define public routes that don't require login
      final publicRoutes = [AppRoutes.splash, AppRoutes.login, AppRoutes.register];
      final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

      // If on splash screen, let it decide where to go (usually based on auth state)
      if (state.matchedLocation == AppRoutes.splash) {
        return null; // SplashScreen will handle its own redirection
      }

      // If user is not logged in and trying to access a protected route
      if (!isLoggedIn && !isGoingToPublicRoute) {
        return AppRoutes.login; // Redirect to login
      }

      // If user is logged in and tries to access login/register, redirect to home
      if (isLoggedIn && (state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.register)) {
        // Redirect based on role if you have different home screens
        if (user?.role == UserRole.patient) { // Ensure UserRole enum is accessible
          return AppRoutes.patientHome;
        } else {
          // TODO: Redirect to employee dashboard or appropriate screen
          return AppRoutes.employeeDashboard; // Placeholder
        }
      }
      return null; // No redirection needed
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
        builder: (context, state) => const PatientHomeScreen(), // Create this screen
      ),
      // TODO: Add route for EmployeeDashboardScreen
      // GoRoute(
      //   path: AppRoutes.employeeDashboard,
      //   builder: (context, state) => const EmployeeDashboardScreen(),
      // ),
    ],
  );
});