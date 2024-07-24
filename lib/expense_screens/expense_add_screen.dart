import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/models/expense_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:burt/services/expense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                              cost: int.parse(_details['cost']),
                              details: _details,
                            );
                            await ExpenseService().addExpense(expense);
                            Navigator.pop(context);
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
          onSaved: (value) => _details['taxBroker'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Tax Cost'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _details['cost'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Valid From'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _details['taxValidFrom'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Valid To'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _details['taxValidTo'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Notes'),
          maxLines: 3,
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
          onSaved: (value) => _details['serviceName'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Contact'),
          keyboardType: TextInputType.phone,
          onSaved: (value) => _details['serviceContact'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Cost'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _details['cost'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Details'),
          maxLines: 3,
          onSaved: (value) => _details['serviceDetails'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Warranty (months)'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _details['serviceWarranty'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Date'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _details['serviceDate'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Service Reminder'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _details['serviceReminder'] = value ?? '',
        ),
      ],
    );
  }

  Widget _buildOtherFields() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Name'),
          onSaved: (value) => _details['otherName'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Date'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _details['otherDate'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Reminder'),
          keyboardType: TextInputType.datetime,
          onSaved: (value) => _details['otherReminder'] = value ?? '',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Cost'),
          keyboardType: TextInputType.number,
          onSaved: (value) => _details['cost'] = value ?? '0',
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Other Details'),
          maxLines: 3,
          onSaved: (value) => _details['otherDetails'] = value ?? '',
        ),
      ],
    );
  }
}
