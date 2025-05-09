// lib/core/exceptions/firestore_exceptions.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Custom exception for Firestore operations
class FirestoreException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  FirestoreException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'FirestoreException: $message (code: $code)';

  /// Factory to create FirestoreException from FirebaseException
  factory FirestoreException.fromFirebaseException(FirebaseException e) {
    String message;
    
    switch (e.code) {
      case 'permission-denied':
        message = 'You do not have permission to access this resource';
        break;
      case 'unavailable':
        message = 'The service is currently unavailable. Please try again later';
        break;
      case 'not-found':
        message = 'The requested document does not exist';
        break;
      case 'already-exists':
        message = 'The document already exists';
        break;
      case 'cancelled':
        message = 'The operation was cancelled';
        break;
      default:
        message = e.message ?? 'An unknown error occurred';
    }

    return FirestoreException(
      message: message,
      code: e.code,
      originalError: e,
    );
  }
}

/// Helper class to handle Firestore errors
class FirestoreErrorHandler {
  static Exception handleError(dynamic error) {
    if (error is FirebaseException) {
      return FirestoreException.fromFirebaseException(error);
    }
    
    return FirestoreException(
      message: error.toString(),
      originalError: error,
    );
  }
}