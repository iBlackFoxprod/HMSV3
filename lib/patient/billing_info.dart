import 'package:flutter/material.dart';
import 'widgets/patient_bottom_nav_bar.dart';

class BillingInfoPage extends StatefulWidget {
  const BillingInfoPage({super.key});

  @override
  State<BillingInfoPage> createState() => _BillingInfoPageState();
}

class _BillingInfoPageState extends State<BillingInfoPage> {
  String selectedDepartment = 'Cardiology';
  final List<String> departments = [
    'Orthopedics',
    'Cardiology',
    'Neurology',
    'Pediatrics',
  ];

  int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    // Navigation logic
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/patient-home');
    } else if (index == 1) {
      // Calendar or booking
      Navigator.pushReplacementNamed(context, '/appointment-booking');
    } else if (index == 2) {
      // Billing (current)
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/images/logo.png', height: 32),
        ),
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MetricCard(
                  title: 'Total Revenue',
                  value: '4XXXXX',
                  subtitle: '+5% from last month',
                  subtitleColor: Colors.green,
                ),
                const SizedBox(width: 12),
                _MetricCard(
                  title: 'Patient Satisfaction',
                  value: '92%',
                  subtitle: '+2% from last quarter',
                  subtitleColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Search By Department',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: departments.map((dept) {
                  final isSelected = dept == selectedDepartment;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(dept),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFFC107),
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.blue,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() => selectedDepartment = dept);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 8),
            _TransactionTile(paymentId: 'XXXX', amount: '4XXX', date: 'XX/XX/XXXX'),
            _TransactionTile(paymentId: 'XXXX', amount: '4XXX', date: 'XX/XX/XXXX'),
            const Spacer(),
            Column(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: Color(0xff3E69FE)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Details', style: TextStyle(color: Color(0xff3E69FE))),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: Color(0xff3E69FE)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Download Invoice', style: TextStyle(color: Color(0xff3E69FE))),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3E69FE),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Pay Bill', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;
  const _MetricCard({required this.title, required this.value, required this.subtitle, required this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor)),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String paymentId;
  final String amount;
  final String date;
  const _TransactionTile({required this.paymentId, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        title: Text('Payment ID: $paymentId', style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('Amount: $amount', style: const TextStyle(color: Colors.black54)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Paid on', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
