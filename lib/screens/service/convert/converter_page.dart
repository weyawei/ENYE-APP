import 'package:flutter/material.dart';

import '../calculator/calculator_page.dart';
import 'conversion_page.dart';

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
              // Conversion Section Button with Image
              buildSectionButton(
                context,
                'Unit Converter',
                'assets/logo/unitconv.jpg', // Image path
                ConversionPage(),
              ),
              SizedBox(height: 16.0), // Add some spacing
              // Calculator Section Button with Image
              buildSectionButton(
                context,
                'Engineering Calculators',
                'assets/logo/Calcula.jpg', // Image path
                CalculatorPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionButton(BuildContext context, String title,
      String imagePath, Widget page) {
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
          // Set the background color to white
          elevation: MaterialStateProperty.all<double>(0),
          // Remove button elevation
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(16.0),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              // Adjust the border radius as needed
              side: BorderSide(color: Colors.black), // Add a black border
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 100, // Adjust the image width
              height: 100, // Adjust the image height
            ),
            SizedBox(height: 8.0), // Add spacing between image and text
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
