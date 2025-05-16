import 'package:flutter/material.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        backgroundColor: const Color(0xff3E69FE),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Welcome, Super Admin 👑',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _buildDashboardTile(
              context,
              title: 'Create Staff Account',
              icon: Icons.person_add,
              onTap: () {
                // Navigate to staff creation form
                Navigator.pushNamed(context, '/create-staff');
              },
            ),
            _buildDashboardTile(
              context,
              title: 'Manage Staff Accounts',
              icon: Icons.people_outline,
              onTap: () {
                // Navigate to staff list view
                Navigator.pushNamed(context, '/manage-staff');
              },
            ),
            _buildDashboardTile(
              context,
              title: 'System Settings',
              icon: Icons.settings,
              onTap: () {
                // Optional: settings page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Icon(icon, color: const Color(0xff3E69FE), size: 28),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}