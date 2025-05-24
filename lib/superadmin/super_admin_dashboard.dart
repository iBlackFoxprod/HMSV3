import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.people,
        'title': 'User Management',
        'desc': 'Add, remove, and update staff and patient profiles.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUsersPage()));
        },
      },
      {
        'icon': Icons.apartment,
        'title': 'Department Management',
        'desc': 'Organize staff by department.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DepartmentManagementPage()));
        },
      },
      {
        'icon': Icons.receipt_long,
        'title': 'Billing System',
        'desc': 'Manage patient & internal billing.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingSystemPage()));
        },
      },
      {
        'icon': Icons.medical_services,
        'title': 'Storage Management',
        'desc': 'Track medicine inventory/expiry.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StorageManagementPage()));
        },
      },
      {
        'icon': Icons.bed,
        'title': 'Bed Management',
        'desc': 'Monitor all bed statuses in real-time.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BedManagementAdminPage()));
        },
      },
      {
        'icon': Icons.task,
        'title': 'Task Management',
        'desc': 'Create, assign, and monitor staff tasks.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksOverviewPage()));
        },
      },
      {
        'icon': Icons.message,
        'title': 'Message Logs',
        'desc': 'Access communication logs (for compliance).',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesMonitoringPage()));
        },
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Reports Generation',
        'desc': 'Generate reports (finance, beds, medicine).',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsPage()));
        },
      },
      {
        'icon': Icons.settings,
        'title': 'System Settings',
        'desc': 'Manage settings, backups, and user roles.',
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        },
      },
    ];

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
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.admin_panel_settings, color: Color(0xFF507687), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ADMIN / SUPER ADMIN DASHBOARD – Full system access:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: features.map((feature) {
              final title = feature['title'] as String;
              final desc = feature['desc'] as String;
              final bool applyFlexibleText = title == 'Department Management' || title == 'Storage Management';

              return GestureDetector(
                onTap: feature['onTap'] as VoidCallback,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xff3E69FE).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(feature['icon'] as IconData, color: const Color(0xff3E69FE), size: 28),
                      ),
                      const SizedBox(height: 10),
                      applyFlexibleText
                          ? Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff3E69FE),
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xff3E69FE),
                              ),
                            ),
                      const SizedBox(height: 6),
                      applyFlexibleText
                          ? Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  desc,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          : Text(
                              desc,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
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

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});
  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xff3E69FE).withOpacity(0.1),
                    child: Icon(Icons.person, color: const Color(0xff3E69FE)),
                  ),
                  title: Text(data['full-name'] ?? data['email'] ?? 'No Name'),
                  subtitle: Text('Role: ${data['role'] ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted')));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DepartmentManagementPage extends StatefulWidget {
  const DepartmentManagementPage({super.key});
  @override
  State<DepartmentManagementPage> createState() => _DepartmentManagementPageState();
}

