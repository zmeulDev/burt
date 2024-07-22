import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class EditServiceRecordScreen extends StatefulWidget {
  final String serviceId;

  EditServiceRecordScreen({required this.serviceId});

  @override
  _EditServiceRecordScreenState createState() => _EditServiceRecordScreenState();
}

class _EditServiceRecordScreenState extends State<EditServiceRecordScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCarId;

  @override
  void initState() {
    super.initState();
    _loadServiceRecord();
  }

  Future<void> _loadServiceRecord() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('services').doc(widget.serviceId).get();
    var serviceData = doc.data() as Map<String, dynamic>;

    setState(() {
      _serviceNameController.text = serviceData['serviceName'] ?? '';
      _dateController.text = serviceData['date'] ?? '';
      _serviceTypeController.text = serviceData['serviceType'] ?? '';
      _mileageController.text = serviceData['mileage'] ?? '';
      _costController.text = serviceData['cost'] ?? '';
      _notesController.text = serviceData['notes'] ?? '';
      _selectedCarId = serviceData['carId'];
    });
  }

  Future<void> _updateService(BuildContext context) async {
    if (_serviceNameController.text.isEmpty || _dateController.text.isEmpty || _selectedCarId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service Name, Date, and Car are mandatory')));
      return;
    }

    await FirebaseFirestore.instance.collection('services').doc(widget.serviceId).update({
      'serviceName': _serviceNameController.text,
      'date': _dateController.text,
      'serviceType': _serviceTypeController.text,
      'mileage': _mileageController.text,
      'cost': _costController.text,
      'notes': _notesController.text,
      'carId': _selectedCarId,
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service record updated successfully')));
  }

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
      appBar: AppBar(title: Text('Edit Service Record')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            CustomTextField(controller: _mileageController, label: 'Mileage', keyboardType: TextInputType.number),
            CustomTextField(controller: _costController, label: 'Cost', keyboardType: TextInputType.number),
            CustomTextField(controller: _notesController, label: 'Notes'),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('cars').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final cars = snapshot.data!.docs.map((doc) {
                  return DropdownMenuItem<String>(
                    value: doc.id,
                    child: Text(doc['model']),
                  );
                }).toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCarId,
                    items: cars,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCarId = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Select car",
                      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    isExpanded: true,
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            CustomButton(text: 'Save', onPressed: () => _updateService(context)),
          ],
        ),
      ),
    );
  }
}
