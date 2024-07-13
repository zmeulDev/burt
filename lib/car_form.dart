import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styles.dart';

class CarForm extends StatefulWidget {
  final DocumentSnapshot? car;

  const CarForm({Key? key, this.car}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _manufactureController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _transmissionController;
  late TextEditingController _engineCapacityController;
  late TextEditingController _fuelTypeController;
  late TextEditingController _carPlatesController;
  late TextEditingController _notesController;
  late TextEditingController _inspectionDateController;
  late TextEditingController _revisionDateController;
  late TextEditingController _insuranceDateController;
  late TextEditingController _taxDateController;

  @override
  void initState() {
    super.initState();
    _manufactureController = TextEditingController(text: widget.car?['manufacture']);
    _modelController = TextEditingController(text: widget.car?['model']);
    _yearController = TextEditingController(text: widget.car?['year']?.toString());
    _transmissionController = TextEditingController(text: widget.car?['transmission']);
    _engineCapacityController = TextEditingController(text: widget.car?['engineCapacity']?.toString());
    _fuelTypeController = TextEditingController(text: widget.car?['fuelType']);
    _carPlatesController = TextEditingController(text: widget.car?['carPlates']);
    _notesController = TextEditingController(text: widget.car?['notes']);
    _inspectionDateController = TextEditingController(text: widget.car?['inspectionDate']);
    _revisionDateController = TextEditingController(text: widget.car?['revisionDate']);
    _insuranceDateController = TextEditingController(text: widget.car?['insuranceDate']);
    _taxDateController = TextEditingController(text: widget.car?['taxDate']);
  }

  @override
  void dispose() {
    _manufactureController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _transmissionController.dispose();
    _engineCapacityController.dispose();
    _fuelTypeController.dispose();
    _carPlatesController.dispose();
    _notesController.dispose();
    _inspectionDateController.dispose();
    _revisionDateController.dispose();
    _insuranceDateController.dispose();
    _taxDateController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'manufacture': _manufactureController.text,
        'model': _modelController.text,
        'year': int.tryParse(_yearController.text) ?? 0,
        'transmission': _transmissionController.text,
        'engineCapacity': double.tryParse(_engineCapacityController.text) ?? 0.0,
        'fuelType': _fuelTypeController.text,
        'carPlates': _carPlatesController.text,
        'notes': _notesController.text,
        'inspectionDate': _inspectionDateController.text,
        'revisionDate': _revisionDateController.text,
        'insuranceDate': _insuranceDateController.text,
        'taxDate': _taxDateController.text,
      };

      if (widget.car == null) {
        await FirebaseFirestore.instance.collection('cars').add(data);
      } else {
        await FirebaseFirestore.instance.collection('cars').doc(widget.car!.id).update(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _manufactureController,
                decoration: const InputDecoration(labelText: 'Manufacture'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the manufacture';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _transmissionController,
                decoration: const InputDecoration(labelText: 'Transmission'),
              ),
              TextFormField(
                controller: _engineCapacityController,
                decoration: const InputDecoration(labelText: 'Engine Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _fuelTypeController,
                decoration: const InputDecoration(labelText: 'Fuel Type'),
              ),
              TextFormField(
                controller: _carPlatesController,
                decoration: const InputDecoration(labelText: 'Car Plates'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car plates';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 4,
              ),
              TextFormField(
                controller: _inspectionDateController,
                decoration: const InputDecoration(labelText: 'Inspection Date'),
              ),
              TextFormField(
                controller: _revisionDateController,
                decoration: const InputDecoration(labelText: 'Revision Date'),
              ),
              TextFormField(
                controller: _insuranceDateController,
                decoration: const InputDecoration(labelText: 'Insurance Date'),
              ),
              TextFormField(
                controller: _taxDateController,
                decoration: const InputDecoration(labelText: 'Tax Date'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCar,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
