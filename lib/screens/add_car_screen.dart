import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_animated_icons/flutter_animated_icons.dart';
import 'cars_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _makerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _engineSizeController = TextEditingController();
  final TextEditingController _carPlateController = TextEditingController();
  final TextEditingController _taxDueController = TextEditingController();
  final TextEditingController _insuranceDueController = TextEditingController();
  final TextEditingController _serviceDueController = TextEditingController();
  final TextEditingController _inspectionDueController = TextEditingController();
  String _fuelType = 'Petrol';
  String _transmission = 'Manual';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _addCar(BuildContext context) async {
    if (_modelController.text.isEmpty || _yearController.text.isEmpty || _carPlateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Model, Year, and Car Plate are mandatory')));
      return;
    }

    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('cars').add({
        'maker': _makerController.text,
        'model': _modelController.text,
        'year': _yearController.text,
        'engineSize': _engineSizeController.text,
        'fuelType': _fuelType,
        'transmission': _transmission,
        'carPlate': _carPlateController.text,
        'taxDue': _taxDueController.text,
        'insuranceDue': _insuranceDueController.text,
        'serviceDue': _serviceDueController.text,
        'inspectionDue': _inspectionDueController.text,
        'userId': user.uid,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CarsScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car added successfully')));
    }
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
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Car')),
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
              prefixIcon: Icon(LineIcons.calendarAlt),
            ),
            CustomTextField(
              controller: _engineSizeController,
              label: 'Engine Size',
              prefixIcon: Icon(LineIcons.cogs),
            ),
            SizedBox(height: 16),
            Text('Fuel Type', style: Theme.of(context).textTheme.titleLarge),
            DropdownButtonFormField<String>(
              value: _fuelType,
              items: <String>['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _fuelType = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Fuel Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            SizedBox(height: 16),
            Text('Transmission', style: Theme.of(context).textTheme.titleLarge),
            DropdownButtonFormField<String>(
              value: _transmission,
              items: <String>['Manual', 'Automatic', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _transmission = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Transmission',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _carPlateController,
              label: 'Car Plate *',
              prefixIcon: Icon(LineIcons.addressCard),
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
            SizedBox(height: 16),
            AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _animationController,
              size: 50,
            ),
            CustomButton(text: 'Save', onPressed: () => _addCar(context)),
          ],
        ),
      ),
    );
  }
}
