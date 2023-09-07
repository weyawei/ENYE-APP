import 'package:flutter/material.dart';

enum PowerUnit {
  btuPerHour,
  gigawatt,
  horsepower,
  joulePerSecond,
  kilowatt,
  watt,
}

class PowerPage extends StatefulWidget {
  const PowerPage({Key? key});

  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  double inputValue = 0.0;
  double result = 0.0;
  PowerUnit fromUnit = PowerUnit.btuPerHour;
  PowerUnit toUnit = PowerUnit.btuPerHour;

  void convert() {
    setState(() {
      result = Conversion.convertPower(inputValue, fromUnit, toUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Power Converter')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0), // Add some spacing at the top
            Text(
              'Enter a value:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0), // Add spacing between text and input field
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
            SizedBox(height: 20.0), // Add spacing after input field
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
            SizedBox(height: 20.0), // Add spacing after unit dropdowns
            ElevatedButton(
              onPressed: convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20.0), // Add spacing after the Convert button
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
      String label, PowerUnit unit, Function(PowerUnit?) onChanged) {
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
        DropdownButton<PowerUnit>(
          value: unit,
          onChanged: onChanged,
          items: PowerUnit.values
              .map<DropdownMenuItem<PowerUnit>>(
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


class Conversion {
  static double convertPower(double value, PowerUnit fromUnit, PowerUnit toUnit) {
    switch (fromUnit) {
      case PowerUnit.btuPerHour:
        return _convertFromBTUPerHour(value, toUnit);
      case PowerUnit.gigawatt:
        return _convertFromGigawatt(value, toUnit);
      case PowerUnit.horsepower:
        return _convertFromHorsepower(value, toUnit);
      case PowerUnit.joulePerSecond:
        return _convertFromJoulePerSecond(value, toUnit);
      case PowerUnit.kilowatt:
        return _convertFromKilowatt(value, toUnit);
      case PowerUnit.watt:
        return _convertFromWatt(value, toUnit);
      default:
        return value;
    }
  }

  static double _convertFromBTUPerHour(double value, PowerUnit toUnit) {
    switch (toUnit) {
      case PowerUnit.gigawatt:
        return value * 2.93071e-13;
      case PowerUnit.horsepower:
        return value * 0.0003930148;
      case PowerUnit.joulePerSecond:
        return value * 0.0002930711;
      case PowerUnit.kilowatt:
        return value * 0.0002930711;
      case PowerUnit.watt:
        return value * 0.2930710702;
      default:
        return value;
    }
  }

  static double _convertFromGigawatt(double value, PowerUnit toUnit) {
    // Add conversion logic from gigawatt to other units here.
    switch (toUnit) {
      case PowerUnit.btuPerHour:
        return value / 2.93071e-13;
      case PowerUnit.horsepower:
        return value / 0.00000000134102;
      case PowerUnit.joulePerSecond:
        return value * 1e9;
      case PowerUnit.kilowatt:
        return value * 1e6;
      case PowerUnit.watt:
        return value * 1e9;
      default:
        return value;
    }
  }

  static double _convertFromHorsepower(double value, PowerUnit toUnit) {
    // Add conversion logic from horsepower to other units here.
    switch (toUnit) {
      case PowerUnit.btuPerHour:
        return value * 2544.43; // Approximate conversion factor
      case PowerUnit.gigawatt:
        return value * 7.456e-10;
      case PowerUnit.joulePerSecond:
        return value * 745.7; // Exact conversion factor
      case PowerUnit.kilowatt:
        return value * 0.7457; // Exact conversion factor
      case PowerUnit.watt:
        return value * 745.7 * 1000.0; // Exact conversion factor
      default:
        return value;
    }
  }

  static double _convertFromJoulePerSecond(double value, PowerUnit toUnit) {
    // Add conversion logic from joule per second to other units here.
    switch (toUnit) {
      case PowerUnit.btuPerHour:
        return value * 3412.14; // Approximate conversion factor
      case PowerUnit.gigawatt:
        return value * 1e-9; // Exact conversion factor
      case PowerUnit.horsepower:
        return value / 745.7; // Exact conversion factor
      case PowerUnit.kilowatt:
        return value / 1000.0; // Exact conversion factor
      case PowerUnit.watt:
        return value * 1000.0; // Exact conversion factor
      default:
        return value;
    }
  }

  static double _convertFromKilowatt(double value, PowerUnit toUnit) {
    // Add conversion logic from kilowatt to other units here.
    switch (toUnit) {
      case PowerUnit.btuPerHour:
        return value * 3412.14; // Approximate conversion factor
      case PowerUnit.gigawatt:
        return value * 1e-6; // Exact conversion factor
      case PowerUnit.horsepower:
        return value / 0.7457; // Exact conversion factor
      case PowerUnit.joulePerSecond:
        return value * 1000.0; // Exact conversion factor
      case PowerUnit.watt:
        return value * 1000.0; // Exact conversion factor
      default:
        return value;
    }
  }

  static double _convertFromWatt(double value, PowerUnit toUnit) {
    // Add conversion logic from watt to other units here.
    switch (toUnit) {
      case PowerUnit.btuPerHour:
        return value * 3.412142; // Approximate conversion factor
      case PowerUnit.gigawatt:
        return value * 1e-9; // Exact conversion factor
      case PowerUnit.horsepower:
        return value / 745.7; // Exact conversion factor
      case PowerUnit.joulePerSecond:
        return value / 1000.0; // Exact conversion factor
      case PowerUnit.kilowatt:
        return value / 1000.0; // Exact conversion factor
      default:
        return value;
    }
  }
}







double convertPower(double value, PowerUnit fromUnit, PowerUnit toUnit) {
  switch (fromUnit) {
    case PowerUnit.watt:
      switch (toUnit) {
        case PowerUnit.kilowatt:
          return value / 1000.0;
      // Add more conversion cases as needed.
        default:
          return value; // No conversion needed for the same unit.
      }
    case PowerUnit.kilowatt:
      switch (toUnit) {
        case PowerUnit.watt:
          return value * 1000.0;
      // Add more conversion cases as needed.
        default:
          return value; // No conversion needed for the same unit.
      }
  // Add more cases for other units.
    default:
      return value; // No conversion needed for the same unit.
  }
}
