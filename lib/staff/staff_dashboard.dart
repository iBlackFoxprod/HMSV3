import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appointment_management.dart';
import 'prescriptions_page.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final staffName = user?.displayName ?? 'Staff';
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/images/logo.png', height: 48),
        ),
        title: const Text('', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFB8001F)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF507687),
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                  radius: 28,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    ),
                    Text(
                      staffName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF384B70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _DashboardCard(
                  icon: Icons.calendar_today,
                  label: 'View Appointments',
                  color: const Color(0xFFFDE7E7),
                  iconColor: const Color(0xFFB8001F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AppointmentManagementPage()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.folder_shared,
                  label: 'Patient Records',
                  color: const Color(0xFFE7F0FD),
                  iconColor: const Color(0xFF384B70),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MedicalRecordPage()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.medical_services_outlined,
                  label: 'Prescriptions',
                  color: const Color(0xFFE7FDEB),
                  iconColor: const Color(0xFF507687),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrescriptionsPage()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.chat_bubble_outline,
                  label: 'Messages',
                  color: const Color(0xFFFDE7E7),
                  iconColor: const Color(0xFFB8001F),
                  onTap: () {},
                ),
                _DashboardCard(
                  icon: Icons.access_time,
                  label: 'Attendance Clock',
                  color: const Color(0xFFE7F0FD),
                  iconColor: const Color(0xFF384B70),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AttendanceClockPage()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.task_alt,
                  label: 'Task List',
                  color: const Color(0xFFE7FDEB),
                  iconColor: const Color(0xFF507687),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskListPage()),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.schedule,
                  label: 'Shift Management',
                  color: const Color(0xFFFDE7E7),
                  iconColor: const Color(0xFFB8001F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShiftManagementPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Hospital Management System',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  const _DashboardCard({required this.icon, required this.label, required this.color, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'patient')
            .snapshots(),
        builder: (context, snapshot) {
          print('StreamBuilder state: ${snapshot.connectionState}');
          print('Has data: ${snapshot.hasData}');
          print('Has error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print('Number of patients: ${snapshot.data!.docs.length}');
            snapshot.data!.docs.forEach((doc) {
              print('Patient data: ${doc.data()}');
            });
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No patients found'));
          }
          final patients = snapshot.data!.docs;
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final patientData = patient.data() as Map<String, dynamic>;
              print('Building patient card for: ${patientData['full-name']}');
              return Card(
                child: ListTile(
                  title: Text(patientData['full-name'] ?? 'No Name'),
                  subtitle: Text('Age: ${patientData['age'] ?? 'N/A'} | Email: ${patientData['email'] ?? 'N/A'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientMedicalRecordPage(
                          patientId: patient.id,
                          patientName: patientData['full-name'] ?? 'No Name',
                        ),
                      ),
                    );
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

class PatientMedicalRecordPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  const PatientMedicalRecordPage({super.key, required this.patientId, required this.patientName});

  @override
  State<PatientMedicalRecordPage> createState() => _PatientMedicalRecordPageState();
}

class _PatientMedicalRecordPageState extends State<PatientMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _medicalRecord;
  bool _loading = true;
  String? _error;
  final _recordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMedicalRecord();
  }

  Future<void> _fetchMedicalRecord() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.patientId).get();
      final data = doc.data();
      setState(() {
        _medicalRecord = data != null && data['medicalRecord'] != null ? Map<String, dynamic>.from(data['medicalRecord']) : {};
        _recordController.text = _medicalRecord?['notes'] ?? '';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load medical record.';
        _loading = false;
      });
    }
  }

  Future<void> _saveMedicalRecord() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.patientId).update({
        'medicalRecord': {
          'notes': _recordController.text,
          'lastUpdated': DateTime.now(),
        }
      });
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medical record updated')));
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.patientName} Medical Record'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Medical Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _recordController,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter medical notes...',
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Cannot be empty' : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _saveMedicalRecord,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class AttendanceClockPage extends StatefulWidget {
  const AttendanceClockPage({super.key});

  @override
  State<AttendanceClockPage> createState() => _AttendanceClockPageState();
}

class _AttendanceClockPageState extends State<AttendanceClockPage> {
  bool _isClockedIn = false;
  DateTime? _lastClockIn;
  List<Map<String, dynamic>> _attendanceHistory = [];
  bool _loading = true;
  Map<String, double> _weeklyHours = {};
  Map<String, int> _monthlyAttendance = {};

