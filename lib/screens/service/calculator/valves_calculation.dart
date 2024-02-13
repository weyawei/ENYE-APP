import 'dart:math';
import 'package:flutter/material.dart';

class ValvesCalcuPage extends StatefulWidget {
  const ValvesCalcuPage({Key? key});

  @override
  State<ValvesCalcuPage> createState() => _ValvesCalcuPageState();
}

class _ValvesCalcuPageState extends State<ValvesCalcuPage> {
  double flowRate = 0.0;
  double pressureDrop = 0.0;
  double cvValue = 0.0;

  void calculateCv() {
    setState(() {
      cvValue = flowRate / sqrt(pressureDrop);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valve Sizing Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Formula: \n Cv = Flow Rate (GPM) / sqrt(Pressure Drop (psi))'),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Flow Rate (GPM)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    flowRate = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Pressure Drop (psi)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    pressureDrop = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateCv,
                child: Text('Calculate Cv'),
              ),
              SizedBox(height: 20),
              Text(
                'Required Cv Value:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$cvValue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
