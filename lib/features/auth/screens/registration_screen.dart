// lib/features/auth/screens/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hmsv3/features/auth/providers/auth_providers.dart';
// Import your shared widgets if you have them

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // final _ageController = TextEditingController(); // If needed at registration
  // String? _selectedGender; // If needed at registration

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // _ageController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authControllerProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            // Pass age and gender if collected
          );

      if (success && mounted) {
        // GoRouter will redirect to home on successful authStateChange
        // Optionally, show a success message before redirect or let GoRouter handle it
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Registration successful! Logging you in...')),
        // );
      } else if (mounted) {
        final error = ref.read(authControllerProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registration'), // Or just "Register"
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                 Text(
                  'HEALTHLY!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Enter first name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Enter last name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                     suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Confirm password';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Age and Gender if you want to include them from your mockup
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextFormField(
                //         controller: _ageController,
                //         decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                //         keyboardType: TextInputType.number,
                //         validator: (value) => value == null || value.isEmpty ? 'Enter age' : null,
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     Expanded(
                //       child: DropdownButtonFormField<String>(
                //         decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                //         value: _selectedGender,
                //         items: ['Male', 'Female', 'Other']
                //             .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                //             .toList(),
                //         onChanged: (value) => setState(() => _selectedGender = value),
                //         validator: (value) => value == null ? 'Select gender' : null,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: authState.status == AuthStatus.loading ? null : _register,
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
                      : const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}