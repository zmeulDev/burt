import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddServiceRecordScreen extends StatelessWidget {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Service Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _serviceNameController, label: 'Service Name'),
            CustomTextField(controller: _dateController, label: 'Date of Service'),
            CustomTextField(controller: _serviceTypeController, label: 'Service Type'),
            CustomTextField(controller: _mileageController, label: 'Mileage'),
            CustomTextField(controller: _costController, label: 'Cost'),
            CustomTextField(controller: _notesController, label: 'Notes'),
            CustomButton(text: 'Save', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
