import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Unit { meters, feet }
enum TemperatureUnit { celsius, fahrenheit }
enum InsulationCondition { good, normal, poor }

class HeatingBTUCalcu extends StatefulWidget {
  const HeatingBTUCalcu({Key? key}) : super(key: key);

  @override
  State<HeatingBTUCalcu> createState() => _HeatingBTUCalcuState();
}

class _HeatingBTUCalcuState extends State<HeatingBTUCalcu> {
  Unit roomDimensionUnit = Unit.meters;
  double roomWidth = 5.0;
  double roomLength = 5.0;
  double ceilingHeight = 3.0;
  double deltaT = 25.0; // Desired temperature increase in Celsius
  InsulationCondition insulationCondition = InsulationCondition.normal; // Default to normal insulation
  double requiredBTU = 0.0;

  String roomWidthError = '';
  String roomLengthError = '';
  String ceilingHeightError = '';
  String deltaTError = '';

  final List<DropdownMenuItem<Unit>> dimensionUnitItems = [
    DropdownMenuItem(
      value: Unit.meters,
      child: Text('Meters'),
    ),
    DropdownMenuItem(
      value: Unit.feet,
      child: Text('Feet'),
    ),
  ];

  final List<DropdownMenuItem<InsulationCondition>> insulationItems = [
    DropdownMenuItem(
      value: InsulationCondition.good,
      child: Text('Good Insulation'),
    ),
    DropdownMenuItem(
      value: InsulationCondition.normal,
      child: Text('Normal Insulation'),
    ),
    DropdownMenuItem(
      value: InsulationCondition.poor,
      child: Text('Poor Insulation'),
    ),
  ];

  final List<DropdownMenuItem<TemperatureUnit>> temperatureUnitItems = [
    DropdownMenuItem(
      value: TemperatureUnit.celsius,
      child: Text('Celsius (°C)'),
    ),
    DropdownMenuItem(
      value: TemperatureUnit.fahrenheit,
      child: Text('Fahrenheit (°F)'),
    ),
  ];

  TemperatureUnit selectedTemperatureUnit = TemperatureUnit.celsius; // Default to Celsius

  void calculateRequiredBTU() {
    setState(() {
      double roomWidthInFeet = roomDimensionUnit == Unit.meters
          ? roomWidth * 3.28084 // 1 meter = 3.28084 feet
          : roomWidth;

      double roomLengthInFeet = roomDimensionUnit == Unit.meters
          ? roomLength * 3.28084
          : roomLength;

      double temperatureDifference = deltaT;

      if (selectedTemperatureUnit == TemperatureUnit.fahrenheit) {
        temperatureDifference = (deltaT - 32) * 5 / 9; // Convert Fahrenheit to Celsius
      }

      double insulationMultiplier = 0.0;

      // Set insulation multiplier based on selected insulation condition
      switch (insulationCondition) {
        case InsulationCondition.good:
          insulationMultiplier = 30.0 / 35.0;
          break;
        case InsulationCondition.normal:
          insulationMultiplier = 1.0; // No change for normal insulation
          break;
        case InsulationCondition.poor:
          insulationMultiplier = 40.0 / 35.0;
          break;
      }

      requiredBTU =
          (roomWidthInFeet * roomLengthInFeet * ceilingHeight) *
              insulationMultiplier * temperatureDifference;

      // Validate input fields and update error messages
      if (roomWidth <= 0) {
        roomWidthError = 'Width must be greater than 0';
      } else {
        roomWidthError = '';
      }

      if (roomLength <= 0) {
        roomLengthError = 'Length must be greater than 0';
      } else {
        roomLengthError = '';
      }

      if (ceilingHeight <= 0) {
        ceilingHeightError = 'Ceiling height must be greater than 0';
      } else {
        ceilingHeightError = '';
      }

      if (deltaT <= 0) {
        deltaTError = 'Desired temperature increase must be greater than 0';
      } else {
        deltaTError = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heating BTU Calculator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildInputFieldWidth(
                    label: 'Room/House Width',
                    errorText: roomWidthError,
                    onChanged: (value) {
                      setState(() {
                        roomWidth = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButton<Unit>(
                    value: roomDimensionUnit,
                    onChanged: (value) {
                      setState(() {
                        roomDimensionUnit = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: Unit.meters,
                        child: Text('Meters'),
                      ),
                      DropdownMenuItem(
                        value: Unit.feet,
                        child: Text('Feet'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildInputFieldLength(
                    label: 'Room/House Length',
                    errorText: roomLengthError,
                    onChanged: (value) {
                      setState(() {
                        roomLength = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButton<Unit>(
                    value: roomDimensionUnit,
                    onChanged: (value) {
                      setState(() {
                        roomDimensionUnit = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: Unit.meters,
                        child: Text('Meters'),
                      ),
                      DropdownMenuItem(
                        value: Unit.feet,
                        child: Text('Feet'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildInputFieldHeight(
                    label: 'Ceiling Height',
                    errorText: ceilingHeightError,
                    onChanged: (value) {
                      setState(() {
                        ceilingHeight = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButton<Unit>(
                    value: roomDimensionUnit,
                    onChanged: (value) {
                      setState(() {
                        roomDimensionUnit = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: Unit.meters,
                        child: Text('Meters'),
                      ),
                      DropdownMenuItem(
                        value: Unit.feet,
                        child: Text('Feet'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DropdownButton<InsulationCondition>(
              value: insulationCondition,
              onChanged: (value) {
                setState(() {
                  insulationCondition = value!;
                });
              },
              items: insulationItems,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildInputField(
                    label: 'Desired Temperature Increase',
                    onChanged: (value) {
                      setState(() {
                        deltaT = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButton<TemperatureUnit>(
                    value: selectedTemperatureUnit,
                    onChanged: (value) {
                      setState(() {
                        selectedTemperatureUnit = value!;
                      });
                    },
                    items: temperatureUnitItems.map((unit) {
                      return DropdownMenuItem(
                        value: unit.value,
                        child: Text(
                          unit.value == TemperatureUnit.celsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (roomWidthError.isEmpty &&
                    roomLengthError.isEmpty &&
                    ceilingHeightError.isEmpty &&
                    deltaTError.isEmpty) {
                  calculateRequiredBTU();
                }
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Required BTU: $requiredBTU',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFieldWidth({
    required String label,
    required Function(String) onChanged,
    String? errorText,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildInputFieldLength({
    required String label,
    required Function(String) onChanged,
    String? errorText,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildInputFieldHeight({
    required String label,
    required Function(String) onChanged,
    String? errorText,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildInputField({
    required String label,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: onChanged,
    );
  }
}