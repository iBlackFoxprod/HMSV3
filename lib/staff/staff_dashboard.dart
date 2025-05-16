import 'package:flutter/material.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        backgroundColor: const Color(0xff3E69FE),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Optionally, sign out staff if needed.
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Welcome, Staff Member 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            _buildDashboardTile(
              context,
              title: 'View Appointments',
              icon: Icons.calendar_today,
              onTap: () {
                // Add navigation
              },
            ),
            _buildDashboardTile(
              context,
              title: 'Patient Records',
              icon: Icons.folder_shared,
              onTap: () {
                // Add navigation
              },
            ),
            _buildDashboardTile(
              context,
              title: 'Prescriptions',
              icon: Icons.medical_services_outlined,
              onTap: () {
                // Add navigation
              },
            ),
            _buildDashboardTile(
              context,
              title: 'Messages',
              icon: Icons.chat_bubble_outline,
              onTap: () {
                // Add navigation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 28, color: const Color(0xff3E69FE)),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}