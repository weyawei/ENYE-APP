import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Import ModelViewer

class FiremanControlPage extends StatefulWidget {
  @override
  _FiremanControlPageState createState() => _FiremanControlPageState();
}

class _FiremanControlPageState extends State<FiremanControlPage> with TickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  Offset? _arrowPosition;
  Offset? _floatingButtonPosition;
  bool _showFloatingButton = false;
  bool _showArrow = false;

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duration of the glow cycle
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation forward and backward

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.yellowAccent.withOpacity(0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/ahu/omni.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              /*Image.asset(
                'assets/systems/fire_smoke/omni.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
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
                "\n Features \n\n• 40, 20 or 14 Point (UI/O) models with the ability to use any point  as an input or output, allowing greater flexibility. \n• UI/O update rates up to 500Hz (2ms). \n• Individual UI/O LEDs for status indication and fault diagnostics. \n• Ethernet, RS-485 and USB communications. \n• Battery backed Real Time Clock for memory 5 years. \n• Feature rich multi -platform Web-server. \n• Polarity independent AC or DC Power Supply. \n• User replaceable log data memory via MicroSD. \n• Reporting of controller and programmable point self -diagnostics. \n• Click and drag programming. \n• Easily accessible USB ports offer a fast localised configuration interface and access to logged data.",
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
      appBar: AppBar(title: Text("Fireman's Control Panel"),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
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
                        'assets/systems/fdas/firemans.png',
                        height: MediaQuery.of(context).size.height * 0.52, // Relative height
                        fit: BoxFit.fill,
                      ),
                      // GestureDetector for Product 1
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.16,
                        top: MediaQuery.of(context).size.height * 0.09, // Adjusted for relative positioning
                        width: MediaQuery.of(context).size.width * 0.15, // Relative size
                        height: MediaQuery.of(context).size.height * 0.09, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct1Details(context),
                            );*/
                            _showProduct1Details(context);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glowing Circle Effect with Transparent Center
                              AnimatedBuilder(
                                animation: _colorAnimation,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.3, // Width of the clickable area
                                    height: MediaQuery.of(context).size.height * 0.3, // Height of the clickable area
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Make the container a circle
                                      gradient: RadialGradient(
                                        colors: [
                                          _colorAnimation.value ?? Colors.transparent,
                                          Colors.transparent,
                                        ],
                                        stops: [0.5, 1],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _colorAnimation.value ?? Colors.transparent,
                                          blurRadius: 10,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.19,
                        top: MediaQuery.of(context).size.height * 0.18, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'OMNI Controller',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.03, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'OMNI Controller', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.03, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      // GestureDetector for Product 2

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
                            'assets/systems/fdas/omni.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: 80,
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.05,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.37),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct1Details(context),
                            );
                          /*  _zoomToProduct(
                              Rect.fromLTWH(55, 50, 100, 100),
                              Offset(55, 185),
                              Offset(-40, 50),
                                  () => _showProduct1Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'OMNI Controller',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
