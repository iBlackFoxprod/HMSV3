import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  final String reason;
  final String status; // e.g., pending, confirmed, cancelled

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    required this.reason,
    this.status = 'pending',
  });

  Map<String, dynamic> toFirestore() => {
    'patientId': patientId,
    'doctorId': doctorId,
    'dateTime': Timestamp.fromDate(dateTime),
    'reason': reason,
    'status': status,
  };

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      patientId: data['patientId'],
      doctorId: data['doctorId'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      reason: data['reason'],
      status: data['status'] ?? 'pending',
    );
  }
} 