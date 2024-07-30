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
  int _currentStep = 0;

  final _makerController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _carPlateController = TextEditingController();

  final _vinController = TextEditingController();
  final _colorController = TextEditingController();
  final _tireSizeController = TextEditingController();
  final _wiperSizeController = TextEditingController();
  final _lightsTypeController = TextEditingController();

  final _engineSizeController = TextEditingController();
  final _enginePowerController = TextEditingController();
  String _fuelType = 'Petrol';
  String _transmission = 'Manual';
  bool _status = true;

  @override
  void initState() {
    super.initState();
    _loadCar();
  }

  Future<void> _loadCar() async {
    _car = (await CarService().getCarById(widget.carId))!;
    _populateControllers();
    setState(() {
      _loading = false;
    });
  }

  void _populateControllers() {
    _makerController.text = _car.maker;
    _modelController.text = _car.model;
    _yearController.text = _car.year.toString();
    _carPlateController.text = _car.carPlate;
    _vinController.text = _car.vinNumber;
    _colorController.text = _car.color;
    _tireSizeController.text = _car.tireSize;
    _wiperSizeController.text = _car.wiperSize;
    _lightsTypeController.text = _car.lightsType;
    _engineSizeController.text = _car.engineSize.toString();
    _enginePowerController.text = _car.enginePower.toString();
    _fuelType = _car.fuelType;
    _transmission = _car.transmission;
    _status = _car.status;
  }

  void _onStepContinue() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        _formKey.currentState!.save();
        _saveCar();
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

  Future<void> _saveCar() async {
    final car = Car(
      id: _car.id,
      maker: _makerController.text.isNotEmpty ? _makerController.text : 'N/A',
      model: _modelController.text,
      year: int.tryParse(_yearController.text) ?? 0,
      carPlate: _carPlateController.text,
      vinNumber: _vinController.text.isNotEmpty ? _vinController.text : 'N/A',
      engineSize: int.tryParse(_engineSizeController.text) ?? 0,
      enginePower: int.tryParse(_enginePowerController.text) ?? 0,
      color: _colorController.text.isNotEmpty ? _colorController.text : 'N/A',
      fuelType: _fuelType,
      transmission: _transmission,
      tireSize: _tireSizeController.text.isNotEmpty
          ? _tireSizeController.text
          : 'N/A',
      wiperSize: _wiperSizeController.text.isNotEmpty
          ? _wiperSizeController.text
          : 'N/A',
      lightsType: _lightsTypeController.text.isNotEmpty
          ? _lightsTypeController.text
          : 'N/A',
      status: _status,
    );

    await CarService().updateCar(car);
    Navigator.pop(context);
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
                      title: Text('Basic Information'),
                      content: Column(
                        children: [
                          _buildTextField(
                            label: 'Maker',
                            controller: _makerController,
                            textCapitalization: TextCapitalization.words,
                          ),
                          _buildTextField(
                            label: 'Model *',
                            controller: _modelController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the model';
                              }
                              return null;
                            },
                          ),
                          _buildTextField(
                            label: 'Year',
                            controller: _yearController,
                            keyboardType: TextInputType.number,
                          ),
                          _buildTextField(
                            label: 'Car Plate *',
                            controller: _carPlateController,
                            textCapitalization: TextCapitalization.characters,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the car plate';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: Text('Additional Details'),
                      content: Column(
                        children: [
                          _buildTextField(
                            label: 'VIN Number',
                            controller: _vinController,
                            textCapitalization: TextCapitalization.characters,
                          ),
                          _buildTextField(
                            label: 'Color',
                            controller: _colorController,
                            textCapitalization: TextCapitalization.words,
                          ),
                          _buildTextField(
                            label: 'Tire Size',
                            controller: _tireSizeController,
                            textCapitalization: TextCapitalization.words,
                          ),
                          _buildTextField(
                            label: 'Wiper Size',
                            controller: _wiperSizeController,
                            textCapitalization: TextCapitalization.words,
                          ),
                          _buildTextField(
                            label: 'Lights Type',
                            controller: _lightsTypeController,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 1,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: Text('Engine'),
                      content: Column(
                        children: [
                          _buildTextField(
                            label: 'Engine Size',
                            controller: _engineSizeController,
                            keyboardType: TextInputType.number,
                          ),
                          _buildTextField(
                            label: 'Engine Power',
                            controller: _enginePowerController,
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Fuel Type'),
                            value: _fuelType,
                            onChanged: (String? newValue) {
                              setState(() {
                                _fuelType = newValue!;
                              });
                            },
                            items: [
                              'Petrol',
                              'Diesel',
                              'Hybrid',
                              'Electric',
                              'Other'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          DropdownButtonFormField<String>(
                            decoration:
                                InputDecoration(labelText: 'Transmission'),
                            value: _transmission,
                            onChanged: (String? newValue) {
                              setState(() {
                                _transmission = newValue!;
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
                          SwitchListTile(
                            title: Text('Status'),
                            value: _status,
                            onChanged: (bool value) {
                              setState(() {
                                _status = value;
                              });
                            },
                          ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
