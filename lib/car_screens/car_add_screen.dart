import 'package:burt/auth_service.dart';
import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarAddScreen extends StatefulWidget {
  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends State<CarAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _car = Car(
    id: '',
    maker: '',
    model: '',
    year: 0,
    carPlate: '',
    vinNumber: '',
    engineSize: 0,
    enginePower: 0,
    color: '',
    fuelType: 'Petrol',
    transmission: 'Manual',
    tireSize: '',
    wiperSize: '',
    lightsType: '',
    status: true,
  );

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car'),
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

          final userId = userSnapshot.data!.uid;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Maker'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) => _car.maker = value!.isNotEmpty ? value : 'N/A',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Model *'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) => _car.model = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the model';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _car.year = int.tryParse(value!) ?? 0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Car Plate *'),
                    textCapitalization: TextCapitalization.characters,
                    onSaved: (value) => _car.carPlate = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the car plate';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'VIN Number'),
                    textCapitalization: TextCapitalization.characters,
                    onSaved: (value) => _car.vinNumber = value!.isNotEmpty ? value : 'N/A',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Engine Size'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _car.engineSize = int.tryParse(value!) ?? 0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Engine Power'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _car.enginePower = int.tryParse(value!) ?? 0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Color'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) => _car.color = value!.isNotEmpty ? value : 'N/A',
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Fuel Type'),
                    value: _car.fuelType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _car.fuelType = newValue!;
                      });
                    },
                    items: ['Petrol', 'Diesel', 'Hybrid', 'Electric', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Transmission'),
                    value: _car.transmission,
                    onChanged: (String? newValue) {
                      setState(() {
                        _car.transmission = newValue!;
                      });
                    },
                    items: ['Manual', 'Automatic', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Tire Size'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) => _car.tireSize = value!.isNotEmpty ? value : 'N/A',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Wiper Size'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) => _car.wiperSize = value!.isNotEmpty ? value : 'N/A',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Lights Type'),
                    textCapitalization: TextCapitalization.words,
                    onSaved: (value) => _car.lightsType = value!.isNotEmpty ? value : 'N/A',
                  ),
                  SwitchListTile(
                    title: Text('Status'),
                    value: _car.status,
                    onChanged: (bool value) {
                      setState(() {
                        _car.status = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await CarService().addCar(_car, userId);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add Car'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
