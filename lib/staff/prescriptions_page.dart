import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  String? _selectedPatientId;
  String? _selectedPatientName;
  List<Map<String, dynamic>> _patients = [];
  List<Map<String, dynamic>> _medicines = [];
  List<String> _selectedMedicines = [];
  final Map<String, TextEditingController> _dosageControllers = {};
  final TextEditingController _notesController = TextEditingController();
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPatientsAndMedicines();
  }

  Future<void> _fetchPatientsAndMedicines() async {
    setState(() { _loading = true; });
    try {
      // Fetch patients from Firestore (role == patient)
      final patientsSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();
      _patients = patientsSnap.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();

      // Fetch medicines from Realtime Database
      final dbRef = FirebaseDatabase.instance.reference();
      final medSnap = await dbRef.child('medicines').once();
      final medData = medSnap.snapshot.value as Map?;
      if (medData != null) {
        _medicines = medData.values.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      _error = 'Failed to load data: $e';
    }
    setState(() { _loading = false; });
  }

  void _toggleMedicine(String name) {
    setState(() {
      if (_selectedMedicines.contains(name)) {
        _selectedMedicines.remove(name);
      } else {
        _selectedMedicines.add(name);
        _dosageControllers[name] = TextEditingController();
      }
    });
  }

  Future<void> _submitPrescription() async {
    if (_selectedPatientId == null || _selectedMedicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a patient and at least one medicine.')),
      );
      return;
    }
    final staff = FirebaseAuth.instance.currentUser;
    final prescription = {
      'patientId': _selectedPatientId,
      'patientName': _selectedPatientName,
      'staffId': staff?.uid,
      'staffName': staff?.displayName ?? 'Unknown',
      'medicines': _selectedMedicines.map((name) => {
        'name': name,
        'dosage': _dosageControllers[name]?.text ?? '',
      }).toList(),
      'notes': _notesController.text,
      'date': DateTime.now(),
    };
    try {
      await FirebaseFirestore.instance.collection('prescriptions').add(prescription);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription saved!')),
      );
      setState(() {
        _selectedMedicines.clear();
        _dosageControllers.clear();
        _notesController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescribe Medicine'),
        backgroundColor: const Color(0xff3E69FE),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Patient:', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: _selectedPatientId,
                        hint: const Text('Choose patient'),
                        isExpanded: true,
                        items: _patients.map((p) => DropdownMenuItem<String>(
                          value: p['id'] as String,
                          child: Text(p['full-name'] ?? p['firstName'] ?? 'No Name'),
                        )).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedPatientId = val;
                            _selectedPatientName = _patients.firstWhere((p) => p['id'] == val)['full-name'] ?? 'No Name';
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Select Medicines:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ..._medicines.map((med) => CheckboxListTile(
                        value: _selectedMedicines.contains(med['name']),
                        title: Text(med['name'] ?? ''),
                        subtitle: Text(med['type'] ?? ''),
                        onChanged: (val) => _toggleMedicine(med['name']),
                      )),
                      ..._selectedMedicines.map((name) => Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 8),
                        child: TextField(
                          controller: _dosageControllers[name],
                          decoration: InputDecoration(
                            labelText: 'Dosage for $name',
                          ),
                        ),
                      )),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitPrescription,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3E69FE),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Save Prescription', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
    );
  }
} 