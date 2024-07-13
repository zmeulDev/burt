import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'styles.dart';

class ServiceForm extends StatefulWidget {
  final String carId;
  final DocumentSnapshot? service;

  const ServiceForm({Key? key, required this.carId, this.service}) : super(key: key);

  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceNameController;
  late TextEditingController _serviceDateController;
  late TextEditingController _costController;
  late TextEditingController _warrantyController;
  late TextEditingController _notesController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _serviceNameController = TextEditingController(text: widget.service?['serviceName']);
    _serviceDateController = TextEditingController(text: widget.service != null ? DateFormat('yyyy-MM-dd').format(widget.service!['serviceDate'].toDate()) : '');
    _costController = TextEditingController(text: widget.service?['cost']?.toString() ?? '');
    _warrantyController = TextEditingController(text: widget.service?['warranty']);
    _notesController = TextEditingController(text: widget.service?['notes']);
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceDateController.dispose();
    _costController.dispose();
    _warrantyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'serviceName': _serviceNameController.text,
        'serviceDate': Timestamp.fromDate(_selectedDate ?? DateTime.now()),
        'cost': double.tryParse(_costController.text) ?? 0.0,
        'warranty': _warrantyController.text,
        'notes': _notesController.text,
      };

      if (widget.service == null) {
        await FirebaseFirestore.instance.collection('cars').doc(widget.carId).collection('services').add(data);
      } else {
        await FirebaseFirestore.instance.collection('cars').doc(widget.carId).collection('services').doc(widget.service!.id).update(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _serviceDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serviceDateController,
                decoration: const InputDecoration(labelText: 'Service Date'),
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _warrantyController,
                decoration: const InputDecoration(labelText: 'Warranty'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveService,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
