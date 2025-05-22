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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessagesPage()),
                    );
                  },
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
                _DashboardCard(
                  icon: Icons.bed,
                  label: 'Bed Management',
                  color: const Color(0xFFE7F0FD),
                  iconColor: const Color(0xFF384B70),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BedManagementPage()),
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
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
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
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: const Color(0xff3E69FE),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'patient')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No patients found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }
          final patients = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final patientData = patient.data() as Map<String, dynamic>;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xff3E69FE).withOpacity(0.1),
                    child: Text(
                      patientData['full-name']?.toString().substring(0, 1).toUpperCase() ?? '?',
                      style: const TextStyle(
                        color: Color(0xff3E69FE),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    patientData['full-name'] ?? 'No Name',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Age: ${patientData['age'] ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Email: ${patientData['email'] ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xff3E69FE).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xff3E69FE),
                    ),
                  ),
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

class BedManagementPage extends StatefulWidget {
  const BedManagementPage({super.key});

  @override
  State<BedManagementPage> createState() => _BedManagementPageState();
}

class _BedManagementPageState extends State<BedManagementPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _beds = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBeds();
  }

  Future<void> _loadBeds() async {
    setState(() { _loading = true; });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('beds')
          .orderBy('bedNumber')
          .get();

      setState(() {
        _beds = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load beds: $e';
        _loading = false;
      });
    }
  }

  Future<void> _updateBedStatus(String bedId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('beds').doc(bedId).update({
        'status': newStatus,
        'lastUpdated': DateTime.now(),
        'updatedBy': FirebaseAuth.instance.currentUser?.uid,
      });

      // Log the bed status change
      await FirebaseFirestore.instance.collection('bed_logs').add({
        'bedId': bedId,
        'previousStatus': _beds.firstWhere((bed) => bed['id'] == bedId)['status'],
        'newStatus': newStatus,
        'updatedBy': FirebaseAuth.instance.currentUser?.uid,
        'updatedAt': DateTime.now(),
      });

      await _loadBeds();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bed status updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update bed status: $e')),
      );
    }
  }

  Future<void> _addNewBed() async {
    try {
      // Get the next bed number
      final lastBed = _beds.isNotEmpty 
          ? _beds.reduce((curr, next) => 
              int.parse(curr['bedNumber'].toString()) > int.parse(next['bedNumber'].toString()) 
                  ? curr 
                  : next)
          : null;
      
      final nextBedNumber = lastBed != null 
          ? int.parse(lastBed['bedNumber'].toString()) + 1 
          : 1;

      await FirebaseFirestore.instance.collection('beds').add({
        'bedNumber': nextBedNumber.toString(),
        'status': 'Available',
        'ward': 'General',
        'createdAt': DateTime.now(),
        'createdBy': FirebaseAuth.instance.currentUser?.uid,
      });

      await _loadBeds();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New bed added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add new bed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        title: const Text('Bed Management'),
        backgroundColor: const Color(0xff3E69FE),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBed,
        backgroundColor: const Color(0xff3E69FE),
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xff3E69FE),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Total Beds',
                            _beds.length.toString(),
                            Icons.bed,
                            Colors.white,
                          ),
                          _buildStatCard(
                            'Available',
                            _beds.where((bed) => bed['status'] == 'Available').length.toString(),
                            Icons.check_circle,
                            Colors.white,
                          ),
                          _buildStatCard(
                            'Occupied',
                            _beds.where((bed) => bed['status'] == 'Occupied').length.toString(),
                            Icons.person,
                            Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _beds.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.bed_outlined, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No beds available',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _beds.length,
                              itemBuilder: (context, index) {
                                final bed = _beds[index];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: CircleAvatar(
                                      backgroundColor: bed['status'] == 'Available'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      child: Text(
                                        bed['bedNumber'],
                                        style: TextStyle(
                                          color: bed['status'] == 'Available'
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      'Bed ${bed['bedNumber']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          'Ward: ${bed['ward']}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          'Status: ${bed['status']}',
                                          style: TextStyle(
                                            color: bed['status'] == 'Available'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (value) => _updateBedStatus(bed['id'], value),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'Available',
                                          child: Row(
                                            children: [
                                              Icon(Icons.check_circle, color: Colors.green),
                                              SizedBox(width: 8),
                                              Text('Mark as Available'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Occupied',
                                          child: Row(
                                            children: [
                                              Icon(Icons.person, color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Mark as Occupied'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Maintenance',
                                          child: Row(
                                            children: [
                                              Icon(Icons.build, color: Colors.orange),
                                              SizedBox(width: 8),
                                              Text('Mark as Under Maintenance'),
                                            ],
                                          ),
                                        ),
                                      ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _messageController = TextEditingController();
  bool _loading = true;
  List<Map<String, dynamic>> _conversations = [];
  String? _error;
  String? _selectedUserId;
  List<Map<String, dynamic>> _messages = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    setState(() { _loading = true; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('conversations')
          .where('participants', arrayContains: user.uid)
          .orderBy('lastMessageTime', descending: true)
          .get();

      setState(() {
        _conversations = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load conversations: $e';
        _loading = false;
      });
    }
  }

  Future<void> _loadMessages(String conversationId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      setState(() {
        _messages = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
      });

      // Scroll to bottom
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: $e')),
      );
    }
  }

  Future<void> _sendMessage(String conversationId) async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final message = {
        'text': _messageController.text.trim(),
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Unknown',
        'timestamp': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add(message);

      // Update conversation's last message
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .update({
        'lastMessage': message['text'],
        'lastMessageTime': message['timestamp'],
      });

      _messageController.clear();
      await _loadMessages(conversationId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  Future<void> _startNewConversation(String userId, String userName) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Check if conversation already exists
      final existingQuery = await FirebaseFirestore.instance
          .collection('conversations')
          .where('participants', arrayContains: currentUser.uid)
          .get();

      QueryDocumentSnapshot? existingConversation;
      try {
        existingConversation = existingQuery.docs.firstWhere(
          (doc) {
            final data = doc.data();
            return data['participants'].contains(userId);
          },
        );
      } catch (e) {
        // No existing conversation found
        existingConversation = null;
      }

      if (existingConversation != null) {
        setState(() {
          _selectedUserId = existingConversation!.id;
        });
        await _loadMessages(existingConversation.id);
        return;
      }

      // Create new conversation
      final conversationRef = await FirebaseFirestore.instance
          .collection('conversations')
          .add({
        'participants': [currentUser.uid, userId],
        'participantNames': [currentUser.displayName ?? 'Unknown', userName],
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
        'createdAt': DateTime.now(),
      });

      setState(() {
        _selectedUserId = conversationRef.id;
      });
      await _loadMessages(conversationRef.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start conversation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xff3E69FE),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    // Conversations List
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // New Message Button
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('New Message'),
                                    content: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        final users = snapshot.data!.docs;
                                        return SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: users.length,
                                            itemBuilder: (context, index) {
                                              final user = users[index].data()
                                                  as Map<String, dynamic>;
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: const Color(0xff3E69FE)
                                                      .withOpacity(0.1),
                                                  child: Text(
                                                    user['firstName']?[0] ?? '?',
                                                    style: const TextStyle(
                                                      color: Color(0xff3E69FE),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                    '${user['firstName']} ${user['lastName']}'),
                                                subtitle: Text(user['role'] ?? ''),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _startNewConversation(
                                                    users[index].id,
                                                    '${user['firstName']} ${user['lastName']}',
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('New Message'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3E69FE),
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            child: _conversations.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.chat_bubble_outline,
                                            size: 64,
                                            color: Colors.grey.shade400),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No conversations yet',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _conversations.length,
                                    itemBuilder: (context, index) {
                                      final conversation = _conversations[index];
                                      final otherParticipant = conversation[
                                              'participantNames']
                                          .firstWhere(
                                              (name) =>
                                                  name !=
                                                  FirebaseAuth.instance.currentUser
                                                      ?.displayName,
                                              orElse: () => 'Unknown');
                                      return ListTile(
                                        selected: conversation['id'] == _selectedUserId,
                                        selectedTileColor: const Color(0xff3E69FE)
                                            .withOpacity(0.1),
                                        leading: CircleAvatar(
                                          backgroundColor: const Color(0xff3E69FE)
                                              .withOpacity(0.1),
                                          child: Text(
                                            otherParticipant[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Color(0xff3E69FE),
                                            ),
                                          ),
                                        ),
                                        title: Text(otherParticipant),
                                        subtitle: Text(
                                          conversation['lastMessage'] ?? 'No messages yet',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedUserId = conversation['id'];
                                          });
                                          _loadMessages(conversation['id']);
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    // Messages Area
                    Expanded(
                      child: _selectedUserId == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat_bubble_outline,
                                      size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Select a conversation or start a new one',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: _messages.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.chat_bubble_outline,
                                                  size: 64,
                                                  color: Colors.grey.shade400),
                                              const SizedBox(height: 16),
                                              Text(
                                                'No messages yet',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          controller: _scrollController,
                                          padding: const EdgeInsets.all(16),
                                          itemCount: _messages.length,
                                          itemBuilder: (context, index) {
                                            final message = _messages[index];
                                            final isMe = message['senderId'] ==
                                                FirebaseAuth.instance.currentUser?.uid;
                                            return Align(
                                              alignment: isMe
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: isMe
                                                      ? const Color(0xff3E69FE)
                                                      : Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: isMe
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      message['text'],
                                                      style: TextStyle(
                                                        color: isMe
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      message['senderName'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: isMe
                                                            ? Colors.white70
                                                            : Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          decoration: InputDecoration(
                                            hintText: 'Type a message...',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade100,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                        backgroundColor: const Color(0xff3E69FE),
                                        child: IconButton(
                                          icon: const Icon(Icons.send,
                                              color: Colors.white),
                                          onPressed: () =>
                                              _sendMessage(_selectedUserId!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
    );
  }
}