
import 'package:flutter/material.dart';

enum LengthUnit {
  meters,
  kilometers,
  feet,
  miles,
  yards,
}

class LengthPage extends StatefulWidget {
  const LengthPage({Key? key});

  @override
  State<LengthPage> createState() => _LengthPageState();
}

class _LengthPageState extends State<LengthPage> {
  double inputValue = 0.0;
  double result = 0.0;
  LengthUnit fromUnit = LengthUnit.feet;
  LengthUnit toUnit = LengthUnit.feet;

  void convert() {
    setState(() {
      result = LengthConversion.convertLength(inputValue, fromUnit, toUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Length Converter')),
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
      String label, LengthUnit unit, Function(LengthUnit?) onChanged) {
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
        DropdownButton<LengthUnit>(
          value: unit,
          onChanged: onChanged,
          items: LengthUnit.values
              .map<DropdownMenuItem<LengthUnit>>(
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


class LengthConversion {
  static double convertLength(
      double value, LengthUnit fromUnit, LengthUnit toUnit) {
    switch (fromUnit) {
      case LengthUnit.meters:
        return _convertFromMeters(value, toUnit);
      case LengthUnit.kilometers:
        return _convertFromKilometers(value, toUnit);
      case LengthUnit.feet:
        return _convertFromFeet(value, toUnit);
      case LengthUnit.miles:
        return _convertFromMiles(value, toUnit);
      case LengthUnit.yards:
        return _convertFromYards(value, toUnit);
      default:
        return value;
    }
  }

  static double _convertFromMeters(double value, LengthUnit toUnit) {
    // Add conversion logic from meters to other units here.
    switch (toUnit) {
      case LengthUnit.kilometers:
        return value * 0.001;
      case LengthUnit.feet:
        return value * 3.28084;
      case LengthUnit.miles:
        return value * 0.000621371;
      case LengthUnit.yards:
        return value * 1.09361;
    // If you add more length units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromKilometers(double value, LengthUnit toUnit) {
    // Add conversion logic from kilometers to other units here.
    switch (toUnit) {
      case LengthUnit.meters:
        return value * 1000.0;
      case LengthUnit.feet:
        return value * 3280.84;
      case LengthUnit.miles:
        return value * 0.621371;
      case LengthUnit.yards:
        return value * 1093.61;
    // If you add more length units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromFeet(double value, LengthUnit toUnit) {
    // Add conversion logic from feet to other units here.
    switch (toUnit) {
      case LengthUnit.meters:
        return value * 0.3048;
      case LengthUnit.kilometers:
        return value * 0.0003048;
      case LengthUnit.miles:
        return value * 0.000189394;
      case LengthUnit.yards:
        return value * 0.333333;
    // If you add more length units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromMiles(double value, LengthUnit toUnit) {
    // Add conversion logic from miles to other units here.
    switch (toUnit) {
      case LengthUnit.meters:
        return value * 1609.34;
      case LengthUnit.kilometers:
        return value * 1.60934;
      case LengthUnit.feet:
        return value * 5280.0;
      case LengthUnit.yards:
        return value * 1760.0;
    // If you add more length units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromYards(double value, LengthUnit toUnit) {
    // Add conversion logic from yards to other units here.
    switch (toUnit) {
      case LengthUnit.meters:
        return value * 0.9144;
      case LengthUnit.kilometers:
        return value * 0.0009144;
      case LengthUnit.feet:
        return value * 3.0;
      case LengthUnit.miles:
        return value * 0.000568182;
    // If you add more length units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }
}
