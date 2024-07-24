import 'package:burt/models/car_model.dart';
import 'package:burt/services/car_service.dart';
import 'package:flutter/material.dart';

class CarEditScreen extends StatefulWidget {
  final String carId;

  CarEditScreen({required this.carId});

  @override
  _CarEditScreenState createState() => _CarEditScreenState();
}

class _CarEditScreenState extends State<CarEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Car _car;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCar();
  }

  Future<void> _loadCar() async {
    _car = (await CarService().getCarById(widget.carId))!;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Car'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _car.maker,
                decoration: InputDecoration(labelText: 'Maker'),
                textCapitalization: TextCapitalization.words,
                onSaved: (value) => _car.maker = value!.isNotEmpty ? value : 'N/A',
              ),
              TextFormField(
                initialValue: _car.model,
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
                initialValue: _car.year.toString(),
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _car.year = int.tryParse(value!) ?? 0,
              ),
              TextFormField(
                initialValue: _car.carPlate,
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
                initialValue: _car.vinNumber,
                decoration: InputDecoration(labelText: 'VIN Number'),
                textCapitalization: TextCapitalization.characters,
                onSaved: (value) => _car.vinNumber = value!.isNotEmpty ? value : 'N/A',
              ),
              TextFormField(
                initialValue: _car.engineSize.toString(),
                decoration: InputDecoration(labelText: 'Engine Size'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _car.engineSize = int.tryParse(value!) ?? 0,
              ),
              TextFormField(
                initialValue: _car.enginePower.toString(),
                decoration: InputDecoration(labelText: 'Engine Power'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _car.enginePower = int.tryParse(value!) ?? 0,
              ),
              TextFormField(
                initialValue: _car.color,
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
                initialValue: _car.tireSize,
                decoration: InputDecoration(labelText: 'Tire Size'),
                textCapitalization: TextCapitalization.words,
                onSaved: (value) => _car.tireSize = value!.isNotEmpty ? value : 'N/A',
              ),
              TextFormField(
                initialValue: _car.wiperSize,
                decoration: InputDecoration(labelText: 'Wiper Size'),
                textCapitalization: TextCapitalization.words,
                onSaved: (value) => _car.wiperSize = value!.isNotEmpty ? value : 'N/A',
              ),
              TextFormField(
                initialValue: _car.lightsType,
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
                    await CarService().updateCar(_car);
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
}


