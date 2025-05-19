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
            .collection('staff')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text.trim(),
          'role': _roleController.text.trim(),
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff account created')),
        );

        _emailController.clear();
        _passwordController.clear();
        _roleController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: "Role (e.g. Doctor, Nurse)"),
                validator: (value) =>
                    value!.isEmpty ? 'Enter role' : null,
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