class _DepartmentManagementPageState extends State<DepartmentManagementPage> {
  final _deptController = TextEditingController();
  @override
  void dispose() {
    _deptController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Department Management'), backgroundColor: const Color(0xff3E69FE)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _deptController,
                    decoration: const InputDecoration(labelText: 'Add Department', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_deptController.text.trim().isEmpty) return;
                    await FirebaseFirestore.instance.collection('departments').add({'name': _deptController.text.trim()});
                    _deptController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('departments').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final depts = snapshot.data!.docs;
                if (depts.isEmpty) return const Center(child: Text('No departments found.'));
                return ListView.builder(
                  itemCount: depts.length,
                  itemBuilder: (context, i) {
                    final dept = depts[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ExpansionTile(
                        title: Text(dept['name'] ?? ''),
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').where('department', isEqualTo: dept['name']).snapshots(),
                            builder: (context, snap) {
                              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                              final staff = snap.data!.docs;
                              if (staff.isEmpty) return const Padding(padding: EdgeInsets.all(8), child: Text('No staff in this department.'));
                              return Column(
                                children: staff.map((s) => ListTile(
                                  title: Text(s['full-name'] ?? s['email'] ?? 'No Name'),
                                  subtitle: Text('Role: ${s['role'] ?? 'N/A'}'),
                                )).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BillingSystemPage extends StatelessWidget {
  const BillingSystemPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing System'), backgroundColor: const Color(0xff3E69FE)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bills').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bills = snapshot.data!.docs;
          if (bills.isEmpty) return const Center(child: Text('No bills found.'));
          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, i) {
              final bill = bills[i].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Bill #${bills[i].id}'),
                  subtitle: Text('Amount: ${bill['amount'] ?? 'N/A'} | Patient: ${bill['patient'] ?? 'N/A'}'),
                  trailing: Text(bill['status'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StorageManagementPage extends StatefulWidget {
  const StorageManagementPage({super.key});
  @override
  State<StorageManagementPage> createState() => _StorageManagementPageState();
}

class _StorageManagementPageState extends State<StorageManagementPage> {
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _expiryController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _expiryController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Management'), backgroundColor: const Color(0xff3E69FE)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Medicine Name', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: const InputDecoration(labelText: 'Expiry (YYYY-MM-DD)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty || _qtyController.text.isEmpty || _expiryController.text.isEmpty) return;
                    await FirebaseFirestore.instance.collection('medicines').add({
                      'name': _nameController.text.trim(),
                      'quantity': int.tryParse(_qtyController.text.trim()) ?? 0,
                      'expiry': _expiryController.text.trim(),
                    });
                    _nameController.clear();
                    _qtyController.clear();
                    _expiryController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('medicines').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final meds = snapshot.data!.docs;
                if (meds.isEmpty) return const Center(child: Text('No medicines found.'));
                return ListView.builder(
                  itemCount: meds.length,
                  itemBuilder: (context, i) {
                    final med = meds[i].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(med['name'] ?? ''),
                        subtitle: Text('Qty: ${med['quantity'] ?? 0} | Expiry: ${med['expiry'] ?? ''}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('medicines').doc(meds[i].id).delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BedManagementAdminPage extends StatelessWidget {
  const BedManagementAdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bed Management'), backgroundColor: const Color(0xff3E69FE)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('beds').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final beds = snapshot.data!.docs;
          if (beds.isEmpty) return const Center(child: Text('No beds found.'));
          return ListView.builder(
            itemCount: beds.length,
            itemBuilder: (context, i) {
              final bed = beds[i].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Bed #${beds[i].id}'),
                  subtitle: Text('Status: ${bed['status'] ?? 'N/A'} | Ward: ${bed['ward'] ?? 'N/A'}'),
                  trailing: DropdownButton<String>(
                    value: bed['status'] ?? 'Available',
                    items: const [
                      DropdownMenuItem(value: 'Available', child: Text('Available')),
                      DropdownMenuItem(value: 'Occupied', child: Text('Occupied')),
                      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                    ],
                    onChanged: (val) async {
                      await FirebaseFirestore.instance.collection('beds').doc(beds[i].id).update({'status': val});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TasksOverviewPage extends StatefulWidget {
  const TasksOverviewPage({super.key});
  @override
  State<TasksOverviewPage> createState() => _TasksOverviewPageState();
}

class _TasksOverviewPageState extends State<TasksOverviewPage> {
  final _taskController = TextEditingController();
  String? _selectedStaffId;
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Management'), backgroundColor: const Color(0xff3E69FE)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Task', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'staff').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final staff = snapshot.data!.docs;
                      return DropdownButton<String>(
                        value: _selectedStaffId,
                        hint: const Text('Assign to'),
                        items: staff.map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(s['full-name'] ?? s['email'] ?? 'No Name'),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedStaffId = val),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_taskController.text.isEmpty || _selectedStaffId == null) return;
                    await FirebaseFirestore.instance.collection('tasks').add({
                      'title': _taskController.text.trim(),
                      'staffId': _selectedStaffId,
                      'createdAt': DateTime.now(),
                    });
                    _taskController.clear();
                    setState(() => _selectedStaffId = null);
                  },
                  child: const Text('Assign'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final tasks = snapshot.data!.docs;
                if (tasks.isEmpty) return const Center(child: Text('No tasks found.'));
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, i) {
                    final task = tasks[i].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(task['title'] ?? ''),
                        subtitle: Text('Staff ID: ${task['staffId'] ?? ''}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('tasks').doc(tasks[i].id).delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesMonitoringPage extends StatelessWidget {
  const MessagesMonitoringPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Logs'), backgroundColor: const Color(0xff3E69FE)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('conversations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final convs = snapshot.data!.docs;
          if (convs.isEmpty) return const Center(child: Text('No conversations found.'));
          return ListView.builder(
            itemCount: convs.length,
            itemBuilder: (context, i) {
              final conv = convs[i].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Conversation #${convs[i].id}'),
                  subtitle: Text('Participants: ${(conv['participantNames'] as List<dynamic>?)?.join(", ") ?? ''}'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ConversationDetailPage(conversationId: convs[i].id)));
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

class ConversationDetailPage extends StatelessWidget {
  final String conversationId;
  const ConversationDetailPage({super.key, required this.conversationId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation $conversationId'), backgroundColor: const Color(0xff3E69FE)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('conversations').doc(conversationId).collection('messages').orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final msgs = snapshot.data!.docs;
          if (msgs.isEmpty) return const Center(child: Text('No messages.'));
          return ListView.builder(
            itemCount: msgs.length,
            itemBuilder: (context, i) {
              final msg = msgs[i].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(msg['text'] ?? ''),
                subtitle: Text('By: ${msg['senderName'] ?? ''}'),
                trailing: Text(msg['timestamp']?.toDate().toString().substring(0, 16) ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  Future<Map<String, int>> _getCounts() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    final beds = await FirebaseFirestore.instance.collection('beds').get();
    final tasks = await FirebaseFirestore.instance.collection('tasks').get();
    final meds = await FirebaseFirestore.instance.collection('medicines').get();
    final bills = await FirebaseFirestore.instance.collection('bills').get();
    return {
      'Users': users.size,
      'Beds': beds.size,
      'Tasks': tasks.size,
      'Medicines': meds.size,
      'Bills': bills.size,
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports'), backgroundColor: const Color(0xff3E69FE)),
      body: FutureBuilder<Map<String, int>>(
        future: _getCounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: data.entries.map((e) => Card(
              child: ListTile(
                title: Text(e.key),
                trailing: Text(e.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            )).toList(),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Settings'), backgroundColor: const Color(0xff3E69FE)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            leading: const Icon(Icons.backup, color: Color(0xff3E69FE)),
            title: const Text('Backup Data'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup started (demo only).')));
            },
          ),
          const SizedBox(height: 24),
          const Text('Role Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final users = snapshot.data!.docs;
              if (users.isEmpty) return const Center(child: Text('No users found.'));
              return Column(
                children: users.map((user) {
                  final data = user.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xff3E69FE)),
                      title: Text(data['full-name'] ?? data['email'] ?? 'No Name'),
                      subtitle: Text('Current Role: ${data['role'] ?? 'N/A'}'),
                      trailing: DropdownButton<String>(
                        value: data['role'] ?? 'Patient',
                        items: const [
                          DropdownMenuItem(value: 'Patient', child: Text('Patient')),
                          DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                          DropdownMenuItem(value: 'SuperAdmin', child: Text('SuperAdmin')),
                        ],
                        onChanged: (val) async {
                          if (val != null) {
                            await FirebaseFirestore.instance.collection('users').doc(user.id).update({'role': val});
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Role updated to $val')));
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
} 