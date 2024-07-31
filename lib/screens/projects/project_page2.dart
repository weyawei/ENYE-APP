import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:enye_app/screens/projects/projectsvc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
import 'detailed_projects.dart';
import 'list_projects.dart';

class ProjectPage2 extends StatefulWidget {
  const ProjectPage2({super.key});

  @override
  State<ProjectPage2> createState() => _ProjectPage2State();
}

class _ProjectPage2State extends State<ProjectPage2> {
  late List<Projects> _projects;
  final CarouselController _carouselController = CarouselController();
  int _current = 0;
  int _currentIndex = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getProjects() {
    projectSVC.getProjects().then((Projects) {
      setState(() {
        _projects = Projects;
      });
      print("Length ${Projects.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    _projects = [];
    _getProjects();
  }

  String selectedCategory = "Active";

  final List<Map<String, String>> categories = [
    {"name": "All", "icon": "assets/icons/proj_condo.png"},
    {"name": "Malls", "icon": "assets/icons/proj_mall.png"},
    {"name": "Resorts", "icon": "assets/icons/proj_resort.png"},
    {"name": "Schools", "icon": "assets/icons/proj_school.png"},
    {"name": "Buildings", "icon": "assets/icons/proj_buildings.png"},
  ];


  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Adjust the value as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Adjust the value as needed
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  @override
  Widget build(BuildContext context) {
    final double backgroundHeight = MediaQuery.of(context).size.width * 0.5;
    final double carouselHeight = MediaQuery.of(context).size.width * 0.7;

    // Filter projects based on the selected category
    List<Projects> filteredProjects = selectedCategory == "All"
        ? _projects
        : _projects.where((project) => project.proj_system == getCategoryCode(selectedCategory)).toList();


    return Scaffold(
     /* appBar: AppBar(
        title: Text('Movie Carousel'),
      ),*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none, // Allow the carousel to overflow
              children: [
                // Background Image
                Container(
                  height: backgroundHeight * 1.6,
                  width: double.infinity,
                  child: _projects.isNotEmpty
                      ? Image.network(
                    "${API.projectsImage + _projects[_current].images}",
                    fit: BoxFit.cover,
                  )
                      : Container(color: Colors.black), // Fallback color while loading
                ),
                // Carousel Overflowing Below Background Image
                Positioned(
                  top: 20.0, // Adjust this value to place the text as needed
                  left: 16.0,
                  right: 16.0,
                  child: Container(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Stack(
                      children: <Widget>[
                        // Border Text
                        Text(
                          ' Projects',
                          style: TextStyle(
                          //  fontFamily: "Rowdies",
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black.withOpacity(0.5),
                          ),
                        ),
                        // Solid Text
                        Text(
                          ' Projects',
                          style: TextStyle(
                          //  fontFamily: "Rowdies",
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: backgroundHeight * 0.6), // Position carousel below the background
                  height: carouselHeight,
                  child: CarouselSlider.builder(
                    itemCount: _projects.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(4.0),
                            child: Image.network(
                              "${API.projectsImage + _projects[index].images}",
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 1.6,
                      viewportFraction: 0.7,
                      autoPlayInterval: Duration(seconds: 3),
                      enableInfiniteScroll: false,  // Disable looping
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Fixed Details Section
            Card(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _projects.isNotEmpty ? _projects[_current].title : '',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _projects.isNotEmpty ? _projects[_current].description1 : '',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontFamily: 'Rowdies',
                      fontStyle: FontStyle.italic,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Stack(
                children: [
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
                    children: [
                      SizedBox(width: 20),
                      _buildCategoryIcon('assets/icons/select-all.png', "All", "Active"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_mall.png', "Malls", "8"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_airport.png', "Industries", "7"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_resort.png', "Resorts", "6"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_condo.png', "Condominium", "5"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_hospital.png', "Hospitals", "4"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_buildings.png', "Buildings", "3"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_school.png', "Schools", "2"),
                      SizedBox(width: 10),
                      _buildCategoryIcon('assets/icons/proj_condo.png', "BMS", "1"),
                      // Add more icons as needed
                    ],
                  ),
                ),
                  //arrow left
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _scrollLeft, // Scroll left on tap
                      child: Container(
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.white, Colors.white.withOpacity(0.0)],
                          ),
                        ),
                        child: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
                      ),
                    ),
                  ),
                  // Right arrow
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _scrollRight, // Scroll right on tap
                      child: Container(
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.white, Colors.white.withOpacity(0.0)],
                          ),
                        ),
                        child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      ),
                    ),
                  ),
              ],
              ),
            ),


            if(selectedCategory == "Active")
              Container(
                color: Colors.grey[100], // Light background color for the entire section
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with "See all" Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4.0,
                                height: 20.0,
                                color: Colors.deepOrange,
                                margin: EdgeInsets.only(right: 8.0),
                              ),
                              Text(
                                "All",
                                style: TextStyle(
                                  fontFamily: "Rowdies",
                                  fontSize: MediaQuery.of(context).size.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  //  SizedBox(height: 10.0),
                    // Constrained Grid View
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5, // Set a fixed height or use a fraction
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 8.0, // Horizontal spacing
                          mainAxisSpacing: 8.0, // Vertical spacing
                          childAspectRatio: 1.0, // Aspect ratio of each grid item
                        ),
                        itemCount: _projects
                            .where((project) => project.status == "Active")
                            .length,
                        itemBuilder: (context, index) {
                          var project = _projects
                              .where((project) => project.status == "Active")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),



            if(selectedCategory == "1")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Building Management\nSystems",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "1")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "1")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            if(selectedCategory == "2")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Schools and\nLearning Centers",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "2")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "2")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            if(selectedCategory == "3")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Buildings",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "3")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "3")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),



            if(selectedCategory == "4")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Hospitals",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "4")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "4")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            if(selectedCategory == "5")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Condominium",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "5")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "5")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if(selectedCategory == "6")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Hotel and Resort",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "6")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "6")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if(selectedCategory == "7")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Industries",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: _projects
                            .where((project) => project.proj_system == "7")
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == "7")
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          //  if(selectedCategory == "8")
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 24.0,
                              color: Colors.deepOrange,
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Text(
                              "Malls ",
                              style: TextStyle(
                                fontFamily: "Rowdies",
                                fontSize: MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage2()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Carousel with Gradient Overlay
                  Stack(
                    children: [
                      // Background for gradient and shadow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[100]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 5.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount:  _projects
                            .where((project) => project.proj_system == selectedCategory)
                            .length,
                        itemBuilder: (context, index, realIndex) {
                          var project = _projects
                              .where((project) => project.proj_system == selectedCategory)
                              .toList()[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Stack(
                                  children: [
                                    // Image
                                    Positioned.fill(
                                      child: Image.network(
                                        "${API.projectsImage + project.images}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Gradient overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Text Overlay
                                    Positioned(
                                      bottom: 10.0,
                                      left: 10.0,
                                      right: 10.0,
                                      child: Text(
                                        project.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: 0.6,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index1, reason) {
                            setState(() {
                              _currentIndex = index1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            // Additional Content Below
           /* Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'List of Projects',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // Helper method to map category names to project system codes
  String getCategoryCode(String category) {
    switch (category) {
      case "Malls":
        return "8";
      case "Resorts":
        return "6";
      case "Schools":
        return "2";
      case "Buildings":
        return "3";
      default:
        return "All";
    }
  }


  // Helper Method to Build Category Icon
  Widget _buildCategoryIcon(String imagePath, String label, String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: MediaQuery.of(context).size.width * 0.15, // Set the desired width and height
            height: MediaQuery.of(context).size.width * 0.12,
            color: selectedCategory == category ? Colors.deepOrange : Colors.black,
          ),
          SizedBox(height: 8.0),
          Container(
            width: 60,
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: selectedCategory == category ? Colors.deepOrange : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.028,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
