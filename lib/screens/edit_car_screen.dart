import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCarScreen extends StatefulWidget {
  final String carId;

  EditCarScreen({required this.carId});

  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _makerController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _engineSizeController;
  late TextEditingController _fuelTypeController;
  late TextEditingController _transmissionController;
  late TextEditingController _carPlateController;
  late TextEditingController _taxDueController;
  late TextEditingController _insuranceDueController;
  late TextEditingController _serviceDueController;
  late TextEditingController _inspectionDueController;

  @override
  void initState() {
    super.initState();
    _loadCarDetails();
  }

  Future<void> _loadCarDetails() async {
    DocumentSnapshot doc = await _firestore.collection('cars').doc(widget.carId).get();
    var carData = doc.data() as Map<String, dynamic>;

    setState(() {
      _makerController = TextEditingController(text: carData['maker']);
      _modelController = TextEditingController(text: carData['model']);
      _yearController = TextEditingController(text: carData['year']);
      _engineSizeController = TextEditingController(text: carData['engineSize']);
      _fuelTypeController = TextEditingController(text: carData['fuelType']);
      _transmissionController = TextEditingController(text: carData['transmission']);
      _carPlateController = TextEditingController(text: carData['carPlate']);
      _taxDueController = TextEditingController(text: carData['taxDue']);
      _insuranceDueController = TextEditingController(text: carData['insuranceDue']);
      _serviceDueController = TextEditingController(text: carData['serviceDue']);
      _inspectionDueController = TextEditingController(text: carData['inspectionDue']);
    });
  }

  Future<void> _updateCarDetails() async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('cars').doc(widget.carId).update({
        'maker': _makerController.text,
        'model': _modelController.text,
        'year': _yearController.text,
        'engineSize': _engineSizeController.text,
        'fuelType': _fuelTypeController.text,
        'transmission': _transmissionController.text,
        'carPlate': _carPlateController.text,
        'taxDue': _taxDueController.text,
        'insuranceDue': _insuranceDueController.text,
        'serviceDue': _serviceDueController.text,
        'inspectionDue': _inspectionDueController.text,
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car details updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Car Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Maker', _makerController),
              _buildTextField('Model', _modelController),
              _buildTextField('Year', _yearController),
              _buildTextField('Engine Size', _engineSizeController),
              _buildTextField('Fuel Type', _fuelTypeController),
              _buildTextField('Transmission', _transmissionController),
              _buildTextField('Car Plate', _carPlateController),
              _buildTextField('Next Tax Due', _taxDueController),
              _buildTextField('Next Insurance Due', _insuranceDueController),
              _buildTextField('Next Service Due', _serviceDueController),
              _buildTextField('Next Inspection Due', _inspectionDueController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCarDetails,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
