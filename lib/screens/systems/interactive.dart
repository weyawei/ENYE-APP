import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Import ModelViewer

class ProductZoomPage extends StatefulWidget {
  @override
  _ProductZoomPageState createState() => _ProductZoomPageState();
}

class _ProductZoomPageState extends State<ProductZoomPage> {
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
              Image.asset(
                'assets/systems/ahu/temp_sensor.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
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

  void _showProduct2Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(" Motorized Damper Actuator"),
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
                "\n Features \n\n• Adjustable angle of rotation \n• Selectable direction of rotation of reversing actuator \n• Manual Over-ride push button when required \n• Optional 2 adjustable SPDT auxiliary switches \n• Maintenance free",
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
              Image.asset(
                'assets/systems/ahu/co2.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
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
                "\n Features \n• Single beam dual wavelength NDIR sensor eliminates draft due to light source aging \n• Integral passive temperature outputs reduce number of devices mounted in the space \n• Service display tool available for models without an integral LED \n• Optional integral display and relay output ",
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
        title: Text(" Differential Pressure Transmitter"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/ahu/pressure.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
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
                "\n Features \n\n• Simple calibration push-button sets back zero and span, saving time installing and over the service life \n• Cost effective and compact device suitable for OEM applications where space, simplicity, and value are key \n• Ranges and accuracy selection cover a wide range of applications minimizing components and determining standardizing on design \n • Optional 1/8 NPT process connection to allow for use with metal barbed fittings or compression fittings for use with metal tubing \n• Plenum rated units meeting UL Standard 2043",
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
        title: Text(" Pressure Independent Balancing and Control Valve (PIBCV)"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/ahu/picv.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
              Text(
                "Veriflow Valve",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C)
                ),

              ),
              //   SizedBox(height: 10,),
              Text(
                "\n Features \n\n• Verification of flow and minimum differential pressure due to unique P/T plug design \n• The presetting function has no impact on the stroke; Full stroke modulation at all times, regardless the preset flow \n• The constant differential pressure across the modulating control component guarantees 100% authority \n• Automatic balancing eliminates overflows, regardless of fluctuating pressure conditions in the system \n• Compatible with thermic actuators On/Off or 0-10V, normally closed. Also compatible with motoric actuators 0-10V, (Linear or Logarithmic) or 3 point control \n• Differential pressure operating range up to 800 kPa \n• High flows with minimal required differential pressure due to advanced design of the valve \n• Small dimensions due to compact housing \n• Higher presetting precision due to stepless analogue scale \n• Rangeabililty > 100:1",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.036,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF2E3E5C)
                ),
              ),

              SizedBox(height: 20,),
              Image.asset(
                'assets/systems/ahu/logica.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
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
        title: Text(" Air Velocity Transmitter"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/ahu/air_velocity.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
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
                "\n Features \n\n• Minimal preventative maintenance as sensing element is covered with an engineered protective coating \n• Easy field setup via the on board dip switches for range and units \n• Display (Optional): 5 digit LCD ",
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
        title: Text(" Variable Frequency Drive (VFD)"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/ahu/vfd.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
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

  void _showProduct8Details(BuildContext context) {
    // Code to display 3D model for Product 2
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(" Networkable Stand-Alone Controller (NSAC)"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/systems/ahu/omni.png',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.fill,
              ),
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
                "\n Features \n\n• 40, 20 or 14 Point (UI/O) models with the ability to use any point as an input or output, allowing greater flexibility \n• UI/O update rates up to 500Hz (2ms) \n• Individual UI/O LEDs for status indication and fault diagnostics \n• Ethernet, RS-485 and USB communications \n• Battery backed Real Time Clock for memory 5 years. \n• Feature rich multi -platform Web-server \n• Polarity independent AC or DC Power Supply \n• User replaceable log data memory via MicroSD \n• Reporting of controller and programmable point self -diagnostics \n• Click and drag programming \n• Easily accessible USB ports offer a fast localised configuration interface and access to logged data. ",
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
                        'assets/systems/ahu/ahu_1.png',
                        height: MediaQuery.of(context).size.height * 0.4,
                        fit: BoxFit.fill,
                      ),
                      // GestureDetector for Product 1
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.28,
                        top: MediaQuery.of(context).size.width * 0.31,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // GestureDetector for Product 2
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.2,
                        top: MediaQuery.of(context).size.width * 0.5,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.13,
                        top: MediaQuery.of(context).size.width * 0.84,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.36,
                        top: MediaQuery.of(context).size.width * 0.3,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.3,
                        top: MediaQuery.of(context).size.width * 0.75,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.5,
                        top: MediaQuery.of(context).size.width * 0.8,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.57,
                        top: MediaQuery.of(context).size.width * 0.52,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.75,
                        top: MediaQuery.of(context).size.width * 0.40,
                        width: 30,
                        height: 30,
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
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.85,
                        top: MediaQuery.of(context).size.width * 0.40,
                        width: 30,
                        height: 30,
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
                        'assets/systems/ahu/temp_sensor.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(55, 50, 100, 100),
                          Offset(55, 185),
                          Offset(-40, 50),
                              () => _showProduct1Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/damper.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(40, 125, 100, 100),
                          Offset(30, 60),
                          Offset(-40, 50),
                              () => _showProduct2Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/co2.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(65, 50, 100, 100),
                          Offset(60, 170),
                          Offset(-40, 50),
                              () => _showProduct3Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/pressure.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(65, 200, 100, 100),
                          Offset(20, 10),
                          Offset(-40, 50),
                              () => _showProduct4Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/picv.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(135, 250, 100, 100),
                          Offset(-60, -90),
                          Offset(-40, 50),
                              () => _showProduct5Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/air_velocity.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(150, 135, 100, 100),
                          Offset(-90, 50),
                          Offset(-40, 50),
                              () => _showProduct6Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/vfd.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(220, 105, 100, 100),
                          Offset(-160, 50),
                          Offset(-40, 50),
                              () => _showProduct7Details(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/systems/ahu/omni.png',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      iconSize: 80,
                      onPressed: () {
                        _zoomToProduct(
                          Rect.fromLTWH(250, 105, 100, 100),
                          Offset(-180, 50),
                          Offset(-40, 50),
                              () => _showProduct8Details(context),
                        );
                      },
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
                    child: Icon(Icons.arrow_drop_up, size: 100, color: Colors.red),
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
