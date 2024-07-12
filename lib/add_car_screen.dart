import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _manufactureController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _platesController = TextEditingController();
  final TextEditingController _nextInsuranceDateController = TextEditingController();
  final TextEditingController _nextInspectionDateController = TextEditingController();
  final TextEditingController _nextTaxDateController = TextEditingController();
  final TextEditingController _nextRevisionDateController = TextEditingController();
  final TextEditingController _serviceHistoryController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _addCar() async {
    await FirebaseFirestore.instance.collection('cars').add({
      'manufacture': _manufactureController.text,
      'model': _modelController.text,
      'year': _yearController.text,
      'engine': _engineController.text,
      'transmission': _transmissionController.text,
      'plates': _platesController.text,
      'nextInsuranceDate': _nextInsuranceDateController.text,
      'nextInspectionDate': _nextInspectionDateController.text,
      'nextTaxDate': _nextTaxDateController.text,
      'nextRevisionDate': _nextRevisionDateController.text,
      'serviceHistory': _serviceHistoryController.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _manufactureController,
                decoration: InputDecoration(labelText: 'Manufacture'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the manufacture';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              TextFormField(
                controller: _engineController,
                decoration: InputDecoration(labelText: 'Engine'),
              ),
              TextFormField(
                controller: _transmissionController,
                decoration: InputDecoration(labelText: 'Transmission'),
              ),
              TextFormField(
                controller: _platesController,
                decoration: InputDecoration(labelText: 'Plates'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plates';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nextInsuranceDateController,
                decoration: InputDecoration(labelText: 'Next Insurance Date'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectDate(context, _nextInsuranceDateController);
                },
              ),
              TextFormField(
                controller: _nextInspectionDateController,
                decoration: InputDecoration(labelText: 'Next Inspection Date'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectDate(context, _nextInspectionDateController);
                },
              ),
              TextFormField(
                controller: _nextTaxDateController,
                decoration: InputDecoration(labelText: 'Next Tax Date'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectDate(context, _nextTaxDateController);
                },
              ),
              TextFormField(
                controller: _nextRevisionDateController,
                decoration: InputDecoration(labelText: 'Next Revision Date'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectDate(context, _nextRevisionDateController);
                },
              ),
              TextFormField(
                controller: _serviceHistoryController,
                decoration: InputDecoration(labelText: 'Service History'),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addCar();
                  }
                },
                child: Text('Add Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
