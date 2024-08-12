// lib/interactive_image_page.dart
import 'package:flutter/material.dart';
import 'interactive.dart';
// Add more imports as needed

class InteractiveImagePage extends StatelessWidget {
  final String systemId;

  InteractiveImagePage({required this.systemId});

  @override
  Widget build(BuildContext context) {
    Widget interactiveImage;

    // Determine which InteractiveImage widget to display based on systemId
    switch (systemId) {
      case '10':
        interactiveImage = InteractiveImage();
        break;
      case '11':
        interactiveImage = InteractiveImage();
        break;
      case '12':
        interactiveImage = InteractiveImage();
        break;
      case '13':
        interactiveImage = InteractiveImage();
        break;
      case '14':
        interactiveImage = InteractiveImage();
        break;
      case '15':
        interactiveImage = InteractiveImage();
        break;
      case '16':
        interactiveImage = InteractiveImage();
        break;
      case '17':
        interactiveImage = InteractiveImage();
        break;
    // Add more cases as needed
      default:
        interactiveImage = Center(child: Text('No interactive image available'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Image'),
      ),
      body: interactiveImage,
    );
  }
}
