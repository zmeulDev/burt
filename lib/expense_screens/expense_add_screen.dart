import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  int _currentStep = 0;

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

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, String key) async {
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

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_selectedCarId == null || _selectedType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a car and type')),
        );
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
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
        ExpenseService().addExpense(expense).then((_) {
          Navigator.pop(context);
        });
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.pop(context);
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
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepContinue: _onStepContinue,
                    onStepCancel: _onStepCancel,
                    controlsBuilder:
                        (BuildContext context, ControlsDetails controls) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (_currentStep != 0)
                            ElevatedButton(
                              onPressed: controls.onStepCancel,
                              child: Text('Back'),
                            ),
                          ElevatedButton(
                            onPressed: controls.onStepContinue,
                            child:
                                Text(_currentStep == 2 ? 'Finish' : 'Continue'),
                          ),
                        ],
                      );
                    },
                    steps: [
                      Step(
                        title: Text('Car and Type'),
                        content: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Car'),
                              value: _selectedCarId,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCarId = newValue;
                                });
                              },
                              items: _cars
                                  .map<DropdownMenuItem<String>>((Car car) {
                                return DropdownMenuItem<String>(
                                  value: car.id,
                                  child: Text(car.carPlate),
                                );
                              }).toList(),
                              validator: (value) =>
                                  value == null ? 'Please select a car' : null,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Type'),
                              value: _selectedType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedType = newValue!;
                                });
                              },
                              items: [
                                'Tax',
                                'Service',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              validator: (value) =>
                                  value == null ? 'Please select a type' : null,
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Text('Details'),
                        content: _selectedType == 'Tax'
                            ? _buildTaxFields()
                            : _selectedType == 'Service'
                                ? _buildServiceFields()
                                : _buildOtherFields(),
                        isActive: _currentStep >= 1,
                        state: _currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: Text('Confirm'),
                        content: Column(
                          children: [
                            Text(
                                'Please review the details and press Finish to add the expense.'),
                          ],
                        ),
                        isActive: _currentStep >= 2,
                        state: _currentStep >= 2
                            ? StepState.complete
                            : StepState.disabled,
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
        _buildTextField(
          label: 'Tax Broker',
          initialValue: _details['taxBroker'],
          onChanged: (value) => _details['taxBroker'] = value,
        ),
        _buildTextField(
          label: 'Tax Cost',
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
        ),
        _buildDateField(
          label: 'Valid From',
          controller: _taxValidFromController,
          dateKey: 'taxValidFrom',
        ),
        _buildDateField(
          label: 'Valid To',
          controller: _taxValidToController,
          dateKey: 'taxValidTo',
        ),
        _buildTextField(
          label: 'Notes',
          initialValue: _details['taxNotes'],
          maxLines: 3,
          onChanged: (value) => _details['taxNotes'] = value,
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
          items: [
            'Maintenance',
            'Inspection',
            'Service',
            'Tire Rotation',
            'Crash',
            'Other'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        _buildTextField(
          label: 'Service Name',
          initialValue: _details['serviceName'],
          onChanged: (value) => _details['serviceName'] = value,
        ),
        _buildTextField(
          label: 'Service Contact',
          initialValue: _details['serviceContact'],
          keyboardType: TextInputType.phone,
          onChanged: (value) => _details['serviceContact'] = value,
        ),
        _buildTextField(
          label: 'Service Cost',
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
        ),
        _buildTextField(
          label: 'Service Details',
          initialValue: _details['serviceDetails'],
          maxLines: 3,
          onChanged: (value) => _details['serviceDetails'] = value,
        ),
        _buildTextField(
          label: 'Service Warranty (months)',
          initialValue: _details['serviceWarranty'],
          keyboardType: TextInputType.number,
          onChanged: (value) => _details['serviceWarranty'] = value,
        ),
        _buildDateField(
          label: 'Service Date',
          controller: _serviceDateController,
          dateKey: 'serviceDate',
        ),
        _buildDateField(
          label: 'Service Reminder',
          controller: _serviceReminderController,
          dateKey: 'serviceReminder',
        ),
      ],
    );
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        _buildTextField(
          label: 'Other Name',
          initialValue: _details['otherName'],
          onChanged: (value) => _details['otherName'] = value,
        ),
        _buildDateField(
          label: 'Other Date',
          controller: _otherDateController,
          dateKey: 'otherDate',
        ),
        _buildDateField(
          label: 'Other Reminder',
          controller: _otherReminderController,
          dateKey: 'otherReminder',
        ),
        _buildTextField(
          label: 'Other Cost',
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
        ),
        _buildTextField(
          label: 'Other Details',
          initialValue: _details['otherDetails'],
          maxLines: 3,
          onChanged: (value) => _details['otherDetails'] = value,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required String dateKey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        readOnly: true,
        onTap: () => _selectDate(context, controller, dateKey),
        controller: controller..text = _details[dateKey] ?? '',
      ),
    );
  }
}
