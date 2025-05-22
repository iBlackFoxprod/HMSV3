import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF507687),
                child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                radius: 28,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hello,',
                    style: TextStyle(fontSize: 18, color: Color(0xFF507687)),
                  ),
                  Text(
                    'Super Admin',
                    style: TextStyle(
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
          _SuperAdminCard(
            icon: Icons.add_box,
            label: 'Assign Shift',
            color: const Color(0xFFFDE7E7),
            iconColor: const Color(0xFFB8001F),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssignShiftPage()),
              );
            },
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
    );
  }
}

class _SuperAdminCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  const _SuperAdminCard({required this.icon, required this.label, required this.color, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 24),
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF384B70)),
            const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}

class AssignShiftPage extends StatefulWidget {
  const AssignShiftPage({super.key});

  @override
  State<AssignShiftPage> createState() => _AssignShiftPageState();
}

class _AssignShiftPageState extends State<AssignShiftPage> {
  String? _selectedStaffId;
  String? _selectedStaffName;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _status = 'assigned';
  bool _loading = false;
  String? _error;
  List<Map<String, dynamic>> _staffList = [];

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    setState(() { _loading = true; });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'staff')
          .get();
      setState(() {
        _staffList = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load staff: $e';
        _loading = false;
      });
    }
  }

  Future<void> _assignShift() async {
    if (_selectedStaffId == null || _selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }
    setState(() { _loading = true; });
    try {
      final startDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _startTime!.hour, _startTime!.minute);
      final endDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _endTime!.hour, _endTime!.minute);
      await FirebaseFirestore.instance.collection('shifts').add({
        'staffId': _selectedStaffId,
        'staffName': _selectedStaffName,
        'date': _selectedDate,
        'startTime': startDateTime,
        'endTime': endDateTime,
        'status': _status,
      });
      setState(() {
        _selectedStaffId = null;
        _selectedStaffName = null;
        _selectedDate = null;
        _startTime = null;
        _endTime = null;
        _status = 'assigned';
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shift assigned successfully!')));
    } catch (e) {
      setState(() { _loading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to assign shift: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Shift'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Staff:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedStaffId,
                      items: _staffList.map((staff) {
                        return DropdownMenuItem<String>(
                          value: staff['id'],
                          child: Text(staff['full-name'] ?? staff['email'] ?? staff['id']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final staff = _staffList.firstWhere((s) => s['id'] == val);
                        setState(() {
                          _selectedStaffId = val;
                          _selectedStaffName = staff['full-name'] ?? staff['email'] ?? '';
                        });
                      },
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => _selectedDate = picked);
                            },
                            child: Text(_selectedDate == null ? 'Pick Date' : _selectedDate!.toString().substring(0, 10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Start Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) setState(() => _startTime = picked);
                            },
                            child: Text(_startTime == null ? 'Pick Start Time' : _startTime!.format(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('End Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) setState(() => _endTime = picked);
                            },
                            child: Text(_endTime == null ? 'Pick End Time' : _endTime!.format(context)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                        DropdownMenuItem(value: 'completed', child: Text('Completed')),
                        DropdownMenuItem(value: 'pending', child: Text('Pending')),
                      ],
                      onChanged: (val) => setState(() => _status = val ?? 'assigned'),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _assignShift,
                        child: const Text('Assign Shift'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 