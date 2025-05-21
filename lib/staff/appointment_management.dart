import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentManagementPage extends StatefulWidget {
  const AppointmentManagementPage({super.key});

  @override
  State<AppointmentManagementPage> createState() => _AppointmentManagementPageState();
}

class _AppointmentManagementPageState extends State<AppointmentManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Management'), backgroundColor: const Color(0xff3E69FE)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('appointments').orderBy('date', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }
          final appointments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Patient: '
                      + ((appt.data() as Map<String, dynamic>).containsKey('patientName') ? appt['patientName'] : 'N/A')),
                  subtitle: Text('Date: '
                      + ((appt.data() as Map<String, dynamic>).containsKey('date') ? appt['date'].toString() : 'N/A')
                      + '\nStatus: '
                      + ((appt.data() as Map<String, dynamic>).containsKey('status') ? appt['status'] : 'Pending')),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'Approve') {
                        await appt.reference.update({'status': 'Approved'});
                      } else if (value == 'Cancel') {
                        await appt.reference.update({'status': 'Cancelled'});
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Approve', child: Text('Approve')),
                      const PopupMenuItem(value: 'Cancel', child: Text('Cancel')),
                    ],
                  ),
                  onTap: () {
                    // Optionally show more details or reschedule
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 