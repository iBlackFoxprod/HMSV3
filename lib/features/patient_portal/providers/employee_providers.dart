// lib/features/employee_portal/providers/employee_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmsv3/core/enums/user_role_enum.dart';
import 'package:hmsv3/core/exceptions/firestore_exceptions.dart';
import 'package:hmsv3/core/models/user_model.dart';
import 'package:hmsv3/features/auth/providers/auth_providers.dart';

// States for employee dashboard
enum EmployeeDashboardStatus { initial, loading, loaded, error }

class EmployeeDashboardState {
  final EmployeeDashboardStatus status;
  final String? errorMessage;
  final List<UserModel> colleagues; // Users in the same department
  final Map<String, dynamic>? dashboardData; // Any other relevant dashboard data

  EmployeeDashboardState({
    this.status = EmployeeDashboardStatus.initial,
    this.errorMessage,
    this.colleagues = const [],
    this.dashboardData,
  });

  EmployeeDashboardState copyWith({
    EmployeeDashboardStatus? status,
    String? errorMessage,
    List<UserModel>? colleagues,
    Map<String, dynamic>? dashboardData,
  }) {
    return EmployeeDashboardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      colleagues: colleagues ?? this.colleagues,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }
}

class EmployeeDashboardController extends StateNotifier<EmployeeDashboardState> {
  final FirebaseFirestore _firestore;
  final UserModel? _currentUser;

  EmployeeDashboardController(this._firestore, this._currentUser)
      : super(EmployeeDashboardState());

  // Load dashboard data based on employee role
  Future<void> loadDashboardData() async {
    if (_currentUser == null) {
      state = state.copyWith(
        status: EmployeeDashboardStatus.error,
        errorMessage: 'User not authenticated',
      );
      return;
    }

    try {
      state = state.copyWith(status: EmployeeDashboardStatus.loading);

      // Fetch colleagues (users in the same department)
      final department = _currentUser.department;
      if (department != null) {
        final colleaguesSnapshot = await _firestore
            .collection('users')
            .where('department', isEqualTo: department)
            .where('uid', isNotEqualTo: _currentUser.uid) // Exclude current user
            .get();

        final colleagues = colleaguesSnapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList();

        // TODO: Fetch other dashboard data based on employee role
        Map<String, dynamic> dashboardData = {};
        
        // Different data for different roles
        switch (_currentUser.role) {
          case UserRole.doctor:
            // Fetch doctor-specific data (e.g., appointments, patients)
            // dashboardData['appointments'] = await _fetchDoctorAppointments();
            break;
          case UserRole.nurse:
            // Fetch nurse-specific data
            break;
          case UserRole.finance:
            // Fetch finance-specific data
            break;
          // Add cases for other roles as needed
          default:
            // Default data for all employees
            break;
        }

        state = state.copyWith(
          status: EmployeeDashboardStatus.loaded,
          colleagues: colleagues,
          dashboardData: dashboardData,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: EmployeeDashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // Other methods for employee-specific actions
  // ...
}

// Provider for the employee dashboard controller
final employeeDashboardControllerProvider = StateNotifierProvider<
    EmployeeDashboardController, EmployeeDashboardState>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final userAsyncValue = ref.watch(authStateChangesProvider);
  
  // Get the current user from the auth state
  final currentUser = userAsyncValue.asData?.value;
  
  return EmployeeDashboardController(firestore, currentUser);
});

// Stream provider for real-time updates to employee data
final employeeDataStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final userAsyncValue = ref.watch(authStateChangesProvider);
  final currentUser = userAsyncValue.asData?.value;
  
  if (currentUser == null || currentUser.department == null) {
    return Stream.value({});
  }
  
  // Example of a real-time data stream for an employee dashboard
  // Customize this based on what data is relevant for different employee roles
  return firestore
      .collection('departments')
      .doc(currentUser.department)
      .snapshots()
      .map((snapshot) => snapshot.data() ?? {});
});