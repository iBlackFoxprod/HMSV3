import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateStaffAccount extends StatefulWidget {
  const CreateStaffAccount({super.key});

  @override
  State<CreateStaffAccount> createState() => _CreateStaffAccountState();
}

class _CreateStaffAccountState extends State<CreateStaffAccount> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();
  final _fullNameController = TextEditingController();
  final List<String> _roles = ['Doctor', 'Nurse', 'Receptionist', 'Lab Technician', 'Pharmacist', 'Other'];
  String? _selectedRole;

  bool _loading = false;

  Future<void> _createStaffAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'full-name': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _selectedRole ?? '',
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff account created')),
        );

        _emailController.clear();
        _passwordController.clear();
        _selectedRole = null;
        _fullNameController.clear();
      } catch (e) {
        String errorMsg = 'Error: $e';
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            errorMsg = 'This email is already in use.';
          } else if (e.code == 'invalid-email') {
            errorMsg = 'The email address is invalid.';
          } else if (e.code == 'weak-password') {
            errorMsg = 'The password is too weak.';
          } else {
            errorMsg = e.message ?? errorMsg;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Staff Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? 'Enter an email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Min 6 characters' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                )).toList(),
                onChanged: (val) => setState(() => _selectedRole = val),
                decoration: const InputDecoration(labelText: "Role"),
                validator: (value) => value == null || value.isEmpty ? 'Select a role' : null,
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? 'Enter full name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _createStaffAccount,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