  @override
  void initState() {
    super.initState();
    _checkCurrentStatus();
    _loadAttendanceHistory();
    _calculateWorkHours();
    _calculateMonthlyAttendance();
  }

  Future<void> _checkCurrentStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('staffId', isEqualTo: user.uid)
          .get();

      // Filter and sort in memory
      final todayRecords = querySnapshot.docs
          .where((doc) {
            final date = (doc.data()['date'] as Timestamp).toDate();
            return date.isAfter(startOfDay) && date.isBefore(startOfDay.add(const Duration(days: 1)));
          })
          .toList()
        ..sort((a, b) {
          final aDate = (a.data()['date'] as Timestamp).toDate();
          final bDate = (b.data()['date'] as Timestamp).toDate();
          return bDate.compareTo(aDate);
        });

      if (todayRecords.isNotEmpty) {
        final lastRecord = todayRecords.first.data();
        setState(() {
          _isClockedIn = lastRecord['type'] == 'clock_in';
          _lastClockIn = lastRecord['date']?.toDate();
        });
      }
    } catch (e) {
      print('Error checking status: $e');
    }
    setState(() => _loading = false);
  }

  Future<void> _loadAttendanceHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('staffId', isEqualTo: user.uid)
          .get();

      // Sort in memory
      final sortedDocs = querySnapshot.docs.toList()
        ..sort((a, b) {
          final aDate = (a.data()['date'] as Timestamp).toDate();
          final bDate = (b.data()['date'] as Timestamp).toDate();
          return bDate.compareTo(aDate);
        });

      setState(() {
        _attendanceHistory = sortedDocs
            .take(10) // Limit to 10 most recent records
            .map((doc) => doc.data())
            .toList();
      });
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  Future<void> _clockInOut() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final type = _isClockedIn ? 'clock_out' : 'clock_in';

      await FirebaseFirestore.instance.collection('attendance').add({
        'staffId': user.uid,
        'staffName': user.displayName ?? 'Unknown Staff',
        'type': type,
        'date': now,
      });

      await _checkCurrentStatus();
      await _loadAttendanceHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully clocked ${_isClockedIn ? 'out' : 'in'}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _calculateWorkHours() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('staffId', isEqualTo: user.uid)
          .get();

      // Filter and process in memory
      Map<String, List<DateTime>> dailyRecords = {};
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        
        // Only process records within the current week
        if (date.isAfter(startOfWeek) && date.isBefore(endOfWeek)) {
          final day = date.toString().substring(0, 10);
          if (!dailyRecords.containsKey(day)) {
            dailyRecords[day] = [];
          }
          dailyRecords[day]!.add(date);
        }
      }

      Map<String, double> hours = {};
      dailyRecords.forEach((day, records) {
        if (records.length >= 2) {
          // Sort records by time
          records.sort((a, b) => a.compareTo(b));
          
          // Calculate hours between first and last record of the day
          final duration = records.last.difference(records.first);
          hours[day] = duration.inMinutes / 60.0;
        }
      });

      setState(() {
        _weeklyHours = hours;
      });
    } catch (e) {
      print('Error calculating work hours: $e');
    }
  }

  Future<void> _calculateMonthlyAttendance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('staffId', isEqualTo: user.uid)
          .get();

      // Filter and process in memory
      Map<String, int> attendance = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        
        // Only process records within the current month and clock-in events
        if (date.isAfter(startOfMonth) && 
            date.isBefore(endOfMonth) && 
            data['type'] == 'clock_in') {
          final day = date.toString().substring(0, 10);
          attendance[day] = (attendance[day] ?? 0) + 1;
        }
      }

      setState(() {
        _monthlyAttendance = attendance;
      });
    } catch (e) {
      print('Error calculating monthly attendance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Clock'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Clock In/Out Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _isClockedIn ? 'Currently Clocked In' : 'Currently Clocked Out',
                            style: TextStyle(
                              fontSize: 18,
                              color: _isClockedIn ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_lastClockIn != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Last ${_isClockedIn ? 'clock in' : 'clock out'}: ${_lastClockIn!.toString().substring(0, 16)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _clockInOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isClockedIn ? Colors.red : Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              _isClockedIn ? 'Clock Out' : 'Clock In',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Work Hours Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'This Week\'s Work Hours',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._weeklyHours.entries.map((entry) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key),
                                    Text('${entry.value.toStringAsFixed(1)} hours'),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Hours',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_weeklyHours.values.fold(0.0, (sum, hours) => sum + hours).toStringAsFixed(1)} hours',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Monthly Attendance Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Attendance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._monthlyAttendance.entries.map((entry) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key),
                                    Text('${entry.value} times'),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Days',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_monthlyAttendance.length} days',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recent History
                  const Text(
                    'Recent History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._attendanceHistory.map((record) {
                    final date = (record['date'] as Timestamp).toDate();
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          record['type'] == 'clock_in' ? Icons.login : Icons.logout,
                          color: record['type'] == 'clock_in' ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          record['type'] == 'clock_in' ? 'Clock In' : 'Clock Out',
                          style: TextStyle(
                            color: record['type'] == 'clock_in' ? Colors.green : Colors.red,
                          ),
                        ),
                        subtitle: Text(date.toString().substring(0, 16)),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _taskController = TextEditingController();
  bool _loading = true;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('staffId', isEqualTo: user.uid)
          .get();

      setState(() {
        _tasks = querySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList()
          ..sort((a, b) {
            final aDate = (a['createdAt'] as Timestamp).toDate();
            final bDate = (b['createdAt'] as Timestamp).toDate();
            return bDate.compareTo(aDate); // Sort in descending order
          });
        _loading = false;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _taskController.text.trim(),
        'completed': false,
        'staffId': user.uid,
        'staffName': user.displayName ?? 'Unknown Staff',
        'createdAt': DateTime.now(),
      });

      _taskController.clear();
      await _loadTasks();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding task: $e')),
      );
    }
  }

  Future<void> _toggleTask(String taskId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'completed': !currentStatus,
        'completedAt': !currentStatus ? DateTime.now() : null,
      });

      await _loadTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $e')),
      );
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      await _loadTasks();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Add Task Input
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Add a new task...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _addTask(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3E69FE),
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                // Task Statistics
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total Tasks',
                        _tasks.length.toString(),
                        Icons.list_alt,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Completed',
                        _tasks.where((task) => task['completed'] == true).length.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Pending',
                        _tasks.where((task) => task['completed'] == false).length.toString(),
                        Icons.pending,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Task List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final createdAt = (task['createdAt'] as Timestamp).toDate();
                      final completedAt = task['completedAt'] != null
                          ? (task['completedAt'] as Timestamp).toDate()
                          : null;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: task['completed'] ?? false,
                            onChanged: (value) => _toggleTask(task['id'], task['completed']),
                          ),
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              decoration: task['completed'] == true
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Created: ${createdAt.toString().substring(0, 16)}'),
                              if (completedAt != null)
                                Text(
                                  'Completed: ${completedAt.toString().substring(0, 16)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(task['id']),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShiftManagementPage extends StatefulWidget {
  const ShiftManagementPage({super.key});

  @override
  State<ShiftManagementPage> createState() => _ShiftManagementPageState();
}

