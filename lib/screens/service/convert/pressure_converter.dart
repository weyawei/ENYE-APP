import 'package:flutter/material.dart';

enum PressureUnit {
  pascals,
  kilopascals,
  megapascals,
  bars,
  atmospheres,
}

class PressurePage extends StatefulWidget {
  const PressurePage({Key? key});

  @override
  State<PressurePage> createState() => _PressurePageState();
}

class _PressurePageState extends State<PressurePage> {
  double inputValue = 0.0;
  double result = 0.0;
  PressureUnit fromUnit = PressureUnit.bars;
  PressureUnit toUnit = PressureUnit.bars;

  void convert() {
    setState(() {
      result = PressureConversion.convertPressure(inputValue, fromUnit, toUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pressure Converter')),
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
      String label, PressureUnit unit, Function(PressureUnit?) onChanged) {
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
        DropdownButton<PressureUnit>(
          value: unit,
          onChanged: onChanged,
          items: PressureUnit.values
              .map<DropdownMenuItem<PressureUnit>>(
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


class PressureConversion {
  static double convertPressure(
      double value, PressureUnit fromUnit, PressureUnit toUnit) {
    switch (fromUnit) {
      case PressureUnit.pascals:
        return _convertFromPascals(value, toUnit);
      case PressureUnit.kilopascals:
        return _convertFromKilopascals(value, toUnit);
      case PressureUnit.megapascals:
        return _convertFromMegapascals(value, toUnit);
      case PressureUnit.bars:
        return _convertFromBars(value, toUnit);
      case PressureUnit.atmospheres:
        return _convertFromAtmospheres(value, toUnit);
      default:
        return value;
    }
  }

  static double _convertFromPascals(double value, PressureUnit toUnit) {
    // Add conversion logic from pascals to other units here.
    switch (toUnit) {
      case PressureUnit.kilopascals:
        return value * 0.001;
      case PressureUnit.megapascals:
        return value * 1e-6;
      case PressureUnit.bars:
        return value * 1e-5;
      case PressureUnit.atmospheres:
        return value * 9.86923e-6;
    // If you add more pressure units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromKilopascals(double value, PressureUnit toUnit) {
    // Add conversion logic from kilopascals to other units here.
    switch (toUnit) {
      case PressureUnit.pascals:
        return value * 1000.0;
      case PressureUnit.megapascals:
        return value * 0.001;
      case PressureUnit.bars:
        return value * 0.01;
      case PressureUnit.atmospheres:
        return value * 0.00986923;
    // If you add more pressure units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromMegapascals(double value, PressureUnit toUnit) {
    // Add conversion logic from megapascals to other units here.
    switch (toUnit) {
      case PressureUnit.pascals:
        return value * 1e6;
      case PressureUnit.kilopascals:
        return value * 1000.0;
      case PressureUnit.bars:
        return value * 10.0;
      case PressureUnit.atmospheres:
        return value * 9.86923;
    // If you add more pressure units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromBars(double value, PressureUnit toUnit) {
    // Add conversion logic from bars to other units here.
    switch (toUnit) {
      case PressureUnit.pascals:
        return value * 1e5;
      case PressureUnit.kilopascals:
        return value * 100.0;
      case PressureUnit.megapascals:
        return value * 0.1;
      case PressureUnit.atmospheres:
        return value * 0.986923;
    // If you add more pressure units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromAtmospheres(double value, PressureUnit toUnit) {
    // Add conversion logic from atmospheres to other units here.
    switch (toUnit) {
      case PressureUnit.pascals:
        return value * 101325.0;
      case PressureUnit.kilopascals:
        return value * 101.325;
      case PressureUnit.megapascals:
        return value * 0.101325;
      case PressureUnit.bars:
        return value * 1.01325;
    // If you add more pressure units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }
}
