import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ProjectPage2 extends StatefulWidget {
  const ProjectPage2({super.key});

  @override
  State<ProjectPage2> createState() => _ProjectPage2State();
}

class _ProjectPage2State extends State<ProjectPage2> {
  late List<projCategories> _projCategory;
  late List<Projects> _projects;
  late List<Projects> _filteredProjects;
  late List<Projects> _projectsTop;

  bool _isLoading = true;
  bool _isLoadingTop = true;
  bool _isLoadingCategory = true;
  int _current = 0;

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
        _filteredProjects = Projects;
      });
      _isLoading = false;
    });
  }

  _getProjectCategory() {
    projectSVC.getProjCategory().then((projCategory) {
      setState(() {
        _projCategory = projCategory;
      });
      _isLoadingCategory = false;
    });
  }

  _getProjectsTop() {
    projectSVC.getProjects().then((ProjectsTop) {
      setState(() {
        _projectsTop = ProjectsTop.where((proj) => proj.proj_system == '1').toList();
      });
      _isLoadingTop = false;
  //    print("Length ${ProjectsTop.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    _projects = [];
    _filteredProjects = [];
    _getProjects();
    _projectsTop = [];
    _getProjectsTop();
    _projCategory = [];
    _getProjectCategory();
  }

  String selectedCategory = "Active";
  String selectedLabel = "All";

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

  void _filterSelectCategory(String query) {
    if (query == "Active") {
      setState(() {
        _filteredProjects = List.from(_projects);
      });
    } else {
      setState(() {
        _filteredProjects = _projects.where((projects) =>
        projects.category.toLowerCase() == query.toLowerCase()).toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return Scaffold(
      body: _isLoading || _isLoadingTop || _isLoadingCategory
      ? Center(child: CircularProgressIndicator(),)
      : RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            _getProjects();
            _getProjectsTop();
            _getProjectCategory();
          });
        },
        child: ListView(
          children: [
            Stack(
              clipBehavior: Clip.none, // Allow the carousel to overflow
              children: [
                // Background Image
                Container(
                  height: screenHeight * 0.53,
                  width: double.infinity,
                  child: _projectsTop.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: "${API.projectsImage + _projectsTop[_current].images}",
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(color: Colors.black),
                  )
                      : Container(color: Colors.black),
                ),
                // Carousel Overflowing Below Background Image
                Positioned(
                  top: screenHeight * 0.15,
                  left: 0,
                  right: -screenWidth * 0.55,
                  child: Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Image.asset(
                      'assets/icons/ec_project.png',
                      width: screenWidth * 0.04,
                      height: screenHeight * 0.05,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.225),
                  child: CarouselSlider.builder(
                    itemCount: _projectsTop.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          // Define what happens when an image is clicked
                          // Example: Navigate to a detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailedProjPage(projects: _projectsTop[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
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
                              child: CachedNetworkImage(
                                imageUrl: "${API.projectsImage + _projectsTop[index].images}",
                                fit: BoxFit.fill,
                                width: double.infinity,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 1.45,
                      viewportFraction: 0.7,
                      autoPlayInterval: Duration(seconds: 3),
                      enableInfiniteScroll: false,
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
            Padding(
              padding: EdgeInsets.all(fontNormalSize),
              child: Card(
                elevation: 5.0,
                color: Colors.white.withOpacity(0.7),
                child: Container(
                  margin: EdgeInsets.all(fontNormalSize * 0.5),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.01),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _projectsTop.isNotEmpty ? _projectsTop[_current].title : '',
                        style: TextStyle(
                          fontSize: fontXSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        _projectsTop.isNotEmpty ? _projectsTop[_current].description1 : '',
                        style: TextStyle(
                          fontSize: fontNormalSize,
                          letterSpacing: 0.8,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02,),
            Container(
              margin: EdgeInsets.only(left: screenWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontFamily: 'Rowdies',
                      fontStyle: FontStyle.italic,
                      fontSize: fontXSize * 1.65,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            // Arrow Categories
            SizedBox(height: screenHeight * 0.01,),
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
                      ..._projCategory.map((projCategory) {
                        return _projects
                          .where((project) => project.category == projCategory.category)
                          .length == 0
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: _buildCategoryIcon(projCategory.images, projCategory.title, projCategory.category),
                            );

                      }).toList(),
                      SizedBox(width: 10),
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.white, Colors.white.withOpacity(0.0)],
                          ),
                        ),
                        child: Icon(Icons.arrow_back_ios_sharp, color: Colors.black, size: fontExtraSize * 1.5,),
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.white, Colors.white.withOpacity(0.0)],
                          ),
                        ),
                        child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: fontExtraSize * 1.5,),
                      ),
                    ),
                  ),
              ],
              ),
            ),

            // Grid View projects
            Container(
              color: Colors.grey[100], // Light background color for the entire section
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with "See all" Button
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.01,
                        height: screenHeight * 0.02,
                        color: Colors.deepOrange,
                        margin: EdgeInsets.only(right: 8.0),
                      ),
                      Text(
                        selectedLabel,
                        style: TextStyle(
                          fontFamily: "Rowdies",
                          fontSize: fontXSize,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                  _filteredProjects.length == 0
                  ? SizedBox(
                    height: screenHeight * 0.5,
                    child: Center(
                      child: Text(
                        "No Available Data",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontExtraSize * 2,
                            color: Colors.grey.shade300,
                            letterSpacing: 1.2
                        ),
                      ),
                    ),
                  )
                  : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: fontExtraSize * 0.8, // Horizontal spacing
                      mainAxisSpacing: fontExtraSize * 0.8, // Vertical spacing
                      childAspectRatio: 1.00, // Aspect ratio of each grid item
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      var project = _filteredProjects[index];
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
                            borderRadius: BorderRadius.circular(16.0),
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
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            child: Stack(
                              children: [
                                // Image
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: "${API.projectsImage + project.images}",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.black, // Fallback color if image fails to load
                                    ),
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
                                  bottom: screenHeight * 0.015,
                                  left: screenWidth * 0.02,
                                  right: screenWidth * 0.02,
                                  child: Text(
                                    project.title,
                                    style: TextStyle(
                                      fontSize: fontNormalSize,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Helper Method to Build Category Icon
  Widget _buildCategoryIcon(String imagePath, String label, String category) {

    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          selectedLabel = label;
          _filterSelectCategory(category);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          label == "All"
          ? Image.asset(
              imagePath,
              width: fontExtraSize * 3,
              height: fontExtraSize * 3,
              color: selectedCategory == category ? Colors.deepOrange : Colors.black,
            )
          : CachedNetworkImage(
              imageUrl: API.projCategImage + imagePath,
              width: fontExtraSize * 3,
              height: fontExtraSize * 3,
              color: selectedCategory == category ? Colors.deepOrange : Colors.black,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black, // Fallback color if image fails to load
              ),
            ),

          SizedBox(height: 5.0),
          Container(
            width: screenWidth * 0.2,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selectedCategory == category ? Colors.deepOrange : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontNormalSize * 0.9,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ),
        ],
      ),
    );
  }
}
