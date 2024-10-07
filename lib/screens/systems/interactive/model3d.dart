import 'package:enye_app/screens/projects/project_page2.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerBackgroundExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background ModelViewer (zoomable)
          Positioned.fill(
            child: ModelViewer(
              src: 'assets/systems/ec_bills/ec_bill.glb', // Background 3D model
              alt: 'A 3D background model',
              ar: false,
              cameraControls: true, // Enable zoom for the background
              autoRotate: false,    // Disable auto-rotate for manual zooming
              backgroundColor: Colors.transparent,
            ),
          ),
          // Foreground clickable models (fixed position)
          Positioned(
            top: 100, // Fixed position relative to the screen, not affected by zoom
            left: 100,
            child: GestureDetector(
              onTap: () {
                // Handle click event for this small model
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectPage2(),
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.white, // Make the container transparent
                child: ModelViewer(
                  src: 'assets/systems/chiller/temp_sensor.glb', // Smaller model
                  alt: 'A 3D clickable model',
                  cameraControls: false, // No zoom for small model
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: 200, // Fixed position relative to the screen
            left: 200,
            child: GestureDetector(
              onTap: () {
                // Handle click event for this small model
                print('Clicked on model 2');
                // Add navigation or action here if needed
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.transparent, // Make the container transparent
                child: ModelViewer(
                  src: 'assets/systems/smart/air_velocity.glb', // Another small model
                  alt: 'A 3D clickable model',
                  cameraControls: false, // No zoom for small model
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
          // Add more clickable models as needed
        ],
      ),
    );
  }
}
