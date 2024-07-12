import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCarScreen extends StatefulWidget {
  final String carId;

  EditCarScreen({required this.carId});

  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _manufactureController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _engineController;
  late TextEditingController _transmissionController;
  late TextEditingController _platesController;
  late TextEditingController _nextInsuranceDateController;
  late TextEditingController _nextInspectionDateController;
  late TextEditingController _nextTaxDateController;
  late TextEditingController _nextRevisionDateController;

  @override
  void initState() {
    super.initState();
    _manufactureController = TextEditingController();
    _modelController = TextEditingController();
    _yearController = TextEditingController();
    _engineController = TextEditingController();
    _transmissionController = TextEditingController();
    _platesController = TextEditingController();
    _nextInsuranceDateController = TextEditingController();
    _nextInspectionDateController = TextEditingController();
    _nextTaxDateController = TextEditingController();
    _nextRevisionDateController = TextEditingController();
    _loadCarData();
  }

  void _loadCarData() async {
    DocumentSnapshot car = await FirebaseFirestore.instance.collection('cars').doc(widget.carId).get();
    var data = car.data() as Map<String, dynamic>;
    _manufactureController.text = data['manufacture'];
    _modelController.text = data['model'];
    _yearController.text = data['year'].toString();
    _engineController.text = data['engine'];
    _transmissionController.text = data['transmission'];
    _platesController.text = data['plates'];
    _nextInsuranceDateController.text = data['nextInsuranceDate'];
    _nextInspectionDateController.text = data['nextInspectionDate'];
    _nextTaxDateController.text = data['nextTaxDate'];
    _nextRevisionDateController.text = data['nextRevisionDate'];
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> carData = {
        'manufacture': _manufactureController.text,
        'model': _modelController.text,
        'year': int.parse(_yearController.text),
        'engine': _engineController.text,
        'transmission': _transmissionController.text,
        'plates': _platesController.text,
        'nextInsuranceDate': _nextInsuranceDateController.text,
        'nextInspectionDate': _nextInspectionDateController.text,
        'nextTaxDate': _nextTaxDateController.text,
        'nextRevisionDate': _nextRevisionDateController.text,
      };
      await FirebaseFirestore.instance.collection('cars').doc(widget.carId).update(carData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _engineController,
                decoration: InputDecoration(labelText: 'Engine'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the engine';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _transmissionController,
                decoration: InputDecoration(labelText: 'Transmission'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the transmission';
                  }
                  return null;
                },
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
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context, _nextInsuranceDateController);
                },
              ),
              TextFormField(
                controller: _nextInspectionDateController,
                decoration: InputDecoration(labelText: 'Next Inspection Date'),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context, _nextInspectionDateController);
                },
              ),
              TextFormField(
                controller: _nextTaxDateController,
                decoration: InputDecoration(labelText: 'Next Tax Date'),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context, _nextTaxDateController);
                },
              ),
              TextFormField(
                controller: _nextRevisionDateController,
                decoration: InputDecoration(labelText: 'Next Revision Date'),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context, _nextRevisionDateController);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCar,
                child: Text('Save Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
