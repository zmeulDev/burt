import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseEditScreen extends StatefulWidget {
  final String expenseId;

  ExpenseEditScreen({required this.expenseId});

  @override
  _ExpenseEditScreenState createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends State<ExpenseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Expense _expense;
  bool _loading = true;
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

  Future<void> _loadExpense() async {
    final expense = await ExpenseService().getExpenseById(widget.expenseId);
    final cars = await CarService().getCarsByUser(expense.userId).first;
    setState(() {
      _expense = expense;
      _cars = cars;
      _selectedCarId = expense.carId;
      _taxValidFromController.text = _expense.details['taxValidFrom'] ?? '';
      _taxValidToController.text = _expense.details['taxValidTo'] ?? '';
      _serviceDateController.text = _expense.details['serviceDate'] ?? '';
      _serviceReminderController.text =
          _expense.details['serviceReminder'] ?? '';
      _otherDateController.text = _expense.details['otherDate'] ?? '';
      _otherReminderController.text = _expense.details['otherReminder'] ?? '';
      _loading = false;
    });
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
        _expense.details[key] = DateFormat('yyyy-MM-dd').format(picked);
        controller.text = _expense.details[key];
      });
    }
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_selectedCarId == null || _expense.type.isEmpty) {
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
        _expense.carId = _selectedCarId!;
        ExpenseService().updateExpense(_expense).then((_) {
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
  void initState() {
    super.initState();
    _loadExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                            items:
                                _cars.map<DropdownMenuItem<String>>((Car car) {
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
                            value: _expense.type,
                            onChanged: (String? newValue) {
                              setState(() {
                                _expense.type = newValue!;
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
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: Text('Details'),
                      content: _expense.type == 'Tax'
                          ? _buildTaxFields()
                          : _expense.type == 'Service'
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
                              'Please review the details and press Finish to save the expense.'),
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
            ),
    );
  }

  Widget _buildTaxFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Tax Type'),
          value: _expense.details['taxType'],
          onChanged: (String? newValue) {
            setState(() {
              _expense.details['taxType'] = newValue!;
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
          initialValue: _expense.details['taxBroker'],
          onChanged: (value) => _expense.details['taxBroker'] = value,
        ),
        _buildTextField(
          label: 'Tax Cost',
          initialValue: _expense.details['cost']?.toString(),
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
          onChanged: (value) {
            setState(() {
              _expense.cost = int.tryParse(value) ?? 0;
              _expense.details['cost'] = value;
            });
          },
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
          initialValue: _expense.details['taxNotes'],
          maxLines: 3,
          onChanged: (value) => _expense.details['taxNotes'] = value,
        ),
      ],
    );
  }

  Widget _buildServiceFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: 'Service Type'),
          value: _expense.details['serviceType'],
          onChanged: (String? newValue) {
            setState(() {
              _expense.details['serviceType'] = newValue!;
            });
          },
          items: [
            'Maintenance',
            'Service',
            'Tire Rotation',
            'Manufacture Service',
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
          initialValue: _expense.details['serviceName'],
          onChanged: (value) => _expense.details['serviceName'] = value,
        ),
        _buildTextField(
          label: 'Service Contact',
          initialValue: _expense.details['serviceContact'],
          keyboardType: TextInputType.phone,
          onChanged: (value) => _expense.details['serviceContact'] = value,
        ),
        _buildTextField(
          label: 'Service Cost',
          initialValue: _expense.details['cost']?.toString(),
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
          onChanged: (value) {
            setState(() {
              _expense.cost = int.tryParse(value) ?? 0;
              _expense.details['cost'] = value;
            });
          },
        ),
        _buildTextField(
          label: 'Service Details',
          initialValue: _expense.details['serviceDetails'],
          maxLines: 3,
          onChanged: (value) => _expense.details['serviceDetails'] = value,
        ),
        _buildTextField(
          label: 'Service Warranty (months)',
          initialValue: _expense.details['serviceWarranty'],
          keyboardType: TextInputType.number,
          onChanged: (value) => _expense.details['serviceWarranty'] = value,
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
          initialValue: _expense.details['otherName'],
          onChanged: (value) => _expense.details['otherName'] = value,
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
          initialValue: _expense.details['cost']?.toString(),
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
          onChanged: (value) {
            setState(() {
              _expense.cost = int.tryParse(value) ?? 0;
              _expense.details['cost'] = value;
            });
          },
        ),
        _buildTextField(
          label: 'Other Details',
          initialValue: _expense.details['otherDetails'],
          maxLines: 3,
          onChanged: (value) => _expense.details['otherDetails'] = value,
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
        controller: controller,
      ),
    );
  }
}
