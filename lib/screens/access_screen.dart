import 'package:flutter/material.dart';
import '../main.dart'; // For going back to the splash screen
import 'login.dart'; // Make sure this file has LoginPage
import 'sign-up.dart'; // Make sure this file has SignUpPage

class AccessScreen extends StatelessWidget {
  const AccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/logo.png',
              width: 250,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/undraw_access_account_aydp.png',
              width: 280,
              height: 250,
            ),
            const SizedBox(height: 30),
            const Text(
              "Access your account\nor sign up",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3E69FE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3E69FE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
