import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AddServiceRecordScreen extends StatefulWidget {
  @override
  _AddServiceRecordScreenState createState() => _AddServiceRecordScreenState();
}

class _AddServiceRecordScreenState extends State<AddServiceRecordScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCarId;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveServiceRecord() async {
    if (_selectedCarId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a car')));
      return;
    }

    await FirebaseFirestore.instance.collection('services').add({
      'carId': _selectedCarId,
      'serviceName': _serviceNameController.text,
      'date': _dateController.text,
      'serviceType': _serviceTypeController.text,
      'mileage': _mileageController.text,
      'cost': _costController.text,
      'notes': _notesController.text,
      'userId': FirebaseAuth.instance.currentUser?.uid,
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service record added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Service Record')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cars')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final cars = snapshot.data!.docs;
                return DropdownButtonFormField<String>(
                  value: _selectedCarId,
                  items: cars.map((doc) {
                    final car = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text('${car['model']} (${car['carPlate']})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCarId = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Car',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            CustomTextField(controller: _serviceNameController, label: 'Service Name'),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _dateController,
                  label: 'Date of Service',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            CustomTextField(controller: _serviceTypeController, label: 'Service Type'),
            CustomTextField(controller: _mileageController, label: 'Mileage'),
            CustomTextField(controller: _costController, label: 'Cost'),
            CustomTextField(controller: _notesController, label: 'Notes'),
            SizedBox(height: 24),
            CustomButton(text: 'Save', onPressed: _saveServiceRecord),
          ],
        ),
      ),
    );
  }
}
