import 'package:enye_app/screens/service/calculator/cv_kv_calculator.dart';
import 'package:enye_app/screens/service/calculator/heating_btu_calculator.dart';
import 'package:enye_app/screens/service/convert/engineering_calculator.dart';
import 'package:enye_app/screens/service/calculator/hvac_calculator.dart';
import 'package:enye_app/screens/service/calculator/valves_calculation.dart';
import 'package:enye_app/screens/service/calculator/vav_calculation.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/screens/service/convert/airflow_converter.dart';
import 'package:enye_app/screens/service/convert/length_converter.dart';
import 'package:enye_app/screens/service/convert/power_converter.dart';
import 'package:enye_app/screens/service/convert/pressure_converter.dart';
import 'package:enye_app/screens/service/convert/velocity_converter.dart';

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Calculator'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildConversionButton(
                context,
                'HVAC Size Calculator',
                Icons.ac_unit, // Icon for HVAC Size Calculator
                HVACCalcutor(),
              ),
              buildConversionButton(
                context,
                'Valve Sizing Calculator',
                Icons.adjust, // Icon for Valve Sizing Calculator
                ValvesCalcuPage(),
              ),
              buildConversionButton(
                context,
                'VAV Calculator',
                Icons.vertical_align_center, // Icon for VAV Calculator
                VAVPage(),
              ),
              buildConversionButton(
                context,
                'CV & KV Calculator',
                Icons.device_hub, // Icon for CV & KV Calculator
                CVKVPage(),
              ),
              buildConversionButton(
                context,
                'Scientific Calculator',
                Icons.calculate, // Icon for Scientific Calculator
                EngineeringCalcu(),
              ),
              buildConversionButton(
                context,
                'Heating BTU Calculator',
                Icons.whatshot, // Icon for Heating BTU Calculator
                HeatingBTUCalcu(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConversionButton(BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all<double>(0),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(16.0),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: Colors.black),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 40.0,
              color: Colors.black,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
