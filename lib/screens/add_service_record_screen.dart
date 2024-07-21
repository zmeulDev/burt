import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Service Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            CustomButton(text: 'Save', onPressed: () {
              // Save functionality here
            }),
          ],
        ),
      ),
    );
  }
}
