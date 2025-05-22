import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;
  String? _error;
  double _totalRevenue = 0;
  int _satisfactionRate = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Not logged in';
          _loading = false;
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('bills')
          .where('patientId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      double total = 0;
      final transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        total += (data['amount'] ?? 0).toDouble();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      setState(() {
        _transactions = transactions;
        _totalRevenue = total;
        _satisfactionRate = 92; // This could be calculated from patient feedback
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load transactions: $e';
        _loading = false;
      });
    }
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    // Navigation logic
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/patient-home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/appointment-booking');
    } else if (index == 2) {
      // Billing (current)
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  void _showReceipt(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hospital Management System', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Receipt #: ${transaction['id']}'),
              const SizedBox(height: 4),
              Text('Date: ${(transaction['date'] as Timestamp).toDate().toString().substring(0, 10)}'),
              const SizedBox(height: 4),
              Text('Amount: \$${transaction['amount']}'),
              const SizedBox(height: 4),
              Text('Status: ${transaction['status']}'),
              const SizedBox(height: 4),
              Text('Type: ${transaction['type'] ?? 'General'}'),
              const SizedBox(height: 16),
              const Text('Thank you for your business!', style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _payBill(Map<String, dynamic> transaction) async {
    try {
      await FirebaseFirestore.instance.collection('bills').doc(transaction['id']).update({
        'status': 'Paid',
        'paidAt': DateTime.now(),
      });
      
      await _loadTransactions();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _MetricCard(
                            title: 'Total Revenue',
                            value: '\$${_totalRevenue.toStringAsFixed(2)}',
                            subtitle: '+5% from last month',
                            subtitleColor: Colors.green,
                          ),
                          const SizedBox(width: 12),
                          _MetricCard(
                            title: 'Patient Satisfaction',
                            value: '$_satisfactionRate%',
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
                      Expanded(
                        child: ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _transactions[index];
                            return _TransactionTile(
                              paymentId: transaction['id'],
                              amount: '\$${transaction['amount']}',
                              date: (transaction['date'] as Timestamp).toDate().toString().substring(0, 10),
                              status: transaction['status'],
                              onViewReceipt: () => _showReceipt(transaction),
                              onPay: transaction['status'] == 'Unpaid' ? () => _payBill(transaction) : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
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
  final String status;
  final VoidCallback onViewReceipt;
  final VoidCallback? onPay;

  const _TransactionTile({
    required this.paymentId,
    required this.amount,
    required this.date,
    required this.status,
    required this.onViewReceipt,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        title: Text('Payment ID: $paymentId', style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: $amount', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  status == 'Paid' ? Icons.check_circle : Icons.pending,
                  color: status == 'Paid' ? Colors.green : Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: status == 'Paid' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Paid on', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (onPay != null)
              TextButton(
                onPressed: onPay,
                child: const Text('Pay Now', style: TextStyle(color: Color(0xff3E69FE))),
              ),
          ],
        ),
        onTap: onViewReceipt,
      ),
    );
  }
}
