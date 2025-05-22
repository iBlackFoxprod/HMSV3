import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Appointment_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'billing_info.dart';
import 'widgets/patient_bottom_nav_bar.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PatientNavScreen(),
  ));
}

// ---------------------- doctor ------------------------
class Doctor {
  final String name;
  final String specialty;
  final String imagePath;
  final String patients;
  final String description;

  Doctor({
    required this.name,
    required this.specialty,
    required this.imagePath,
    required this.patients,
    required this.description,
  });
}

// ---------------------- navigation -------------------
class PatientNavScreen extends StatefulWidget {
  const PatientNavScreen({super.key});

  @override
  State<PatientNavScreen> createState() => _PatientNavScreenState();
}

class _PatientNavScreenState extends State<PatientNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    PatientHomePage(),
    AppointmentHistoryPage(),
    AppointmentBookingPage(),
    PatientProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _pages[_selectedIndex],
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Placeholder for Appointment History Page
class AppointmentHistoryPage extends StatelessWidget {
  const AppointmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment History'), backgroundColor: const Color(0xff3E69FE)),
      body: const Center(child: Text('Appointment History Page')),
    );
  }
}

// Replace ProfilePage with PatientProfilePage
class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});
  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.reference();
  Map<String, dynamic>? _userData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _dbRef.child('users').child(user.uid).once();
        final data = snapshot.snapshot.value as Map?;
        if (data != null) {
          _userData = Map<String, dynamic>.from(data);
        }
      }
    } catch (e) {
      _error = 'Failed to load profile.';
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _userData == null
                  ? const Center(child: Text('No profile data found.'))
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: const Color(0xfff2f2f2),
                            child: Icon(Icons.person, color: Colors.grey.shade400, size: 48),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userData?['firstName'] != null && _userData?['lastName'] != null
                                      ? '${_userData?['firstName']} ${_userData?['lastName']}'
                                      : 'No Name',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(_userData?['email'] ?? '', style: const TextStyle(fontSize: 16)),
                                const Divider(height: 32),
                                _ProfileField(label: 'Gender', value: _userData?['gender'] ?? 'N/A'),
                                _ProfileField(label: 'Age', value: _userData?['age']?.toString() ?? 'N/A'),
                                _ProfileField(label: 'Role', value: _userData?['role'] ?? 'N/A'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff3E69FE),
                              minimumSize: const Size(140, 44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Edit', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileField({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}

// ---------------------- Patient Home Page -------------------
class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  String? firstName;
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.reference();
  List<Doctor> _topDoctors = [];
  bool _loadingDoctors = true;
  String? _doctorError;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _doctorsSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserFirstName();
    _fetchTopDoctors();
  }

  void _loadUserFirstName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _dbRef.child('users').child(user.uid).once();
      final data = snapshot.snapshot.value as Map?;
      if (data != null && data.containsKey('firstName')) {
        setState(() {
          firstName = data['firstName'];
        });
      }
    }
  }

  Future<void> _fetchTopDoctors() async {
    try {
      // First, try to fetch from Firestore
      final snapshot = await FirebaseFirestore.instance.collection('doctors').get();
      List<Doctor> firestoreDoctors = [];
      if (snapshot.docs.isNotEmpty) {
        firestoreDoctors = snapshot.docs.map((doc) {
          final data = doc.data();
          return Doctor(
            name: data['name'] ?? '',
            specialty: data['speciality'] ?? '',
            patients: data['patients']?.toString() ?? '',
            imagePath: 'assets/images/undraw_doctors_djoj.png',
            description: data['description'] ?? '',
          );
        }).toList();
      }
      // Default/random doctors
      final defaultDoctors = [
        Doctor(
          name: 'Dr. Aloshy Saadaoui',
          specialty: 'Pediatrician',
          patients: '345+',
          imagePath: 'assets/images/undraw_doctors_djoj.png',
          description: 'Dr. Aloshy is a top pediatrician at Crist Hospital in London.',
        ),
        Doctor(
          name: 'Dr. Salim Aït Benali',
          specialty: 'Dermatologist',
          patients: '290+',
          imagePath: 'assets/images/undraw_doctors_djoj.png',
          description: 'Dr. Salim specializes in skincare and dermatological treatments.',
        ),
        Doctor(
          name: 'Dr. Charlotte Baker',
          specialty: 'Cardiologist',
          patients: '410+',
          imagePath: 'assets/images/undraw_doctors_djoj.png',
          description: 'Dr. Charlotte is a top heart specialist in London\'s Crist Hospital.',
        ),
        Doctor(
          name: 'Dr. Michael Reeve',
          specialty: 'Orthopedic Surgeon',
          patients: '320+',
          imagePath: 'assets/images/undraw_doctors_djoj.png',
          description: 'Dr. Michael specializes in joint replacement and sports injuries.',
        ),
        Doctor(
          name: 'Dr. Sarah Johnson',
          specialty: 'Neurologist',
          patients: '280+',
          imagePath: 'assets/images/undraw_doctors_djoj.png',
          description: 'Dr. Sarah is an expert in neurological disorders and treatments.',
        ),
      ];
      // Merge, avoiding duplicates by name
      final allNames = firestoreDoctors.map((d) => d.name).toSet();
      final mergedDoctors = [
        ...firestoreDoctors,
        ...defaultDoctors.where((d) => !allNames.contains(d.name)),
      ];
      if (mounted) {
        setState(() {
          _topDoctors = mergedDoctors;
          _loadingDoctors = false;
        });
      }
    } catch (e) {
      print('Firestore error in _fetchTopDoctors: $e');
      if (mounted) {
        setState(() {
          _doctorError = 'Failed to load doctors.';
          _loadingDoctors = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToDoctors() {
    final context = _doctorsSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    final greetingName = firstName ?? 'Paddy';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Text('1', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientProfilePage()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=facearea&w=256&h=256&facepad=2&q=80'),
                radius: 18,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(0),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Row(
              children: [
                Text(
                  'Hello ',
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                ),
                Text(
                  greetingName,
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const Text('!', style: TextStyle(fontSize: 20, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HomeMenuCard(
                  icon: Icons.medical_services,
                  label: 'Doctors',
                  color: const Color(0xFFFDE7E7),
                  iconColor: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DoctorsPage()),
                    );
                  },
                ),
                _HomeMenuCard(
                  icon: Icons.local_pharmacy,
                  label: 'Pharmacy',
                  color: const Color(0xFFE7F0FD),
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PharmacyPage()),
                    );
                  },
                ),
                _HomeMenuCard(
                  icon: Icons.receipt,
                  label: 'Billing',
                  color: const Color(0xFFE7FDEB),
                  iconColor: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BillingInfoPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Top Doctors",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            key: _doctorsSectionKey,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _loadingDoctors
                ? const Center(child: CircularProgressIndicator())
                : _doctorError != null
                    ? Center(child: Text(_doctorError!))
                    : Column(
                        children: _topDoctors.map((doctor) => _DoctorCardModernEnhanced(doctor: doctor)).toList(),
                      ),
          ),
        ],
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  const _HomeMenuCard({required this.icon, required this.label, required this.color, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCardModernEnhanced extends StatelessWidget {
  final Doctor doctor;
  const _DoctorCardModernEnhanced({required this.doctor});

  Future<void> _bookAppointment(BuildContext context, DateTime selectedDateTime) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to book.')),
      );
      return;
    }
    final patientId = user.uid;
    final patientName = user.displayName ?? user.email ?? 'Unknown';
    final doctorName = doctor.name;
    final doctorSpecialty = doctor.specialty;
    final date = selectedDateTime;
    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'patientId': patientId,
        'patientName': patientName,
        'doctorName': doctorName,
        'doctorSpecialty': doctorSpecialty,
        'date': date,
        'status': 'Confirmed',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment booked with $doctorName!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book: $e')),
        );
      }
    }
  }

  void _showBookingDialog(BuildContext context) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            String dateText = selectedDate == null
                ? 'Pick a date'
                : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
            String timeText = selectedTime == null
                ? 'Pick a time'
                : selectedTime!.format(ctx);
            bool canBook = selectedDate != null && selectedTime != null;
            return AlertDialog(
              title: Text('Book Appointment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Book appointment with ${doctor.name}'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateText),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: now,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(timeText),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canBook ? const Color(0xff3E69FE) : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: canBook
                      ? () async {
                          Navigator.pop(ctx);
                          final selectedDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          await _bookAppointment(context, selectedDateTime);
                        }
                      : null,
                  child: const Text('Book'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBookingDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              doctor.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            doctor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.specialty,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Patients ${doctor.patients}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});
  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<Doctor> _doctors = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('doctors').get();
      _doctors = snapshot.docs.map((doc) => Doctor(
        name: doc['name'] ?? '',
        specialty: doc['speciality'] ?? '',
        patients: doc['patients']?.toString() ?? '',
        imagePath: doc['imagePath'] ?? 'assets/images/doctor1.jpg',
        description: doc['description'] ?? '',
      )).toList();
    } catch (e) {
      print('Firestore error in _fetchDoctors: $e');
      _error = 'Failed to load doctors.';
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Doctors', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _doctors.map((doctor) => _DoctorCardModernEnhanced(doctor: doctor)).toList(),
                ),
    );
  }
}

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/booking_confirmed.png', height: 180),
            const SizedBox(height: 32),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3E69FE),
                minimumSize: const Size(160, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Logout', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class Medicine {
  final String name;
  final String type;
  final String imagePath;
  final bool available;

  Medicine({required this.name, required this.type, required this.imagePath, required this.available});

  factory Medicine.fromMap(Map data) {
    return Medicine(
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      imagePath: data['imagePath'] ?? 'assets/images/medicine.png',
      available: data['available'] ?? true,
    );
  }
}

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});
  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  final _dbRef = FirebaseDatabase.instance.reference();
  List<Medicine> _medicines = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    try {
      final snapshot = await _dbRef.child('medicines').once();
      final data = snapshot.snapshot.value as Map?;
      if (data != null) {
        _medicines = data.values.map((e) => Medicine.fromMap(Map<String, dynamic>.from(e))).toList();
      }
    } catch (e) {
      _error = 'Failed to load medicines.';
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pharmacy'), backgroundColor: const Color(0xff3E69FE)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _medicines.map((med) => _MedicineCard(medicine: med)).toList(),
                ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final Medicine medicine;
  const _MedicineCard({required this.medicine});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            medicine.imagePath,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          medicine.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.type,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  medicine.available ? Icons.check_circle : Icons.cancel,
                  color: medicine.available ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  medicine.available ? 'Available' : 'Out of stock',
                  style: TextStyle(
                    fontSize: 13,
                    color: medicine.available ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: medicine.available
                  ? () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in to purchase.')),
                        );
                        return;
                      }
                      final patientId = user.uid;
                      final patientName = user.displayName ?? 'Unknown';
                      final medicineId = medicine.name;
                      final price = 50;
                      final date = DateTime.now();
                      try {
                        await FirebaseFirestore.instance.collection('bills').add({
                          'amount': price,
                          'medicineId': medicineId,
                          'date': date,
                          'patientId': patientId,
                          'patientName': patientName,
                          'status': 'Unpaid',
                          'type': 'medicine',
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Medicine purchased! Bill generated.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to purchase: $e')),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(120, 36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Buy', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});
  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Billing'), backgroundColor: const Color(0xff3E69FE)),
        body: const Center(child: Text('Not logged in')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Billing'), backgroundColor: const Color(0xff3E69FE)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bills')
            .where('patientId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bills = snapshot.data?.docs ?? [];
          if (bills.isEmpty) {
            return const Center(child: Text('No bills found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Icon(Icons.receipt, color: Colors.blue, size: 36),
                  title: Text('Bill #${bill['number'] ?? (index + 1)}'),
                  subtitle: Text('Amount: ${bill['amount'] ?? 'N/A'}\nStatus: ${bill['status'] ?? 'N/A'}'),
                  trailing: Text(
                    bill['date'] != null ? bill['date'].toString().substring(0, 10) : '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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

class BedInfoPage extends StatefulWidget {
  const BedInfoPage({super.key});
  @override
  State<BedInfoPage> createState() => _BedInfoPageState();
}

class _BedInfoPageState extends State<BedInfoPage> {
  List<Map<String, dynamic>> _beds = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBeds();
  }

  Future<void> _fetchBeds() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('beds').get();
      _beds = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      _error = 'Failed to load bed info.';
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bed Info'), backgroundColor: const Color(0xff3E69FE)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _beds.length,
                  itemBuilder: (context, index) {
                    final bed = _beds[index];
                    print('Appointment doc: ${bed}');
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: Icon(
                          bed['available'] == true ? Icons.bed : Icons.bed_outlined,
                          color: bed['available'] == true ? Colors.green : Colors.red,
                          size: 36,
                        ),
                        title: Text('Bed #${bed['number'] ?? (index + 1)}'),
                        subtitle: Text('Type: ${bed['type'] ?? 'N/A'}'),
                        trailing: Text(
                          bed['available'] == true ? 'Available' : 'Occupied',
                          style: TextStyle(
                            color: bed['available'] == true ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// MedicalRecordPage: List all patients from users collection
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

// PatientMedicalRecordPage: View/Edit a patient's medical record
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