// Combined Flutter File: Patient Portal Home with Navigation and Top Doctors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmsv3/features/auth/providers/auth_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Color palette
const Color kPrimaryColor = Color(0xFF384B70);
const Color kSecondaryColor = Color(0xFF507687);
const Color kBackgroundColor = Color(0xFFFCFAEE);
const Color kAccentColor = Color(0xFFB8001F);

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PatientNavScreen(),
      ),
    ),
  );
}

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

class PatientNavScreen extends StatefulWidget {
  const PatientNavScreen({super.key});

  @override
  State<PatientNavScreen> createState() => _PatientNavScreenState();
}

class _PatientNavScreenState extends State<PatientNavScreen> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  late final List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    _pages = [
      const PatientHomePage(),
      const AppointmentsScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: kBackgroundColor,
        color: kPrimaryColor,
        buttonBackgroundColor: kAccentColor,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.calendar_today, size: 30, color: Colors.white),
          Icon(Icons.favorite_border, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
        ],
        index: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pages[_page],
    );
  }
}

// Profile Screen Implementation
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _dbRef.child('users').child(user.uid).once();
      final data = snapshot.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          firstName = data['firstName'];
          lastName = data['lastName'];
          email = user.email;
          phoneNumber = data['phoneNumber'] ?? 'Not provided';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(authControllerProvider.notifier);
    final userAsyncValue = ref.watch(authStateChangesProvider);

    return SafeArea(
      child: userAsyncValue.when(
        data: (user) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "MY PROFILE", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${firstName ?? '...'} ${lastName ?? '...'}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Patient ID: #56789",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildProfileInfoCard(),
                      const SizedBox(height: 24),
                      _buildProfileMenuItems(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, "Email", email ?? "Loading..."),
            const Divider(),
            _buildInfoRow(Icons.phone, "Phone", phoneNumber ?? "Loading..."),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, "Date of Birth", "01/01/1990"),
            const Divider(),
            _buildInfoRow(Icons.bloodtype, "Blood Type", "O+"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.edit, "Edit Profile", () {}),
        _buildMenuItem(Icons.history, "Medical History", () {}),
        _buildMenuItem(Icons.settings, "Settings", () {}),
        _buildMenuItem(Icons.help_outline, "Help & Support", () {}),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

// Placeholder screens for other tabs
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: Colors.black87,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "APPOINTMENTS", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: const Center(
                child: Text("Appointments Coming Soon"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: Colors.black87,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "FAVORITES", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: const Center(
                child: Text("Favorites Coming Soon"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientHomePage extends ConsumerStatefulWidget {
  const PatientHomePage({super.key});

  @override
  ConsumerState<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends ConsumerState<PatientHomePage> {
  String? firstName;
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _loadUserFirstName();
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

  @override
  Widget build(BuildContext context) {
    final greetingName = firstName ?? '...';
    final authController = ref.read(authControllerProvider.notifier);
    final userAsyncValue = ref.watch(authStateChangesProvider);

    final List<Doctor> topDoctors = [
      Doctor(
        name: 'Dr. Aloshy Saadaoui',
        specialty: 'Pediatrician',
        patients: '345+',
        imagePath: 'assets/images/doctor1.jpg',
        description: 'Dr. Aloshy is a top pediatrician at Crist Hospital in London.',
      ),
      Doctor(
        name: 'Dr. Nathaniel Detwat',
        specialty: 'Dermatologist',
        patients: '269+',
        imagePath: 'assets/images/doctor2.jpg',
        description: 'Dr. Nathaniel specializes in skincare and dermatological treatments.',
      ),
      Doctor(
        name: 'Dr. Charlotte Baker',
        specialty: 'Cardiologist',
        patients: '410+',
        imagePath: 'assets/images/doctor3.jpg',
        description: 'Dr. Charlotte is a top heart specialist in London\'s Crist Hospital.',
      ),
    ];

    return SafeArea(
      child: userAsyncValue.when(
        data: (user) => Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHealthifyLogo(),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/user.jpg'),
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                              children: [
                                const TextSpan(text: 'Hello '),
                                TextSpan(
                                  text: '$greetingName!',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Top Doctors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...topDoctors.map(
                            (doctor) => _DoctorCard(
                              name: doctor.name,
                              specialty: doctor.specialty,
                              patients: doctor.patients,
                              imagePath: doctor.imagePath,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHealthifyLogo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
          child: const Icon(Icons.favorite, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 6),
        const Text("HEALTHIFY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name, specialty, patients, imagePath;

  const _DoctorCard({required this.name, required this.specialty, required this.patients, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          isScrollControlled: true,
          builder: (context) => BookingModal(
            doctorName: name,
            specialty: specialty,
            imagePath: imagePath,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 28,
            backgroundColor: kSecondaryColor.withOpacity(0.1),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
          subtitle: Text(specialty, style: const TextStyle(color: kSecondaryColor)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, color: kAccentColor, size: 18),
              Text(patients, style: const TextStyle(fontSize: 12, color: kPrimaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}

// Booking Modal Widget
class BookingModal extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String imagePath;

  const BookingModal({super.key, required this.doctorName, required this.specialty, required this.imagePath});

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isBooking = false;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _bookAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time.')),
      );
      return;
    }
    setState(() => isBooking = true);
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('appointments').add({
        'doctorName': widget.doctorName,
        'specialty': widget.specialty,
        'date': selectedDate!.toIso8601String(),
        'time': '${selectedTime!.hour}:${selectedTime!.minute}',
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    setState(() => isBooking = false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment booked with ${widget.doctorName}!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.imagePath),
                  radius: 32,
                  backgroundColor: kSecondaryColor.withOpacity(0.1),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kPrimaryColor)),
                    Text(widget.specialty, style: const TextStyle(color: kSecondaryColor)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.calendar_today, color: kPrimaryColor),
                    label: Text(selectedDate == null ? 'Select Date' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}', style: const TextStyle(color: kPrimaryColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: kPrimaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.access_time, color: kPrimaryColor),
                    label: Text(selectedTime == null ? 'Select Time' : selectedTime!.format(context), style: const TextStyle(color: kPrimaryColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: kPrimaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isBooking ? null : _bookAppointment,
                child: isBooking
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Book Appointment', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}