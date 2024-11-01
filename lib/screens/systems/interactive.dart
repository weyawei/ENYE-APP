import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Import ModelViewer

class ProductZoomPage extends StatefulWidget {
  late final String imageUrl;

  ProductZoomPage({required this.imageUrl});

  @override
  _ProductZoomPageState createState() => _ProductZoomPageState();
}

class _ProductZoomPageState extends State<ProductZoomPage> with TickerProviderStateMixin {
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
    _controller.dispose();
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
    // Code to display image or other details for Product 1
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("DUCT TEMPERATURE SENSOR",
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/chiller/temp_sensor.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
             /* Image.asset(
                'assets/systems/ahu/temp_sensor.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "DUCT TEMPERATURE SENSOR",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Easy to mount external tab housing and flange options for duct applications. \n• 1/4 turn housing cover with chain to prevent dropping. \n• Multiple conduit knockouts for easy installation positioning. \n• 8´ plenum rated cable option. \n• Terminal connector eliminates need for wire nuts.",
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

  void _showProduct2Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Motorized Damper Actuator"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/ahu/damper_actuator.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              Text(
                "ECCM SERIES STANDARD DAMPER ACTUATOR",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Adjustable angle of rotation. \n• Selectable direction of rotation of reversing actuator. \n• Manual Over-ride push button when required. \n• Optional 2 adjustable SPDT auxiliary switches. \n• Manual over-ride push-button when required.",
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

  void _showProduct3Details(BuildContext context) {
    // Code to display image or other details for Product 1
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("DUCT CARBON DIOXIDE TRANSMITTER",
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/ahu/c02.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              /*Image.asset(
                'assets/systems/ahu/co.jpg',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "DUCT CARBON DIOXIDE TRANSMITTER",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Single beam dual wavelength NDIR sensor eliminates draft due to light source aging. \n• Integral passive temperature outputs reduce number of devices mounted in the space. \n• Service display tool available for models without an integral LED. \n• Optional integral display and relay output. ",
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

  void _showProduct4Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Differential Pressure Transmitter"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/smart/diff_sensor.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              /*Image.asset(
                'assets/systems/ahu/pressure.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "Differential Pressure Transmitter",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Simple calibration push-button sets back zero and span, saving time installing and over the service life. \n• Cost effective and compact device suitable for OEM applications where space, simplicity, and value are key. \n• Ranges and accuracy selection cover a wide range of applications minimizing components and determining standardizing on design. \n • Optional 1/8 NPT process connection to allow for use with metal barbed fittings or compression fittings for use with metal tubing. \n• Plenum rated units meeting UL Standard 2043.",
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

  void _showProduct5Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pressure Independent Balancing and Control Valve (PIBCV)"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/chiller/pibcv.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
             /* Image.asset(
                'assets/systems/ahu/picv.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "Pressure Independent Balancing and Control Valve (PIBCV)",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Measurement of flow and minimum differential pressure due to valve design with 3 P/T plugs. \n• The presetting function has no impact on the stroke; Full stroke modulation at all times, regardless the preset flow. \n• Regulation characteristic remains unchanged regardless of preset flow. \n• The constant differential pressure across the modulating control component guarantees 100% authority. \n• Automatic balancing eliminates overflows, regardless of fluctuating pressure conditions in the system. \n• Minimal required differential pressure due to advanced design of the valve. \n• Higher presetting precision due to stepless analogue scale. \n• Rangeability > 100:1.",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.036,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF2E3E5C)
                ),
              ),

             /* SizedBox(height: 20,),
              Image.asset(
                'assets/systems/ahu/logica.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
              Text(
                "Logica Actuator",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Thermal Power indication (when combined with 2temperature sensors) \n• Flow indication \n• Thermal Energy consumption indication \n• Energy Management functionality \n• Control of minimum delta-T \n• Auto calibration to all valve strokes \n• Position indicator for stem travel \n• Short-circuit and reverse polarity protection \n• Programmable scheduled valve flushing and exercising \n• Selectable control modes: \n   • Analogue 0-10 V \n   • External BMS setpoint \n   • Return temperature \n   • Thermal power \n   • Room temperature",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.036,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF2E3E5C)
                ),
              ),*/
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

  void _showProduct6Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Air Velocity Transmitter"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/smart/air_velocity.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              /*Image.asset(
                'assets/systems/ahu/air_velocity.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "AIR VELOCITY TRANSMITTER",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Sensing elements have been coated with an engineered conformal coating to ensure durability and longevity. \n• Field selectable ranges can be quickly configured without power to the unit.",
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

  void _showProduct7Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Variable Frequency Drive (VFD)"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/chiller/vfd.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
             /* Image.asset(
                'assets/systems/ahu/vfd.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "Variable Frequency Drive (VFD)",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Built-in RTC and PLC functions with ladder programming, timers, counters, comparators and speed. \n• Input and Output phase loss detection. \n• High cost competitive and high efficiency. \n• Efficient cooling system. \n• Dual-core design. \n• Excellent pump control. \n• Fire override mode. \n• Ultra low motor noise. \n• Auto Energy Saving.",
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

  void _showProduct8Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Networkable Stand-Alone Controller (NSAC)"),
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
             /* Image.asset(
                'assets/systems/ahu/omni.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),*/
              Text(
                "Networkable Stand-Alone Controller (NSAC)",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• 40, 20 or 14 Point (UI/O) models with the ability to use any point as an input or output, allowing greater flexibility. \n• UI/O update rates up to 500Hz (2ms). \n• Individual UI/O LEDs for status indication and fault diagnostics. \n• Ethernet, RS-485 and USB communications. \n• Battery backed Real Time Clock for memory 5 years. \n• Feature rich multi -platform Web-server. \n• Polarity independent AC or DC Power Supply. \n• User replaceable log data memory via MicroSD. \n• Reporting of controller and programmable point self -diagnostics. \n• Click and drag programming. \n• Easily accessible USB ports offer a fast localised configuration interface and access to logged data. ",
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
      appBar: AppBar(title: Text('AHU Control and Monitoring System'),
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
                        'assets/systems/ahu/ahu_1s.png',
                        height: MediaQuery.of(context).size.height * 0.52,
                        fit: BoxFit.fill,
                      ),
                      // GestureDetector for Product 1
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.32,
                        top: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.width * 0.03, // Relative size
                        height: MediaQuery.of(context).size.height * 0.02, // Relative size
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
                        left: MediaQuery.of(context).size.width * 0.26,
                        top: MediaQuery.of(context).size.height * 0.18, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'Temperature Sensor',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 0.8 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'Temperature Sensor', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      // GestureDetector for Product 2
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.22,
                        top: MediaQuery.of(context).size.height * 0.23,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
                        child: GestureDetector(
                          onTap: () {
                          /*  _zoomToProduct(
                              Rect.fromLTWH(40, 110, 100, 100),
                              Offset(-30, -40),
                              Offset(-40, 50),
                                  () => _showProduct2Details(context),
                            );*/
                            _showProduct2Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.22,
                        top: MediaQuery.of(context).size.height * 0.26, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'Damper Actuator',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'Damper Actuator', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.14,
                        top: MediaQuery.of(context).size.height * 0.38,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
                        child: GestureDetector(
                          onTap: () {
                           /* _zoomToProduct(
                              Rect.fromLTWH(40, 110, 100, 100),
                              Offset(-30, -40),
                              Offset(-40, 50),
                                  () => _showProduct2Details(context),
                            );*/
                            _showProduct2Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.14,
                        top: MediaQuery.of(context).size.height * 0.41, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'Damper Actuator',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'Damper Actuator', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.36,
                        top: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.03, // Relative size
                        height: MediaQuery.of(context).size.height * 0.02, // Relative size
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
                        left: MediaQuery.of(context).size.width * 0.38,
                        top: MediaQuery.of(context).size.height * 0.17, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'Duct CO2 Transmitter',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'Duct CO2 Transmitter', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.305,
                        top: MediaQuery.of(context).size.height * 0.34,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct4Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.31,
                        top: MediaQuery.of(context).size.height * 0.38, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'Differential Pressure Transmitter',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'Differential Pressure Transmitter', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.51,
                        top: MediaQuery.of(context).size.height * 0.38,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct5Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.51,
                        top: MediaQuery.of(context).size.height * 0.415, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'PIBCV',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'PIBCV', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.57,
                        top: MediaQuery.of(context).size.height * 0.26,
                        width: MediaQuery.of(context).size.width * 0.03, // Relative size
                        height: MediaQuery.of(context).size.height * 0.02, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct6Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.57,
                        top: MediaQuery.of(context).size.height * 0.28, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'Air Velocity Transmitter',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'Air Velocity Transmitter', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.76,
                        top: MediaQuery.of(context).size.height * 0.19,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct7Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.76,
                        top: MediaQuery.of(context).size.height * 0.23, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'VFD',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'VFD', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.86,
                        top: MediaQuery.of(context).size.height * 0.19,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
                        child: GestureDetector(
                          onTap: () {
                            /* _zoomToProduct(
                              Rect.fromLTWH(55, 70, 100, 100),
                              Offset(-30, -30),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                            _showProduct8Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.86,
                        top: MediaQuery.of(context).size.height * 0.23, // Adjusted for relative positioning
                        child: Stack(
                          children: [
                            Text(
                              'OMNI Controller',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1 // Outline thickness
                                  ..color = Colors.deepOrange,  // Outline color
                              ),
                            ),
                            Text(
                              'OMNI Controller', // Replace with the actual product name or identifier
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                                color: Colors.white, // Adjust the color if needed
                              ),
                            ),
                          ],
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
                            'assets/systems/ahu/temp_sensor.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.2,
                                MediaQuery.of(context).size.height * 0.055,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.33),
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
                          'TEMPERATURE SENSOR',
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
                            'assets/systems/ahu/damper.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.15,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.15),
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
                            'assets/systems/ahu/co2.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.2,
                                MediaQuery.of(context).size.height * 0.05,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.14, MediaQuery.of(context).size.height * 0.32),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct3Details(context),
                            );
                            /*_zoomToProduct(
                              Rect.fromLTWH(65, 50, 100, 100),
                              Offset(60, 170),
                              Offset(-40, 50),
                                  () => _showProduct3Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'DUCT CO2 TRANSMITTER',
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
                            'assets/systems/ahu/pressure.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.16,
                                MediaQuery.of(context).size.height * 0.28,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.19, MediaQuery.of(context).size.height * -0.05),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct4Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(65, 200, 100, 100),
                              Offset(20, 10),
                              Offset(-40, 50),
                                  () => _showProduct4Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'DIFFERENTIAL PRESSURE TRANSMITTER',
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
                            'assets/systems/chiller/PIBCV.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.36,
                                MediaQuery.of(context).size.height * 0.3,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.06, MediaQuery.of(context).size.height * -0.03),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct5Details(context),
                            );
                          /*  _zoomToProduct(
                              Rect.fromLTWH(135, 250, 100, 100),
                              Offset(-60, -90),
                              Offset(-40, 50),
                                  () => _showProduct5Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'PIBCV',
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
                            'assets/systems/ahu/air_velocity.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.4,
                                MediaQuery.of(context).size.height * 0.16,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.13, MediaQuery.of(context).size.height * 0.17),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct6Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(150, 135, 100, 100),
                              Offset(-90, 50),
                              Offset(-40, 50),
                                  () => _showProduct6Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'AIR VELOCITY TRANSMITTER',
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
                            'assets/systems/ahu/vfd.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.6,
                                MediaQuery.of(context).size.height * 0.12,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.38, MediaQuery.of(context).size.height * 0.19),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct7Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(220, 105, 100, 100),
                              Offset(-160, 50),
                              Offset(-40, 50),
                                  () => _showProduct7Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'VFD',
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
                            'assets/systems/ahu/omni.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.7,
                                MediaQuery.of(context).size.height * 0.12,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.48, MediaQuery.of(context).size.height * 0.19),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct8Details(context),
                            );
                           /* _zoomToProduct(
                              Rect.fromLTWH(250, 105, 100, 100),
                              Offset(-180, 50),
                              Offset(-40, 50),
                                  () => _showProduct8Details(context),
                            );*/
                          },
                        ),
                        Text(
                          'OMNI CONTROLLER',
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
