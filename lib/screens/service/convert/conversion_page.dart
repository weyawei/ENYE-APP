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

class ConversionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildConversionButton(
                context,
                'Length Conversion',
                Icons.straighten, // Icon for length conversion
                LengthPage(),
              ),
              buildConversionButton(
                context,
                'Pressure Conversion',
                Icons.compress, // Icon for pressure conversion
                PressurePage(),
              ),
              buildConversionButton(
                context,
                'Power Conversion',
                Icons.power, // Icon for power conversion
                PowerPage(),
              ),
              buildConversionButton(
                context,
                'Airflow Conversion',
                Icons.airplay, // Icon for airflow conversion
                AirFlowPage(),
              ),
              buildConversionButton(
                context,
                'Velocity Conversion',
                Icons.speed, // Icon for velocity conversion
                VelocityPage(),
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
              size: 40.0, // Adjust the icon size as needed
              color: Colors.black, // Set icon color to black
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
