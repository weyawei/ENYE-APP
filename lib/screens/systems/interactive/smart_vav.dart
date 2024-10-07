import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Import ModelViewer

class SmartVavPage extends StatefulWidget {
  @override
  _SmartVavPageState createState() => _SmartVavPageState();
}

class _SmartVavPageState extends State<SmartVavPage> with TickerProviderStateMixin {
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
        title: Text(
          "VAV Central Controller",
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
                'assets/systems/smart/omni.png',
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
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(" Variable Frequency Drive (VFD)"),
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
                'assets/systems/smart/vfd.png',
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
                "\n Features \n\n• Built-in RTC and PLC functions with ladder programming, timers, counters, comparators and speed. \n• Input and Output phase loss detection \n• High cost competitive and high efficiency \n• Efficient cooling system \n• Dual-core design \n• Excellent pump control \n• Fire override mode \n• Ultra low motor noise \n• Auto Energy Saving",
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
        title: Text("Airflow Switch",
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
                  src: 'assets/systems/smart/airflow.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              Text(
                "Airflow Switch",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Adjustment knob changes switching pressure easily with a pressure gage reducing components for application \n• Low cost device makes it an excellent solution in BAS and HVAC applications requiring duct control and monitoring \n• Relay contact allows simple integration with DDC or building systems",
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
                'assets/systems/smart/actuator.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
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
                "\n Features \n\n• Measurement of flow and minimum differential pressure due to valve design with 3 P/T plugs \n• The presetting function has no impact on the stroke; Full stroke modulation at all times, regardless the preset flow \n• Regulation characteristic remains unchanged regardless of preset flow \n• The constant differential pressure across the modulating control component guarantees 100% authority \n• Automatic balancing eliminates overflows, regardless of fluctuating pressure conditions in the system \n• Minimal required differential pressure due to advanced design of the valve \n• Higher presetting precision due to stepless analogue scale \n• Rangeability > 100:1",
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
        title: Text("Actuator"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.7,
                child: ModelViewer(
                  src: 'assets/systems/ahu/actuator.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              Text(
                "ACTUATOR",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• BACnet MS/TP for Building Automation system • 128 Binary value (BV), 128 Analog value (AV) • Compact with Actuator +Controller +Communication+ Flow • Actuator with Pluggable terminal & RJ11 connection • Selectable direction of rotation of reversing actuator • Adjustable angle of rotation (Mechanical) • Selectable direction of rotation by switch • Selectable baud rate • Maintenance Free.",
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

  void _showProduct6Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(" Temperature Sensor"),
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
              /*Image.asset(
                'assets/systems/smart/temp_sensor.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),*/
              Text(
                "Duct Temperature Sensor",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Easy to mount external tab housing and flange options for duct applications \n• 1/4 turn housing cover with chain to prevent dropping \n• Multiple conduit knockouts for easy installation positioning \n• 8´ plenum rated cable option \n• Terminal connector eliminates need for wire nuts",
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
                'assets/systems/smart/air_velocity.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),*/
              Text(
                "Air Velocity Transmitter",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n • Minimal preventative maintenance as sensing element is covered with an engineered protective coating \n• Easy field setup via the on board dip switches for range and units \n• Display (Optional): 5 digit LCD",
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
        title: Text("VAV Thermostat",
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
                  src: 'assets/systems/smart/thermostat.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
            /*  Image.asset(
                'assets/systems/smart/thermostat.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),*/
              Text(
                "VAV Thermostat",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• 16 bit (MCU) with memory \n• Compact with Sensing + Controller + Communication + Display \n• LCD with back light, Clear and detailed display of the operating data \n• Built in Temperature(T), Humidity(H), Carbon Dioxide (CO2), IAQ sensor \n• High-precision for IAQ sensor \n• Compact, quickly installation with Pluggable terminal and RJ11 connection",
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


  void _showProduct9Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Differential Pressure Transmitter",
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
                  src: 'assets/systems/smart/diff_sensor.glb',
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),
              /*Image.asset(
                'assets/systems/smart/pressure.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),*/
              Text(
                "Differential Pressure Transmitter",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n· Simple calibration push button sets back zero and span, saving time installing and over the service life \n· Cost effective and compact device suitable for OEM applications where space, simplicity, and value are key \n· Ranges and accuracy selection cover a wide range of applications minimizing components and determining standardizing on design \n· with metal barbed fittings or compression fittings for use with metal tubing \n· Plenum rated units meeting UL Standard 2043",
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
      appBar: AppBar(title: Text('Smart Variable Air Volume System'),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.005,0,MediaQuery.of(context).size.height * 0.005,0),
                        child: Image.asset(
                          'assets/systems/smart/smarts.png',
                          height: MediaQuery.of(context).size.height * 0.52,
                          fit: BoxFit.fill,
                        ),
                      ),
                      // GestureDetector for Product 1
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.35,
                        top: MediaQuery.of(context).size.height * 0.29,
                        width: MediaQuery.of(context).size.width * 0.06, // Relative size
                        height: MediaQuery.of(context).size.height * 0.04, // Relative size
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
                        left: MediaQuery.of(context).size.width * 0.37,
                        top: MediaQuery.of(context).size.height * 0.32, // Adjusted for relative positioning
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
                        left: MediaQuery.of(context).size.width * 0.27,
                        top: MediaQuery.of(context).size.height * 0.31,
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
                        left: MediaQuery.of(context).size.width * 0.29,
                        top: MediaQuery.of(context).size.height * 0.34, // Adjusted for relative positioning
                        child: Text(
                          'VFD', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.25,
                        top: MediaQuery.of(context).size.height * 0.42,
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
                        left: MediaQuery.of(context).size.width * 0.25,
                        top: MediaQuery.of(context).size.height * 0.45, // Adjusted for relative positioning
                        child: Text(
                          'Airflow Switch', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.22,
                        top: MediaQuery.of(context).size.height * 0.47,
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
                        left: MediaQuery.of(context).size.width * 0.22,
                        top: MediaQuery.of(context).size.height * 0.50, // Adjusted for relative positioning
                        child: Text(
                          'PIBCV', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.40,
                        top: MediaQuery.of(context).size.height * 0.365,
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
                        left: MediaQuery.of(context).size.width * 0.42,
                        top: MediaQuery.of(context).size.height * 0.37, // Adjusted for relative positioning
                        child: Text(
                          'Temperature Sensor', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.36,
                        top: MediaQuery.of(context).size.height * 0.37,
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
                        left: MediaQuery.of(context).size.width * 0.25,
                        top: MediaQuery.of(context).size.height * 0.37, // Adjusted for relative positioning
                        child: Text(
                          'Airflow Switch', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.37,
                        top: MediaQuery.of(context).size.height * 0.40,
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
                        left: MediaQuery.of(context).size.width * 0.29,
                        top: MediaQuery.of(context).size.height * 0.40, // Adjusted for relative positioning
                        child: Text(
                          'Air Velocity', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.41,
                        top: MediaQuery.of(context).size.height * 0.395,
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
                        left: MediaQuery.of(context).size.width * 0.44,
                        top: MediaQuery.of(context).size.height * 0.39, // Adjusted for relative positioning
                        child: Text(
                          'Airflow Switch', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.55,
                        top: MediaQuery.of(context).size.height * 0.10,
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
                        left: MediaQuery.of(context).size.width * 0.55,
                        top: MediaQuery.of(context).size.height * 0.14, // Adjusted for relative positioning
                        child: Text(
                          'Actuator', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.55,
                        top: MediaQuery.of(context).size.height * 0.26,
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
                        left: MediaQuery.of(context).size.width * 0.55,
                        top: MediaQuery.of(context).size.height * 0.30, // Adjusted for relative positioning
                        child: Text(
                          'Actuator', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.56,
                        top: MediaQuery.of(context).size.height * 0.17,
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
                        left: MediaQuery.of(context).size.width * 0.62,
                        top: MediaQuery.of(context).size.height * 0.18, // Adjusted for relative positioning
                        child: Text(
                          'Thermostat', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.56,
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
                        left: MediaQuery.of(context).size.width * 0.62,
                        top: MediaQuery.of(context).size.height * 0.35, // Adjusted for relative positioning
                        child: Text(
                          'Thermostat', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.82,
                        top: MediaQuery.of(context).size.height * 0.135,
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
                        top: MediaQuery.of(context).size.height * 0.15, // Adjusted for relative positioning
                        child: Text(
                          'Thermostat', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.82,
                        top: MediaQuery.of(context).size.height * 0.31,
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
                        top: MediaQuery.of(context).size.height * 0.32, // Adjusted for relative positioning
                        child: Text(
                          'Thermostat', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.94,
                        top: MediaQuery.of(context).size.height * 0.024,
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
                            _showProduct9Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.75,
                        top: MediaQuery.of(context).size.height * 0.035, // Adjusted for relative positioning
                        child: Text(
                          'Differential Pressure', // Replace with the actual product name or identifier
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust the font size accordingly
                            color: Colors.white, // Adjust the color if needed
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.94,
                        top: MediaQuery.of(context).size.height * 0.195,
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
                            _showProduct9Details(context);
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
                        left: MediaQuery.of(context).size.width * 0.75,
                        top: MediaQuery.of(context).size.height * 0.21, // Adjusted for relative positioning
                        child: Text(
                          'Differential Pressure', // Replace with the actual product name or identifier
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
                            'assets/systems/smart/omni.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.2,
                                MediaQuery.of(context).size.height * 0.2,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.height * 0.33),
                              Offset(MediaQuery.of(context).size.width * 0.15, MediaQuery.of(context).size.height * -0.15),
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
                            'assets/systems/smart/vfd.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.15,
                                MediaQuery.of(context).size.height * 0.22,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.height * 0.33),
                              Offset(MediaQuery.of(context).size.width * 0.03, MediaQuery.of(context).size.height * -0.17),
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
                            'assets/systems/smart/Airflow.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.12,
                                MediaQuery.of(context).size.height * 0.34,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * 0.19, MediaQuery.of(context).size.height * -0.1),
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
                          'AIRFLOW SWITCH',
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
                                MediaQuery.of(context).size.width * 0.12,
                                MediaQuery.of(context).size.height * 0.37,
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
                            'assets/systems/smart/temp_sensor.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.28,
                                MediaQuery.of(context).size.height * 0.3,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * -0.14),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct6Details(context),
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
                          'Temperature Sensor',
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
                            'assets/systems/smart/air_velocity.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.22,
                                MediaQuery.of(context).size.height * 0.3,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.13, MediaQuery.of(context).size.height * 0.01),
                              Offset(MediaQuery.of(context).size.width * 0.3, MediaQuery.of(context).size.height * 0.03),
                                  () => _showProduct7Details(context),
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
                          'AIR VELOCITY',
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
                            'assets/systems/smart/actuator.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.4,
                                MediaQuery.of(context).size.height * 0.04,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.15, MediaQuery.of(context).size.height * 0.28),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct4Details(context),
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
                          'Actuator',
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
                            'assets/systems/smart/thermostat.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.7,
                                MediaQuery.of(context).size.height * 0.07,
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
                          'Thermostat',
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
                            'assets/systems/smart/pressure.png',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          iconSize: MediaQuery.of(context).size.width * 0.2, // Relative size
                          onPressed: () {
                            _zoomToProduct(
                              Rect.fromLTWH(
                                MediaQuery.of(context).size.width * 0.75,
                                MediaQuery.of(context).size.height * 0.12,
                                MediaQuery.of(context).size.width * 0.1,
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              Offset(MediaQuery.of(context).size.width * -0.55, MediaQuery.of(context).size.height * 0.17),
                              Offset(MediaQuery.of(context).size.width * -0.01, MediaQuery.of(context).size.height * 0.07),
                                  () => _showProduct9Details(context),
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
                          'Differential Pressure',
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