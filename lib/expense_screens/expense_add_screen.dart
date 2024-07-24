import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';



class ExpenseAddScreen extends StatefulWidget {
  @override
  _ExpenseAddScreenState createState() => _ExpenseAddScreenState();
}

class _ExpenseAddScreenState extends State<ExpenseAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Tax';
  Map<String, dynamic> _details = {};
  late String _userId;
  late List<Car> _cars;
  String? _selectedCarId;

  // Controllers to preserve input data
  final _taxValidFromController = TextEditingController();
  final _taxValidToController = TextEditingController();
  final _serviceDateController = TextEditingController();
  final _serviceReminderController = TextEditingController();
  final _otherDateController = TextEditingController();
  final _otherReminderController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _taxValidFromController.dispose();
    _taxValidToController.dispose();
    _serviceDateController.dispose();
    _serviceReminderController.dispose();
    _otherDateController.dispose();
    _otherReminderController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, String key) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _details[key] = DateFormat('yyyy-MM-dd').format(picked);
        controller.text = _details[key];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final carService = Provider.of<CarService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: StreamBuilder<User?>(
        stream: authService.user,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(child: Text('No user logged in'));
          }

          _userId = userSnapshot.data!.uid;

          return StreamBuilder<List<Car>>(
            stream: carService.getCarsByUser(_userId),
            builder: (context, carSnapshot) {
              if (carSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!carSnapshot.hasData || carSnapshot.data!.isEmpty) {
                return Center(child: Text('No cars available'));
              }

              _cars = carSnapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Car'),
                        value: _selectedCarId,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCarId = newValue;
                          });
                        },
                        items: _cars.map<DropdownMenuItem<String>>((Car car) {
                          return DropdownMenuItem<String>(
                            value: car.id,
                            child: Text(car.carPlate),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Please select a car' : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Type'),
                        value: _selectedType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedType = newValue!;
                          });
                        },
                        items: ['Tax', 'Service', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (_selectedType == 'Tax') _buildTaxFields(),
                      if (_selectedType == 'Service') _buildServiceFields(),
                      if (_selectedType == 'Other') _buildOtherFields(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final expense = Expense(
                              id: '',
                              userId: _userId,
                              carId: _selectedCarId!,
                              type: _selectedType,
                              date: DateTime.now(),
                              cost: int.parse(_details['cost'] ?? '0'),
                              details: _details,
                            );
                            await ExpenseService().addExpense(expense);
                            Navigator.pop(context); // Navigate back to ExpensesViewScreen
                          }
                        },
                        child: Text('Add Expense'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTaxFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Tax Type'),
          value: _details['taxType'],
          onChanged: (String? newValue) {
            setState(() {
              _details['taxType'] = newValue!;
            });
          },
          items: ['Insurance', 'Vignette', 'Government', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Tax Broker'),
          initialValue: _details['taxBroker'],
          onChanged: (value) => _details['taxBroker'] = value,
          onSaved: (value) => _details['taxBroker'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Tax Cost'),
          initialValue: _details['cost'],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a cost';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          onChanged: (value) => _details['cost'] = value,
          onSaved: (value) => _details['cost'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Valid From'),
          readOnly: true,
          onTap: () => _selectDate(context, _taxValidFromController, 'taxValidFrom'),
          controller: _taxValidFromController..text = _details['taxValidFrom'] ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Valid To'),
          readOnly: true,
          onTap: () => _selectDate(context, _taxValidToController, 'taxValidTo'),
          controller: _taxValidToController..text = _details['taxValidTo'] ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Notes'),
          initialValue: _details['taxNotes'],
          maxLines: 3,
          onChanged: (value) => _details['taxNotes'] = value,
          onSaved: (value) => _details['taxNotes'] = value ?? '',
        ),
      ],
    );
  }

  Widget _buildServiceFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Service Type'),
          value: _details['serviceType'],
          onChanged: (String? newValue) {
            setState(() {
              _details['serviceType'] = newValue!;
            });
          },
          items: ['Maintenance', 'Service', 'Tire Rotation', 'Manufacture Service', 'Crash', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Name'),
          initialValue: _details['serviceName'],
          onChanged: (value) => _details['serviceName'] = value,
          onSaved: (value) => _details['serviceName'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Contact'),
          initialValue: _details['serviceContact'],
          keyboardType: TextInputType.phone,
          onChanged: (value) => _details['serviceContact'] = value,
          onSaved: (value) => _details['serviceContact'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Cost'),
          initialValue: _details['cost'],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a cost';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          onChanged: (value) => _details['cost'] = value,
          onSaved: (value) => _details['cost'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Details'),
          initialValue: _details['serviceDetails'],
          maxLines: 3,
          onChanged: (value) => _details['serviceDetails'] = value,
          onSaved: (value) => _details['serviceDetails'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Warranty (months)'),
          initialValue: _details['serviceWarranty'],
          keyboardType: TextInputType.number,
          onChanged: (value) => _details['serviceWarranty'] = value,
          onSaved: (value) => _details['serviceWarranty'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Date'),
          readOnly: true,
          onTap: () => _selectDate(context, _serviceDateController, 'serviceDate'),
          controller: _serviceDateController..text = _details['serviceDate'] ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Reminder'),
          readOnly: true,
          onTap: () => _selectDate(context, _serviceReminderController, 'serviceReminder'),
          controller: _serviceReminderController..text = _details['serviceReminder'] ?? '',
        ),
      ],
    );
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Name'),
          initialValue: _details['otherName'],
          onChanged: (value) => _details['otherName'] = value,
          onSaved: (value) => _details['otherName'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Date'),
          readOnly: true,
          onTap: () => _selectDate(context, _otherDateController, 'otherDate'),
          controller: _otherDateController..text = _details['otherDate'] ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Reminder'),
          readOnly: true,
          onTap: () => _selectDate(context, _otherReminderController, 'otherReminder'),
          controller: _otherReminderController..text = _details['otherReminder'] ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Cost'),
          initialValue: _details['cost'],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a cost';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          onChanged: (value) => _details['cost'] = value,
          onSaved: (value) => _details['cost'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Details'),
          initialValue: _details['otherDetails'],
          maxLines: 3,
          onChanged: (value) => _details['otherDetails'] = value,
          onSaved: (value) => _details['otherDetails'] = value ?? '',
        ),
      ],
    );
  }
}






