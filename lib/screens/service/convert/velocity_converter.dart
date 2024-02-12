import 'package:flutter/material.dart';

enum VelocityUnit {
  metersPerSecond,
  kilometersPerHour,
  feetPerSecond,
  milesPerHour,
  knots,
}

class VelocityPage extends StatefulWidget {
  const VelocityPage({Key? key});

  @override
  State<VelocityPage> createState() => _VelocityPageState();
}

class _VelocityPageState extends State<VelocityPage> {
  double inputValue = 0.0;
  double result = 0.0;
  VelocityUnit fromUnit = VelocityUnit.feetPerSecond;
  VelocityUnit toUnit = VelocityUnit.feetPerSecond;

  void convert() {
    setState(() {
      result = VelocityConversion.convertVelocity(inputValue, fromUnit, toUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Velocity Converter')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Enter a value:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter a value',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildUnitDropdown('From', fromUnit, (unit) {
                  setState(() {
                    fromUnit = unit!;
                  });
                }),
                buildUnitDropdown('To', toUnit, (unit) {
                  setState(() {
                    toUnit = unit!;
                  });
                }),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Result: $result ${toUnit.toString().split('.').last}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUnitDropdown(
      String label, VelocityUnit unit, Function(VelocityUnit?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<VelocityUnit>(
          value: unit,
          onChanged: onChanged,
          items: VelocityUnit.values
              .map<DropdownMenuItem<VelocityUnit>>(
                (unit) => DropdownMenuItem(
              value: unit,
              child: Text(unit.toString().split('.').last),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}


class VelocityConversion {
  static double convertVelocity(
      double value, VelocityUnit fromUnit, VelocityUnit toUnit) {
    switch (fromUnit) {
      case VelocityUnit.metersPerSecond:
        return _convertFromMetersPerSecond(value, toUnit);
      case VelocityUnit.kilometersPerHour:
        return _convertFromKilometersPerHour(value, toUnit);
      case VelocityUnit.feetPerSecond:
        return _convertFromFeetPerSecond(value, toUnit);
      case VelocityUnit.milesPerHour:
        return _convertFromMilesPerHour(value, toUnit);
      case VelocityUnit.knots:
        return _convertFromKnots(value, toUnit);
      default:
        return value;
    }
  }

  static double _convertFromMetersPerSecond(
      double value, VelocityUnit toUnit) {
    // Add conversion logic from meters per second to other units here.
    switch (toUnit) {
      case VelocityUnit.kilometersPerHour:
        return value * 3.6;
      case VelocityUnit.feetPerSecond:
        return value * 3.28084;
      case VelocityUnit.milesPerHour:
        return value * 2.23694;
      case VelocityUnit.knots:
        return value * 1.94384;
    // If you add more velocity units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromKilometersPerHour(
      double value, VelocityUnit toUnit) {
    // Add conversion logic from kilometers per hour to other units here.
    switch (toUnit) {
      case VelocityUnit.metersPerSecond:
        return value / 3.6;
      case VelocityUnit.feetPerSecond:
        return value * 0.911344;
      case VelocityUnit.milesPerHour:
        return value * 0.621371;
      case VelocityUnit.knots:
        return value * 0.539957;
    // If you add more velocity units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromFeetPerSecond(double value, VelocityUnit toUnit) {
    // Add conversion logic from feet per second to other units here.
    switch (toUnit) {
      case VelocityUnit.metersPerSecond:
        return value * 0.3048;
      case VelocityUnit.kilometersPerHour:
        return value * 1.09728;
      case VelocityUnit.milesPerHour:
        return value * 0.681818;
      case VelocityUnit.knots:
        return value * 0.592484;
    // If you add more velocity units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromMilesPerHour(double value, VelocityUnit toUnit) {
    // Add conversion logic from miles per hour to other units here.
    switch (toUnit) {
      case VelocityUnit.metersPerSecond:
        return value * 0.44704;
      case VelocityUnit.kilometersPerHour:
        return value * 1.60934;
      case VelocityUnit.feetPerSecond:
        return value * 1.46667;
      case VelocityUnit.knots:
        return value * 0.868976;
    // If you add more velocity units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromKnots(double value, VelocityUnit toUnit) {
    // Add conversion logic from knots to other units here.
    switch (toUnit) {
      case VelocityUnit.metersPerSecond:
        return value * 0.514444;
      case VelocityUnit.kilometersPerHour:
        return value * 1.852;
      case VelocityUnit.feetPerSecond:
        return value * 1.68781;
      case VelocityUnit.milesPerHour:
        return value * 1.15078;
    // If you add more velocity units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }
}


