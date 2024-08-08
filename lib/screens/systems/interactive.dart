import 'package:enye_app/screens/product/product_page.dart';
import 'package:enye_app/screens/product/productsvc.dart';
import 'package:enye_app/screens/products/model.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/global_controller.dart';
import '../../widget/global_data.dart';
import '../product/detailed_product_page2.dart';
import '../product/product.dart';

class InteractiveImage extends StatefulWidget {
 // final List<product> products;

 const InteractiveImage({super.key});
//  const InteractiveImage({required this.products});

  @override
  State<InteractiveImage> createState() => _InteractiveImageState();
}

class _InteractiveImageState extends State<InteractiveImage> with TickerProviderStateMixin {
  ValueNotifier<double> sheetSizeNotifier = ValueNotifier(0.28);
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

   late List<product> _products = [];
  _getProducts(){
    productService.getProducts().then((product) {
      setState(() {
        _products = product.where((element) => element.id == "1").toList();
      });
        print("Length ${product.length}");
      });
    }

  @override
  void initState() {
    _getProducts();
    _products = [];

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Interactive Image Example')),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Enable panning
          scaleEnabled: true, // Enable scaling
          minScale: 1.0, // Minimum scale factor
          maxScale: 4.0, // Maximum scale factor
          child: Stack(
            children: [
              Image.asset(
                'assets/backgrounds/ahu_1.png', // Your image asset
                height: 400, // Set desired height
                //  width: 300, // Set desired width
                fit: BoxFit.fill, // How the image should be inscribed into the space
              ),
              Positioned(
                top: 180, // Position from top
                left: 76, // Position from left
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Valves'),
                          content: Text('Details of Valves'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                        InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          // Update the global data
                          GlobalData.productId = '54';
                          navBarController.jumpToTab(2); // Navigate to the Products tab
                        /*setState(() {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(
                        name: ProductItemScreen.routeName),
                        screen: productsPage(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation
                            .cupertino,
                        );
                        });*/
                        },
                          child: Text("View Details"),
                        ),
                          ],
                        );
                      },
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 30, // Width of the clickable area
                        height: 30, // Height of the clickable area
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
                ),
              ),
              Positioned(
                top: 290, // Position from top
                left: 47, // Position from left
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Damper Actuator'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Positioned(
                                  top: 0, // Ensure correct positioning
                                  left: 0,
                                  right: 0,
                                  child: ValueListenableBuilder<double>(
                                    valueListenable: sheetSizeNotifier,
                                    builder: (context, sheetSize, child) {
                                      double modelViewerHeight = (1 - sheetSize) * 300;
                                      return Container(
                                        height: modelViewerHeight,
                                        child: ModelViewer(
                                          src: "assets/backgrounds/actuator.glb",
                                          // src: "assets/imges/MODEL FOR TUFF.glb",
                                          autoRotate: true,
                                        ),
                                      );
                                    },
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
                                  "\n - Modulating Control 5Nm ",
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
                              },
                              child: Text('Close'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => productsPage(),
                                  ),
                                );
                              },
                              child: Text('View Details'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 30, // Width of the clickable area
                        height: 30, // Height of the clickable area
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
                ),
              ),
              Positioned(
                top: 150, // Position from top
                left: 310, // Position from left
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Details of OMNI'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => productsPage(),
                                  ),
                                );
                              },
                              child: Text('View Details'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 30, // Width of the clickable area
                        height: 30, // Height of the clickable area
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
                ),
              ),
              Positioned(
                top: 150, // Position from top
                left: 270, // Position from left
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('VFD'),
                          content: Text('Details of VFD'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => productsPage(),
                                  ),
                                );
                              },
                              child: Text('View Details'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 30, // Width of the clickable area
                        height: 30, // Height of the clickable area
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
                ),
              ),
              // Add more Positioned widgets for other interactive parts as needed
            ],
          ),
        ),
      ),
    );
  }
}
