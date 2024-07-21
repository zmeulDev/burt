import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';

class EditCarScreen extends StatefulWidget {
  final String carId;

  EditCarScreen({required this.carId});

  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  final TextEditingController _makerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _engineSizeController = TextEditingController();
  final TextEditingController _carPlateController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _tireSizeController = TextEditingController();
  final TextEditingController _wiperSizeController = TextEditingController();
  final TextEditingController _taxDueController = TextEditingController();
  final TextEditingController _insuranceDueController = TextEditingController();
  final TextEditingController _serviceDueController = TextEditingController();
  final TextEditingController _inspectionDueController = TextEditingController();
  final TextEditingController _boughtDateController = TextEditingController();

  String _fuelType = 'Petrol';
  String _transmission = 'Manual';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCarDetails();
  }

  Future<void> _loadCarDetails() async {
    DocumentSnapshot doc = await _firestore.collection('cars').doc(widget.carId).get();
    var carData = doc.data() as Map<String, dynamic>;

    setState(() {
      _makerController.text = carData['maker'] ?? '';
      _modelController.text = carData['model'] ?? '';
      _yearController.text = carData['year'] ?? '';
      _engineSizeController.text = carData['engineSize'] ?? '';
      _carPlateController.text = carData['carPlate'] ?? '';
      _vinController.text = carData['vin'] ?? '';
      _tireSizeController.text = carData['tireSize'] ?? '';
      _wiperSizeController.text = carData['wiperSize'] ?? '';
      _taxDueController.text = carData['taxDue'] ?? '';
      _insuranceDueController.text = carData['insuranceDue'] ?? '';
      _serviceDueController.text = carData['serviceDue'] ?? '';
      _inspectionDueController.text = carData['inspectionDue'] ?? '';
      _boughtDateController.text = carData['boughtDate'] ?? '';
      _fuelType = carData['fuelType'] ?? 'Petrol';
      _transmission = carData['transmission'] ?? 'Manual';
    });
  }

  Future<void> _updateCar(BuildContext context) async {
    if (_modelController.text.isEmpty || _yearController.text.isEmpty || _carPlateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Model, Year, and Car Plate are mandatory')));
      return;
    }

    await _firestore.collection('cars').doc(widget.carId).update({
      'maker': _makerController.text,
      'model': _modelController.text,
      'year': _yearController.text,
      'engineSize': _engineSizeController.text,
      'fuelType': _fuelType,
      'transmission': _transmission,
      'carPlate': _carPlateController.text,
      'vin': _vinController.text,
      'tireSize': _tireSizeController.text,
      'wiperSize': _wiperSizeController.text,
      'taxDue': _taxDueController.text,
      'insuranceDue': _insuranceDueController.text,
      'serviceDue': _serviceDueController.text,
      'inspectionDue': _inspectionDueController.text,
      'boughtDate': _boughtDateController.text,
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car details updated successfully')));
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Car Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Car Information', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            CustomTextField(
              controller: _makerController,
              label: 'Maker',
              prefixIcon: Icon(LineIcons.car),
            ),
            CustomTextField(
              controller: _modelController,
              label: 'Model *',
              prefixIcon: Icon(LineIcons.carSide),
            ),
            CustomTextField(
              controller: _yearController,
              label: 'Year *',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(LineIcons.calendarAlt),
            ),
            CustomTextField(
              controller: _engineSizeController,
              label: 'Engine Size',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(LineIcons.cogs),
            ),
            CustomTextField(
              controller: _vinController,
              label: 'VIN',
              prefixIcon: Icon(LineIcons.barcode),
            ),
            CustomTextField(
              controller: _tireSizeController,
              label: 'Tire Size',
              prefixIcon: Icon(LineIcons.circle),
            ),
            CustomTextField(
              controller: _wiperSizeController,
              label: 'Wiper Size',
              prefixIcon: Icon(LineIcons.wind),
            ),
            SizedBox(height: 16),
            CustomDropdown(
              value: _fuelType,
              items: ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Other'],
              onChanged: (newValue) {
                setState(() {
                  _fuelType = newValue!;
                });
              },
              label: 'Select Fuel Type',
            ),
            SizedBox(height: 16),
            CustomDropdown(
              value: _transmission,
              items: ['Manual', 'Automatic', 'Other'],
              onChanged: (newValue) {
                setState(() {
                  _transmission = newValue!;
                });
              },
              label: 'Select Transmission',
            ),
            CustomTextField(
              controller: _carPlateController,
              label: 'Car Plate *',
              prefixIcon: Icon(LineIcons.creditCard),
            ),
            SizedBox(height: 16),
            Text('Due Dates', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, _taxDueController),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _taxDueController,
                  label: 'Next Tax Due',
                  prefixIcon: Icon(LineIcons.calendarCheck),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _insuranceDueController),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _insuranceDueController,
                  label: 'Next Insurance Due',
                  prefixIcon: Icon(LineIcons.calendarCheck),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _serviceDueController),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _serviceDueController,
                  label: 'Next Service Due',
                  prefixIcon: Icon(LineIcons.calendarCheck),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _inspectionDueController),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _inspectionDueController,
                  label: 'Next Inspection Due',
                  prefixIcon: Icon(LineIcons.calendarCheck),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context, _boughtDateController),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _boughtDateController,
                  label: 'Bought Date',
                  prefixIcon: Icon(LineIcons.calendarCheck),
                ),
              ),
            ),
            SizedBox(height: 16),
            CustomButton(text: 'Save', onPressed: () => _updateCar(context)),
          ],
        ),
      ),
    );
  }
}
