import 'package:flutter/material.dart';

class AppointmentBookingPage extends StatelessWidget {
  const AppointmentBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and back
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/logo.png', width: 120),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Doctor Profile
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/doctor1.jpg',
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dr. Michael Reeve',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  SizedBox(width: 4),
                  Text('4.78 out of 5'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.calendar_today_outlined),
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
              const Text(
                'Dr. Michael Reeve is the top most cardiologist specialist in Crist Hospital in London, UK. He achieved several awards for his wonderful contribution.',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle booking
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
        ),
      ),
    );
  }
}
