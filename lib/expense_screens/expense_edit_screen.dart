import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  Future<void> _loadExpense() async {
    final expense = await ExpenseService().getExpenseById(widget.expenseId);
    final cars = await CarService().getCarsByUser(expense.userId).first;
    setState(() {
      _expense = expense;
      _cars = cars;
      _selectedCarId = expense.carId;
      _loading = false;
    });
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
              if (_expense.type == 'Tax') _buildTaxFields(),
              if (_expense.type == 'Service') _buildServiceFields(),
              if (_expense.type == 'Other') _buildOtherFields(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _expense.carId = _selectedCarId!;
                    await ExpenseService().updateExpense(_expense);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
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
        TextFormField(
          initialValue: _expense.details['taxBroker'],
          decoration: InputDecoration(labelText: 'Tax Broker'),
          onSaved: (value) => _expense.details['taxBroker'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['cost'].toString(),
          decoration: InputDecoration(labelText: 'Tax Cost'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _expense.cost = int.parse(value ?? '0'),
        ),
        TextFormField(
          initialValue: _expense.details['taxValidFrom'],
          decoration: InputDecoration(labelText: 'Valid From'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _expense.details['taxValidFrom'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['taxValidTo'],
          decoration: InputDecoration(labelText: 'Valid To'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _expense.details['taxValidTo'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['taxNotes'],
          decoration: InputDecoration(labelText: 'Notes'),
          maxLines: 3,
          onSaved: (value) => _expense.details['taxNotes'] = value ?? '',
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
          items: ['Maintenance', 'Service', 'Tire Rotation', 'Manufacture Service', 'Crash', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextFormField(
          initialValue: _expense.details['serviceName'],
          decoration: InputDecoration(labelText: 'Service Name'),
          onSaved: (value) => _expense.details['serviceName'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['serviceContact'],
          decoration: InputDecoration(labelText: 'Service Contact'),
          keyboardType: TextInputType.phone,
          onSaved: (value) => _expense.details['serviceContact'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['cost'].toString(),
          decoration: InputDecoration(labelText: 'Service Cost'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _expense.cost = int.parse(value ?? '0'),
        ),
        TextFormField(
          initialValue: _expense.details['serviceDetails'],
          decoration: InputDecoration(labelText: 'Service Details'),
          maxLines: 3,
          onSaved: (value) => _expense.details['serviceDetails'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['serviceWarranty'],
          decoration: InputDecoration(labelText: 'Service Warranty (months)'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _expense.details['serviceWarranty'] = value ?? '0',
        ),
        TextFormField(
          initialValue: _expense.details['serviceDate'],
          decoration: InputDecoration(labelText: 'Service Date'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _expense.details['serviceDate'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['serviceReminder'],
          decoration: InputDecoration(labelText: 'Service Reminder'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _expense.details['serviceReminder'] = value ?? '',
        ),
      ],
    );
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        TextFormField(
          initialValue: _expense.details['otherName'],
          decoration: InputDecoration(labelText: 'Other Name'),
          onSaved: (value) => _expense.details['otherName'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['otherDate'],
          decoration: InputDecoration(labelText: 'Other Date'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _expense.details['otherDate'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['otherReminder'],
          decoration: InputDecoration(labelText: 'Other Reminder'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _expense.details['otherReminder'] = value ?? '',
        ),
        TextFormField(
          initialValue: _expense.details['cost'].toString(),
          decoration: InputDecoration(labelText: 'Other Cost'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _expense.cost = int.parse(value ?? '0'),
        ),
        TextFormField(
          initialValue: _expense.details['otherDetails'],
          decoration: InputDecoration(labelText: 'Other Details'),
          maxLines: 3,
          onSaved: (value) => _expense.details['otherDetails'] = value ?? '',
        ),
      ],
    );
  }
}