class _ShiftManagementPageState extends State<ShiftManagementPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _shifts = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadShifts();
  }

  Future<void> _loadShifts() async {
    setState(() { _loading = true; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shifts')
          .where('staffId', isEqualTo: user.uid)
          .get();
      setState(() {
        _shifts = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load shifts: $e';
        _loading = false;
      });
    }
  }

  Future<void> _requestShiftChange(Map<String, dynamic> shift) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance.collection('shift_requests').add({
        'shiftId': shift['id'],
        'staffId': user.uid,
        'staffName': user.displayName ?? 'Unknown Staff',
        'requestedAt': DateTime.now(),
        'status': 'pending',
        'originalDate': shift['date'],
        'originalStart': shift['startTime'],
        'originalEnd': shift['endTime'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shift change request sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request shift change: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Management'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _shifts.isEmpty
                  ? const Center(child: Text('No shifts assigned.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _shifts.length,
                      itemBuilder: (context, index) {
                        final shift = _shifts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text('Date: ${shift['date'] ?? 'N/A'}'),
                            subtitle: Text('Start: ${shift['startTime'] ?? 'N/A'} | End: ${shift['endTime'] ?? 'N/A'}\nStatus: ${shift['status'] ?? 'N/A'}'),
                            isThreeLine: true,
                            trailing: ElevatedButton(
                              onPressed: () => _requestShiftChange(shift),
                              child: const Text('Request Change'),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}