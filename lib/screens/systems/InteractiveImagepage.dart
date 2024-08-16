// lib/interactive_image_page.dart
import 'package:enye_app/screens/systems/interactive/chiller.dart';
import 'package:enye_app/screens/systems/interactive/fdas.dart';
import 'package:enye_app/screens/systems/interactive/smart_vav.dart';
import 'package:enye_app/screens/systems/interactive/smoke_extract.dart';
import 'package:enye_app/screens/systems/interactive/stairwell.dart';
import 'package:flutter/material.dart';
import 'interactive.dart';
import 'interactive/fire_smoke.dart';
import 'interactive/smart.dart';
// Add more imports as needed

class InteractiveImagePage extends StatelessWidget {
  final String systemId;

  InteractiveImagePage({required this.systemId});

  @override
  Widget build(BuildContext context) {
    Widget interactiveImage;

    // Determine which InteractiveImage widget to display based on systemId
    switch (systemId) {
      case '100':
        interactiveImage = Smart();
        break;
      case '110':
        interactiveImage = SmartVavPage();
        break;
      case '12':
        interactiveImage = ProductZoomPage();
        break;
      case '130':
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
      case '180':
        interactiveImage = Smart();
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
