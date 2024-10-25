// lib/interactive_image_page.dart
import 'package:enye_app/screens/systems/interactive/bms.dart';
import 'package:enye_app/screens/systems/interactive/chiller.dart';
import 'package:enye_app/screens/systems/interactive/co.dart';
import 'package:enye_app/screens/systems/interactive/ec_bills.dart';
import 'package:enye_app/screens/systems/interactive/ems.dart';
import 'package:enye_app/screens/systems/interactive/fdas.dart';
import 'package:enye_app/screens/systems/interactive/fuel.dart';
import 'package:enye_app/screens/systems/interactive/smart_vav.dart';
import 'package:enye_app/screens/systems/interactive/smoke_extract.dart';
import 'package:enye_app/screens/systems/interactive/stairwell.dart';
import 'package:flutter/material.dart';
import 'interactive.dart';
import 'interactive/fire_smoke.dart';
import 'interactive/model3d.dart';
import 'interactive/smart.dart';
import 'interactive/water.dart';
// Add more imports as needed

class InteractiveImagePage extends StatelessWidget {
  final String systemId;
  final String imageUrl;  // Declare the imageUrl parameter

  InteractiveImagePage({required this.systemId, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Widget interactiveImage;

    // Determine which InteractiveImage widget to display based on systemId
    switch (systemId) {
      case '7':
        interactiveImage = ECBillsPage();
        break;
      case '10':
        interactiveImage = COPage();
        break;
      case '11':
        interactiveImage = SmartVavPage();
        break;
      case '12':
        interactiveImage = ProductZoomPage(imageUrl: imageUrl);
        break;
      case '13':
        interactiveImage = ChillerPage();
        break;
      case '14':
        interactiveImage = SmokeExtractPage();
        break;
      case '15':
        interactiveImage = FireSmokePage();
        break;
      case '16':
        interactiveImage = StairwellPage();
        break;
      case '17':
        interactiveImage = FiremanControlPage();
        break;
      case '18':
        interactiveImage = FuelPage();
        break;
      case '19':
        interactiveImage = EMSPage();
        break;
      case '20':
        interactiveImage = WaterSystemPage();
        break;
      case '21':
        interactiveImage = BMSPage();
        break;
    // Add more cases as needed
      default:
        interactiveImage = Center(child: Text('No interactive image available'));
    }

    return Scaffold(
    /*  appBar: AppBar(
        title: Text('Interactive Image'),
      ),*/
      body: interactiveImage,
    );
  }
}
