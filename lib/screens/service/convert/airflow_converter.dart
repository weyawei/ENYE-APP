

import 'package:flutter/material.dart';

enum AirflowUnit {
  cubicMeterPerHour,
  cubicFeetPerMinute,
  litersPerSecond,
  gallonsPerMinute,
  cubicFeetPerHour,
  litersPerMinute,
}

class AirFlowPage extends StatefulWidget {
  const AirFlowPage({Key? key});

  @override
  State<AirFlowPage> createState() => _AirFlowPageState();
}

class _AirFlowPageState extends State<AirFlowPage> {
  double inputValue = 0.0;
  double result = 0.0;
  AirflowUnit fromUnit = AirflowUnit.litersPerMinute;
  AirflowUnit toUnit = AirflowUnit.litersPerMinute;

  void convert() {
    setState(() {
      result = AirflowConversion.convertAirflow(inputValue, fromUnit, toUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Airflow Converter')),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
      String label, AirflowUnit unit, Function(AirflowUnit?) onChanged) {
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
        DropdownButton<AirflowUnit>(
          value: unit,
          onChanged: onChanged,
          items: AirflowUnit.values
              .map<DropdownMenuItem<AirflowUnit>>(
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



class AirflowConversion {
  static double convertAirflow(
      double value, AirflowUnit fromUnit, AirflowUnit toUnit) {
    switch (fromUnit) {
      case AirflowUnit.cubicMeterPerHour:
        return _convertFromCubicMeterPerHour(value, toUnit);
      case AirflowUnit.cubicFeetPerMinute:
        return _convertFromCubicFeetPerMinute(value, toUnit);
      case AirflowUnit.litersPerSecond:
        return _convertFromLitersPerSecond(value, toUnit);
      case AirflowUnit.gallonsPerMinute:
        return _convertFromGallonsPerMinute(value, toUnit);
      case AirflowUnit.cubicFeetPerHour:
        return _convertFromCubicFeetPerHour(value, toUnit);
      case AirflowUnit.litersPerMinute:
        return _convertFromLitersPerMinute(value, toUnit);
      default:
        return value;
    }
  }

  static double _convertFromCubicMeterPerHour(
      double value, AirflowUnit toUnit) {
    // Add conversion logic from cubic meter per hour to other units here.
    switch (toUnit) {
      case AirflowUnit.cubicFeetPerMinute:
        return value * 0.588577770215;
      case AirflowUnit.litersPerSecond:
        return value * 0.277777777778;
      case AirflowUnit.gallonsPerMinute:
        return value * 0.131982437892;
      case AirflowUnit.cubicFeetPerHour:
        return value * 35.3146667215;
      case AirflowUnit.litersPerMinute:
        return value * 16.6666666667;
    // If you add more airflow units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromCubicFeetPerMinute(
      double value, AirflowUnit toUnit) {
    // Add conversion logic from cubic feet per minute to other units here.
    switch (toUnit) {
      case AirflowUnit.cubicMeterPerHour:
        return value * 1699.007;
      case AirflowUnit.litersPerSecond:
        return value * 0.471947;
      case AirflowUnit.gallonsPerMinute:
        return value * 0.124664;
      case AirflowUnit.cubicFeetPerHour:
        return value * 1000.0;
      case AirflowUnit.litersPerMinute:
        return value * 28.3168;
    // If you add more airflow units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromLitersPerSecond(
      double value, AirflowUnit toUnit) {
    // Add conversion logic from liters per second to other units here.
    switch (toUnit) {
      case AirflowUnit.cubicMeterPerHour:
        return value * 3600.0;
      case AirflowUnit.cubicFeetPerMinute:
        return value * 2118.88;
      case AirflowUnit.gallonsPerMinute:
        return value * 0.264172;
      case AirflowUnit.cubicFeetPerHour:
        return value * 127132.74;
      case AirflowUnit.litersPerMinute:
        return value * 60.0;
    // If you add more airflow units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromGallonsPerMinute(
      double value, AirflowUnit toUnit) {
    // Add conversion logic from gallons per minute to other units here.
    switch (toUnit) {
      case AirflowUnit.cubicMeterPerHour:
        return value * 0.0630902;
      case AirflowUnit.cubicFeetPerMinute:
        return value * 3.78541;
      case AirflowUnit.litersPerSecond:
        return value * 0.0630902;
      case AirflowUnit.cubicFeetPerHour:
        return value * 2260.7;
      case AirflowUnit.litersPerMinute:
        return value * 227.125;
    // If you add more airflow units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromCubicFeetPerHour(
      double value, AirflowUnit toUnit) {
    // Add conversion logic from cubic feet per hour to other units here.
    switch (toUnit) {
      case AirflowUnit.cubicMeterPerHour:
        return value * 0.0283168;
      case AirflowUnit.cubicFeetPerMinute:
        return value / 60.0;
      case AirflowUnit.litersPerSecond:
        return value * 0.00000786597;
      case AirflowUnit.gallonsPerMinute:
        return value * 0.00000440287;
      case AirflowUnit.litersPerMinute:
        return value * 0.0166667;
    // If you add more airflow units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }

  static double _convertFromLitersPerMinute(
      double value, AirflowUnit toUnit) {
    // Add conversion logic from liters per minute to other units here.
    switch (toUnit) {
      case AirflowUnit.cubicMeterPerHour:
        return value * 0.060;
      case AirflowUnit.cubicFeetPerMinute:
        return value / 1.699;
      case AirflowUnit.litersPerSecond:
        return value / 60.0;
      case AirflowUnit.gallonsPerMinute:
        return value / 3.785;
      case AirflowUnit.cubicFeetPerHour:
        return value * 3.531467;
    // If you add more airflow units in the enum, add their conversion cases here.
      default:
        return value;
    }
  }
}

