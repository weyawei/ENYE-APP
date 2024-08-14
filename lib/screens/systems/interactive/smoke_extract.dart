import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Import ModelViewer

class SmokeExtractPage extends StatefulWidget {
  @override
  _SmokeExtractPageState createState() => _SmokeExtractPageState();
}

class _SmokeExtractPageState extends State<SmokeExtractPage> {
  final TransformationController _transformationController = TransformationController();
  Offset? _arrowPosition;
  Offset? _floatingButtonPosition;
  bool _showFloatingButton = false;
  bool _showArrow = false;

  // Reset the view to the initial state
  void _resetView() {
    setState(() {
      _transformationController.value = Matrix4.identity(); // Reset zoom
      _showFloatingButton = false;
      _showArrow = false;
      _arrowPosition = null;
      _floatingButtonPosition = null;
    });
  }

  // Zoom to a product
  void _zoomToProduct(Rect productRect, Offset arrowOffset, Offset buttonOffset, VoidCallback onDetailsPressed) {
    double scale = 3.0; // Example scale factor
    final zoomedMatrix = Matrix4.identity()
      ..translate(-productRect.left * scale, -productRect.top * scale)
      ..scale(scale);

    _transformationController.value = zoomedMatrix;

    setState(() {
      _arrowPosition = _transformationController.toScene(
        Offset(productRect.left + productRect.width / 2, productRect.top + productRect.height / 2),
      );
      _showFloatingButton = true;
      _showArrow = true;

      // Apply custom offsets
      _arrowPosition = _arrowPosition! + arrowOffset;
      _floatingButtonPosition = _arrowPosition! + buttonOffset;
    });

    _floatingButtonAction = onDetailsPressed;
  }

  VoidCallback? _floatingButtonAction;

  // Separate methods for each product's details
  void _showProduct1Details(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "EC Smoke Extraction System Controller (EC-SES)",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3E5C),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/smoke_extract/omni.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
              Text(
                "EC Smoke Extraction System Controller (EC-SES)",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              Text(
                "\n Features \n\n• 40, 20 or 14 Point (UI/O) models with the ability to use any point  as an input or output, allowing greater flexibility \n• UI/O update rates up to 500Hz (2ms) \n• Individual UI/O LEDs for status indication and fault diagnostics \n• Ethernet, RS-485 and USB communications \n• Battery backed Real Time Clock for memory 5 years. \n• Feature rich multi -platform Web-server \n• Polarity independent AC or DC Power Supply \n• User replaceable log data memory via MicroSD \n• Reporting of controller and programmable point self -diagnostics \n• Click and drag programming \n• Easily accessible USB ports offer a fast localised configuration interface and access to logged data.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.036,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF2E3E5C),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetView();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showProduct2Details(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fire and Smoke Damper Actuator"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/smoke_extract/smoke_damper.png',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              Text(
                "Fire and Smoke Damper Actuator",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              Text(
                "\n Features \n\n• Selectable direction of rotation \n• Manual over-ride by crank handle when required \n• Thermal sensor option available \n• Anti-rotation bracket provided \n• 2 Fixed auxiliary switches (SPDT) \n• Maintenance free",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.036,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF2E3E5C),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetView();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schematic Diagram'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Image with InteractiveViewer and GestureDetectors
          Column(
            children: [
              SizedBox(height: 50),
              Expanded(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/systems/smoke_extract/smoke.png',
                        height: MediaQuery.of(context).size.height * 0.4, // Relative height
                        fit: BoxFit.fill,
                      ),
                      // GestureDetector for Product 1
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.59,
                        top: MediaQuery.of(context).size.height * 0.05, // Adjusted for relative positioning
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            _showProduct1Details(context);
                          },
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // GestureDetector for Product 2
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.55,
                        top: MediaQuery.of(context).size.height * 0.17, // Adjusted for relative positioning
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            _showProduct2Details(context);
                          },
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Small image buttons corresponding to different products
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/smoke_extract/omni.png',
                        height: MediaQuery.of(context).size.height * 0.2, // Relative height
                        fit: BoxFit.fill,
                      ),
                      iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(
                            MediaQuery.of(context).size.width * 0.46,
                            MediaQuery.of(context).size.height * 0.01,
                            MediaQuery.of(context).size.width * 0.1,
                            MediaQuery.of(context).size.height * 0.1,
                          ),
                          Offset(MediaQuery.of(context).size.width * -0.28, MediaQuery.of(context).size.height * 0.2),
                          Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                              () => _showProduct1Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/smoke_extract/smoke_damper.png',
                        height: MediaQuery.of(context).size.height * 0.2, // Relative height
                        fit: BoxFit.fill,
                      ),
                      iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(
                            MediaQuery.of(context).size.width * 0.4,
                            MediaQuery.of(context).size.height * 0.07,
                            MediaQuery.of(context).size.width * 0.1,
                            MediaQuery.of(context).size.height * 0.1,
                          ),
                          Offset(MediaQuery.of(context).size.width * -0.15, MediaQuery.of(context).size.height * 0.3),
                          Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                              () => _showProduct2Details(context),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Arrow and Floating Button
          if (_showArrow && _arrowPosition != null)
            Positioned(
              left: _arrowPosition!.dx,
              top: _arrowPosition!.dy,
              child: Icon(
                Icons.arrow_drop_up,
                color: Colors.transparent,
                size: 100,
              ),
            ),
          if (_showFloatingButton && _floatingButtonPosition != null)
            Positioned(
              left: _floatingButtonPosition!.dx,
              top: _floatingButtonPosition!.dy,
              child: FloatingActionButton.extended(
                onPressed: _floatingButtonAction,
                label: Text('View Details'),
                icon: Icon(Icons.info_outline),
              ),
            ),
        ],
      ),
    );
  }
}
