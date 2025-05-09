// lib/core/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmsv3/core/enums/user_role_enum.dart'; // Create this enum

class UserModel {
  final String uid;
  final String? email;
  final String? displayName; // Could be first name + last name
  final String? photoURL;
  final UserRole role; // You'll need a UserRole enum
  final String? department; // Specific to employees, can be null

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.role = UserRole.patient, // Default role, adjust as needed
    this.department,
  });

  // Factory constructor to create a UserModel from a Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoURL: data['photoURL'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == data['role'],
        orElse: () => UserRole.patient, // Default if role is missing or invalid
      ),
      department: data['department'] as String?,
    );
  }

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid, // Storing uid in the document as well can be useful
      if (email != null) 'email': email,
      if (displayName != null) 'displayName': displayName,
      if (photoURL != null) 'photoURL': photoURL,
      'role': role.toString(),
      if (department != null) 'department': department,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    UserRole? role,
    String? department,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      department: department ?? this.department,
    );
  }
}