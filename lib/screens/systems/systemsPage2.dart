import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class systemsPage2 extends StatefulWidget {
  const systemsPage2({super.key});

  @override
  State<systemsPage2> createState() => _systemsPage2State();
}

class _systemsPage2State extends State<systemsPage2> with TickerProviderStateMixin {
  double screenHeight = 0;
  double screenWidth = 0;

  final searchController = TextEditingController();
  late List<Systems> _systems;
  List<Systems> _filteredSystems = [];

  bool _isLoading = true;

  late CarouselController _carouselController;
  int _current = 0;

  @override
  void initState(){
    super.initState();
    _systems = [];
    _getSystems();

    _carouselController = CarouselController(); // Initialize the CarouselController
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  _getSystems(){
    systemService.getSystems().then((Systems){
      setState(() {
        _systems = Systems;
      });
      _isLoading = false;
      print("Length ${Systems.length}");
    });
  }

  void filterSystemsList() {
    _filteredSystems = _systems.where((Systems) {
      final title = Systems.title.toLowerCase();
      final searchQuery = searchController.text.toLowerCase();
      return title.contains(searchQuery);
    }).toList();
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return GestureDetector(
      // When tapped, dismiss the keyboard by unfocusing the TextField
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // appBar: CustomAppBar(title: 'Systems', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(child: SpinningContainer(controller: _controller),)
            : SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                _getSystems();
              });
            },
            child: SingleChildScrollView(
            /*  padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 50,
              ),*/
              child: Container(
                height: screenHeight * 0.9,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: "${API.systemsImg + _systems[_current].image}",
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      fit: BoxFit.fill,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                      ),
                    ),
                    Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.grey.shade50.withOpacity(1),
                                Colors.grey.shade50.withOpacity(1),
                                Colors.grey.shade50.withOpacity(1),
                                Colors.grey.shade50.withOpacity(1),
                                Colors.grey.shade50.withOpacity(0),
                                Colors.grey.shade50.withOpacity(0),
                                Colors.grey.shade50.withOpacity(0),
                                Colors.grey.shade50.withOpacity(0),

                              ],
                            )
                          ),
                        ),
                    ),
                    Positioned(
                      bottom: screenLayout ? -25 : -60,
                      height: screenHeight,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider.builder(
                        carouselController: _carouselController,
                      options: CarouselOptions(
                        height: screenHeight * 0.8,
                         aspectRatio:  16/9,
                        viewportFraction: 0.70,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason){
                          setState(() {
                            _current = index;
                          });
                        }
                      ),
                        itemCount: _systems.length,
                        itemBuilder: (context, index, realIndex) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the detailed view
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => detailedSysPage(systems: _systems[index]),
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: screenLayout ? screenHeight * 0.47 : screenHeight * 0.53,
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 30),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: "${API.systemsImg + _systems[index].image}",
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(child: Icon(Icons.error)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.white.withOpacity(0.5),
                                  child: Column(
                                    children: [
                                      Text(
                                        _systems[index].title,
                                        style: TextStyle(
                                          fontSize: fontExtraSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                Text(
                                  _isExpanded ? _systems[index].description : _systems[index].description.substring(0, 100) + "...",
                                  style: TextStyle(
                                    fontSize: fontNormalSize,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  child: Text(
                                    _isExpanded ? "See less" : "See more",
                                    style: TextStyle(
                                      fontSize: fontNormalSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                         }
                      ),
                    ),
                  ],
                ),
              ),

            ),
          ),
        ),
      ),
    );
  }
}


