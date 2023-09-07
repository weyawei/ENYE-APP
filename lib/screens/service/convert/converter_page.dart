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

class ConverterPage extends StatelessWidget {
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
                'HVAC Size Calculator',
                HVACCalcutor(),
              ),
              buildConversionButton(
                context,
                'Length Conversion',
                LengthPage(),
              ),
              buildConversionButton(
                context,
                'Pressure Conversion',
                PressurePage(),
              ),
              buildConversionButton(
                context,
                'Power Conversion',
                PowerPage(),
              ),
              buildConversionButton(
                context,
                'Airflow Conversion',
                AirFlowPage(),
              ),
              buildConversionButton(
                context,
                'Velocity Conversion',
                VelocityPage(),
              ),
              buildConversionButton(
                context,
                'Valve Sizing Calculator',
                ValvesCalcuPage(),
              ),
              buildConversionButton(
                context,
                'VAV Calculator',
                VAVPage(),
              ),
              buildConversionButton(
                context,
                'CV & KV Calculator',
                CVKVPage(),
              ),
              buildConversionButton(
                context,
                'Scientific Calculator',
                EngineeringCalcu(),
              ),
              buildConversionButton(
                context,
                'Heating BTU Calculator',
                HeatingBTUCalcu(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConversionButton(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}
