import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/sign-up.dart';
import 'screens/access_screen.dart';
import 'patient/patient_home.dart';
import 'staff/staff_dashboard.dart';
import 'superadmin/super_admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthy!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff3E69FE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff3E69FE),
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff3E69FE),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AccessScreen(),           // Intro screen
        '/login': (context) => const LoginPage(),         // Login for all roles
        '/signup': (context) => const SignUpPage(),       // Patient registration
        '/patient-home': (context) => const PatientHomePage(),
        '/staff-dashboard': (context) => const StaffDashboard(),
        '/super-admin': (context) => const SuperAdminDashboard(),
      },
    );
  }
}
