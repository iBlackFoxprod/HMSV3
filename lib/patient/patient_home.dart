import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
    Placeholder(),
    Placeholder(),
    Placeholder(),
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
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
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

    final List<Doctor> topDoctors = [
      Doctor(
        name: 'Dr. Aloshy Saadaoui',
        specialty: 'Pediatrician',
        patients: '345+',
        imagePath: 'assets/images/doctor1.jpg',
        description: 'Dr. Aloshy is a top pediatrician at Crist Hospital in London.',
      ),
      Doctor(
        name: 'Dr. Salim Aït Benali',
        specialty: 'Dermatologist',
        patients: '290+',
        imagePath: 'assets/images/doctor2.jpg',
        description: 'Dr. Salim specializes in skincare and dermatological treatments.',
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHealthifyLogo(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
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
                  _buildMenuContainer(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Top Doctors",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...topDoctors.map((doctor) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DoctorDetailPage(doctor: doctor),
                                  ),
                                );
                              },
                              child: _DoctorCard(
                                name: doctor.name,
                                specialty: doctor.specialty,
                                patients: doctor.patients,
                                imagePath: doctor.imagePath,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthifyLogo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          "HEALTHIFY",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _HomeMenuButton(
            icon: Icons.medical_services,
            iconColor: Colors.red,
            label: 'Doctors',
          ),
          _HomeMenuButton(
            icon: Icons.local_pharmacy,
            iconColor: Colors.blue,
            label: 'Pharmacy',
          ),
          _HomeMenuButton(
            icon: Icons.receipt,
            iconColor: Colors.green,
            label: 'Billing',
          ),
        ],
      ),
    );
  }
}

class _HomeMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _HomeMenuButton({
    required this.icon,
    required this.label,
    required this.iconColor,w
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String patients;
  final String imagePath;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.patients,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Patients $patients',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Doctor Detail Page -------------------
class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    "Doctor Detail",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        doctor.imagePath,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Patients: ${doctor.patients}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      doctor.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Booking feature coming soon!")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xff3E69FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Book Appointment",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}