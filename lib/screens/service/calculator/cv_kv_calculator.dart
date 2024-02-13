import 'dart:math';
import 'package:flutter/material.dart';

enum UnitSystem { imperial, metric }

class CVKVPage extends StatefulWidget {
  const CVKVPage({Key? key}) : super(key: key);

  @override
  State<CVKVPage> createState() => _CVKVPageState();
}

class _CVKVPageState extends State<CVKVPage> {
  double flowRate = 0.0;
  double pressureDrop = 0.0;
  double cvResult = 0.0;
  double kvResult = 0.0;
  UnitSystem unitSystem = UnitSystem.imperial;

  void calculateCvKv() {
    setState(() {
      if (unitSystem == UnitSystem.imperial) {
        cvResult = flowRate / sqrt(pressureDrop);
        kvResult = cvResult / 1.156; // Corrected conversion factor for imperial units
      } else {
        cvResult = flowRate / sqrt(pressureDrop);
        kvResult = cvResult / 0.85985; // Conversion factor for metric units
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cv & Kv Calculator'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Flow Rate',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  flowRate = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pressure Drop',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  pressureDrop = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButton<UnitSystem>(
              value: unitSystem,
              onChanged: (unit) {
                setState(() {
                  unitSystem = unit!;
                });
              },
              items: UnitSystem.values
                  .map<DropdownMenuItem<UnitSystem>>(
                    (unit) => DropdownMenuItem(
                  value: unit,
                  child: Text(unit == UnitSystem.imperial
                      ? 'Imperial (GPM, psi)'
                      : 'Metric (m³/h, kPa)'),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateCvKv,
              child: Text('Calculate Cv & Kv'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Cv Result: $cvResult',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Kv Result: $kvResult',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}