import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddEditServiceScreen extends StatefulWidget {
  final String carId;
  final String? serviceId;

  AddEditServiceScreen({required this.carId, this.serviceId});

  @override
  _AddEditServiceScreenState createState() => _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends State<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _serviceNameController;
  late TextEditingController _costController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _serviceNameController = TextEditingController();
    _costController = TextEditingController();
    _noteController = TextEditingController();
    if (widget.serviceId != null) {
      _loadServiceData();
    }
  }

  void _loadServiceData() async {
    DocumentSnapshot service = await FirebaseFirestore.instance.collection('services').doc(widget.serviceId).get();
    Map<String, dynamic> data = service.data() as Map<String, dynamic>;
    _dateController.text = data['date'];
    _serviceNameController.text = data['serviceName'];
    _costController.text = data['cost'].toString();
    _noteController.text = data['note'];
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> serviceData = {
        'carId': widget.carId,
        'serviceName': _serviceNameController.text,
        'date': _dateController.text,
        'cost': double.parse(_costController.text),
        'note': _noteController.text,
      };
      if (widget.serviceId == null) {
        await FirebaseFirestore.instance.collection('services').add(serviceData);
      } else {
        await FirebaseFirestore.instance.collection('services').doc(widget.serviceId).update(serviceData);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceId == null ? 'Add Service' : 'Edit Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(labelText: 'Service Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context);
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Note'),
                maxLines: 3,
              ),
              ElevatedButton(
                onPressed: _saveService,
                child: Text('Save Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
