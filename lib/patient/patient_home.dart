import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Appointment_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff3E69FE),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
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
      final snapshot = await FirebaseFirestore.instance.collection('doctors').get();
      final data = snapshot.docs.map((doc) => Doctor(
        name: doc['name'] ?? '',
        specialty: doc['speciality'] ?? '',
        patients: doc['patients']?.toString() ?? '',
        imagePath: doc['imagePath'] ?? '',
        description: doc['description'] ?? '',
      )).toList();
      _topDoctors = data;
    } catch (e) {
      print('Firestore error in _fetchTopDoctors: $e');
      _doctorError = 'Failed to load doctors.';
    }
    setState(() { _loadingDoctors = false; });
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
    final greetingName = firstName ?? 'all!';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 6),
              const Text(
                "HEALTHIFY",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(0),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PatientProfilePage()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xfff2f2f2),
                    radius: 24,
                    child: Icon(Icons.person, color: Colors.grey, size: 28),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hello $greetingName',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue.shade100, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DoctorsPage()),
                      );
                    },
                    child: _MenuCard(
                      icon: Icons.medical_services,
                      label: 'Doctors',
                      color: Colors.red,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PharmacyPage()),
                      );
                    },
                    child: _MenuCard(
                      icon: Icons.local_pharmacy,
                      label: 'Pharmacy',
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BillingPage()),
                      );
                    },
                    child: _MenuCard(
                      icon: Icons.receipt,
                      label: 'Billing',
                      color: Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BedInfoPage()),
                      );
                    },
                    child: _MenuCard(
                      icon: Icons.bed,
                      label: 'Beds',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Top Doctors",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
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
                        children: _topDoctors.map((doctor) => _DoctorCardModern(doctor: doctor)).toList(),
                      ),
          ),
        ],
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
                  children: _doctors.map((doctor) => _DoctorCardModern(doctor: doctor)).toList(),
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
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3E69FE),
                minimumSize: const Size(160, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Go back', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DoctorCardModern extends StatelessWidget {
  final Doctor doctor;
  const _DoctorCardModern({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DoctorDetailPage(doctor: doctor)),
        );
      },
      child: Container(
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
              doctor.imagePath,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            doctor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.specialty,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
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

class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailPage({super.key, required this.doctor});

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
        title: const Text('Doctor Details', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                doctor.imagePath,
                height: 180,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            doctor.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.specialty,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 20),
              const SizedBox(width: 4),
              const Text('4.78 out of 5'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined),
              SizedBox(width: 8),
              Text('Monday, Dec 23'),
              SizedBox(width: 16),
              Icon(Icons.access_time),
              SizedBox(width: 8),
              Text('12:00 - 13:00'),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'About Me',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.description,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              print('Book Appointment button pressed');
              final user = FirebaseAuth.instance.currentUser;
              final patientId = user?.uid ?? 'unknown_patient';
              final patientName = user?.displayName ?? 'Unknown';
              final doctorId = doctor.name;
              final doctorName = doctor.name;
              final date = DateTime.now();
              final price = 100;

              try {
                // 1. Add appointment
                final apptRef = await FirebaseFirestore.instance.collection('appointments').add({
                  'patientId': patientId,
                  'patientName': patientName,
                  'doctorId': doctorId,
                  'doctorName': doctorName,
                  'date': date,
                  'status': 'Confirmed',
                  'type': 'appointment',
                });
                print('Appointment created: ${apptRef.id}');

                // 2. Add bill
                await FirebaseFirestore.instance.collection('bills').add({
                  'amount': price,
                  'appointmentId': apptRef.id,
                  'date': date,
                  'patientId': patientId,
                  'patientName': patientName,
                  'status': 'Unpaid',
                  'type': 'appointment',
                });
                print('Bill created: ${apptRef.id}');

                // 3. Show confirmation
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Success'),
                    content: const Text('Appointment booked and bill generated!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                print('Error booking appointment: $e');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text('Failed to book appointment: $e'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3E69FE),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Book Appointment', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
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