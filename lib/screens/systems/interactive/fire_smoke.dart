import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Import ModelViewer

class FireSmokePage extends StatefulWidget {
  @override
  _FireSmokePageState createState() => _FireSmokePageState();
}

class _FireSmokePageState extends State<FireSmokePage> with TickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  Offset? _arrowPosition;
  Offset? _floatingButtonPosition;
  bool _showFloatingButton = false;
  bool _showArrow = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


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

    _showFloatingButton = true;
    _floatingButtonPosition = _arrowPosition! + buttonOffset;

    // Set action for the floating button
    setState(() {
      _showFloatingButton = true;
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
          "OMNI Controller",
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
                'assets/systems/fire_smoke/omni.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
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
              Image.asset(
                'assets/systems/fire_smoke/smoke_damper.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
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

  void _showProduct3Details(BuildContext context) {
    // Code to display image or other details for Product 1
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Duct Smoke Detector",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.045,
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C)
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/fire_smoke/duct_smoke.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
              Text(
                "DUCT SMOKE DETECTOR",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Provide early detection of smoke and products of combustion present in the air moving through a duct. \n• Designed and built to meet all local requirements, as well as the NFPA regulations regarding duct smoke detectors. \n• Output terminals are provided for remote accessories such as horns, strobes, remote status indicators, and test/reset key switches or pushbuttons. \n• Provides (2) sets of 10A Form C alarm contacts, along with (1) set of 10A Form C trouble contacts for monitoring head removal and supply voltage failure.",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.036,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF2E3E5C)
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
      appBar: AppBar(title: Text('Schematic Diagram'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Image with InteractiveViewer and GestureDetectors
          Column(
            children: [
              SizedBox(height: 50,),
              Expanded(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/systems/fire_smoke/fire_smoke.png',
                        height: MediaQuery.of(context).size.height * 0.52, // Relative height
                        fit: BoxFit.fill,
                      ),
                      // GestureDetector for Product 1
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.605,
                        top: MediaQuery.of(context).size.height * 0.071, // Adjusted for relative positioning
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            _showProduct1Details(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Circle Effect with Transparent Center
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    child: CustomPaint(
                                      painter: GlowingCirclePainter(_animationController.value),
                                    ),
                                  );
                                },
                              ),
                              // Transparent Container for interaction
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.09,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.60,
                        top: MediaQuery.of(context).size.height * 0.11, // Adjusted for relative positioning
                        child: Text(
                          'OMNI', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      // GestureDetector for Product 2
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.56,
                        top: MediaQuery.of(context).size.height * 0.25, // Adjusted for relative positioning
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            _showProduct2Details(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Circle Effect with Transparent Center
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    child: CustomPaint(
                                      painter: GlowingCirclePainter(_animationController.value),
                                    ),
                                  );
                                },
                              ),
                              // Transparent Container for interaction
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.09,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.56,
                        top: MediaQuery.of(context).size.height * 0.28, // Adjusted for relative positioning
                        child: Text(
                          'Damper Actuator', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.57,
                        top: MediaQuery.of(context).size.height * 0.42, // Adjusted for relative positioning
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            _showProduct2Details(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Circle Effect with Transparent Center
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    child: CustomPaint(
                                      painter: GlowingCirclePainter(_animationController.value),
                                    ),
                                  );
                                },
                              ),
                              // Transparent Container for interaction
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.09,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.545,
                        top: MediaQuery.of(context).size.height * 0.46, // Adjusted for relative positioning
                        child: Text(
                          'Damper Actuator', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.44,
                        top: MediaQuery.of(context).size.height * 0.22,
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct3Details(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Circle Effect with Transparent Center
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    child: CustomPaint(
                                      painter: GlowingCirclePainter(_animationController.value),
                                    ),
                                  );
                                },
                              ),
                              // Transparent Container for interaction
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.09,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.39,
                        top: MediaQuery.of(context).size.height * 0.26, // Adjusted for relative positioning
                        child: Text(
                          'Smoke Detector', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.44,
                        top: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width * 0.05, // Relative size
                        height: MediaQuery.of(context).size.height * 0.03, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct3Details(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Circle Effect with Transparent Center
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    child: CustomPaint(
                                      painter: GlowingCirclePainter(_animationController.value),
                                    ),
                                  );
                                },
                              ),
                              // Transparent Container for interaction
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height: MediaQuery.of(context).size.height * 0.09,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.39,
                        top: MediaQuery.of(context).size.height * 0.44, // Adjusted for relative positioning
                        child: Text(
                          'Smoke Detector', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
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
                    Column(
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/systems/fire_smoke/omni.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.48,
                                MediaQuery.of(context).size.height * 0.01,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.28, MediaQuery.of(context).size.height * 0.31),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct1Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(55, 50, 100, 100),
                              Offset(55, 185),
                              Offset(-40, 50),
                                  () => _showProduct1Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'OMNI',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/systems/fire_smoke/smoke_damper.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.48,
                                MediaQuery.of(context).size.height * 0.35,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.3, MediaQuery.of(context).size.height * -0.1),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct2Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(40, 125, 100, 100),
                              Offset(30, 60),
                              Offset(-40, 50),
                                  () => _showProduct2Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'DAMPER ACTUATOR',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/systems/fire_smoke/duct_smoke.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.25,
                                MediaQuery.of(context).size.height * 0.15,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.15, MediaQuery.of(context).size.height * 0.15),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct3Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(65, 50, 100, 100),
                              Offset(60, 170),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                          },
                        ),
                        Text(
                          '  SMOKE DETECTOR',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ],
          ),
          // Arrow indicator and Floating Action Button
          if (_arrowPosition != null)
            Stack(
              children: [
                if (_showArrow)
                  Positioned(
                    left: _arrowPosition!.dx,
                    top: _arrowPosition!.dy,
                    child: Icon(Icons.arrow_drop_up, size: 100, color: Colors.transparent),
                  ),
                if (_showFloatingButton)
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
        ],
      ),
    );
  }
}


class GlowingCirclePainter extends CustomPainter {
  final double progress;

  GlowingCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.withOpacity(progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 + progress * 5;

    final double glowRadius = size.width / 2 + (progress * 10);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      glowRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
