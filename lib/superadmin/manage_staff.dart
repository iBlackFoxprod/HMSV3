import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStaff extends StatelessWidget {
  const ManageStaff({super.key});

  Future<void> _deleteStaff(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Staff'),
        content: const Text('Are you sure you want to delete this staff account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff deleted')));
    }
  }

  void _showEditStaffDialog(BuildContext context, String staffId, Map<String, dynamic> data) {
    final _nameController = TextEditingController(text: data['full-name'] ?? '');
    final _emailController = TextEditingController(text: data['email'] ?? '');
    final List<String> _roles = ['Doctor', 'Nurse', 'Receptionist', 'Lab Technician', 'Pharmacist', 'Other'];
    String? _selectedRole = data['role'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Staff'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roles.map((role) => DropdownMenuItem(
                value: role,
                child: Text(role),
              )).toList(),
              onChanged: (val) => _selectedRole = val,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(staffId).update({
                'full-name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'role': _selectedRole ?? '',
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff updated')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showManageShiftsDialog(BuildContext context, String staffId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: ShiftManagementForStaff(staffId: staffId, staffName: data['full-name'] ?? data['email'] ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Staff")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', whereIn: ['Doctor', 'Nurse', 'Receptionist', 'Lab Technician', 'Pharmacist', 'Other'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No staff accounts found"));
          }

          final staffList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              final data = staff.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['full-name'] ?? data['email'] ?? 'No Name'),
                subtitle: Text('Email: ${data['email'] ?? 'N/A'}\nRole: ${data['role'] ?? 'N/A'}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditStaffDialog(context, staff.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.schedule, color: Colors.deepPurple),
                      onPressed: () => _showManageShiftsDialog(context, staff.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteStaff(context, staff.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ShiftManagementForStaff extends StatefulWidget {
  final String staffId;
  final String staffName;
  const ShiftManagementForStaff({super.key, required this.staffId, required this.staffName});

  @override
  State<ShiftManagementForStaff> createState() => _ShiftManagementForStaffState();
}

class _ShiftManagementForStaffState extends State<ShiftManagementForStaff> {
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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shifts')
          .where('staffId', isEqualTo: widget.staffId)
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

  Future<void> _addOrEditShift({Map<String, dynamic>? shift}) async {
    final _formKey = GlobalKey<FormState>();
    DateTime? _date = shift != null ? (shift['date'] as Timestamp?)?.toDate() : null;
    TimeOfDay? _startTime = shift != null ? TimeOfDay.fromDateTime((shift['startTime'] as Timestamp).toDate()) : null;
    TimeOfDay? _endTime = shift != null ? TimeOfDay.fromDateTime((shift['endTime'] as Timestamp).toDate()) : null;
    String _status = shift != null ? shift['status'] ?? 'assigned' : 'assigned';
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(shift == null ? 'Add Shift' : 'Edit Shift'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: Text(_date == null ? 'Pick Date' : _date!.toString().substring(0, 10)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: ctx,
                    initialTime: _startTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _startTime = picked);
                },
                child: Text(_startTime == null ? 'Pick Start Time' : _startTime!.format(ctx)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: ctx,
                    initialTime: _endTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _endTime = picked);
                },
                child: Text(_endTime == null ? 'Pick End Time' : _endTime!.format(ctx)),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                  DropdownMenuItem(value: 'completed', child: Text('Completed')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                ],
                onChanged: (val) => setState(() => _status = val ?? 'assigned'),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_date == null || _startTime == null || _endTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
                return;
              }
              final startDateTime = DateTime(_date!.year, _date!.month, _date!.day, _startTime!.hour, _startTime!.minute);
              final endDateTime = DateTime(_date!.year, _date!.month, _date!.day, _endTime!.hour, _endTime!.minute);
              if (shift == null) {
                await FirebaseFirestore.instance.collection('shifts').add({
                  'staffId': widget.staffId,
                  'staffName': widget.staffName,
                  'date': _date,
                  'startTime': startDateTime,
                  'endTime': endDateTime,
                  'status': _status,
                });
              } else {
                await FirebaseFirestore.instance.collection('shifts').doc(shift['id']).update({
                  'date': _date,
                  'startTime': startDateTime,
                  'endTime': endDateTime,
                  'status': _status,
                });
              }
              Navigator.of(ctx).pop();
              await _loadShifts();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteShift(String shiftId) async {
    await FirebaseFirestore.instance.collection('shifts').doc(shiftId).delete();
    await _loadShifts();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shift deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Shifts for ${widget.staffName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Text(_error!, style: const TextStyle(color: Colors.red))
                    : Expanded(
                        child: _shifts.isEmpty
                            ? const Text('No shifts assigned.')
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _shifts.length,
                                itemBuilder: (context, index) {
                                  final shift = _shifts[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      title: Text('Date: ${shift['date'] != null ? (shift['date'] as Timestamp).toDate().toString().substring(0, 10) : 'N/A'}'),
                                      subtitle: Text('Start: ${shift['startTime'] != null ? (shift['startTime'] as Timestamp).toDate().toString().substring(11, 16) : 'N/A'} | End: ${shift['endTime'] != null ? (shift['endTime'] as Timestamp).toDate().toString().substring(11, 16) : 'N/A'}\nStatus: ${shift['status'] ?? 'N/A'}'),
                                      isThreeLine: true,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => _addOrEditShift(shift: shift),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _deleteShift(shift['id']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _addOrEditShift(),
              icon: const Icon(Icons.add),
              label: const Text('Add Shift'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
