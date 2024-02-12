import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ProjectsPage extends StatefulWidget {
  static const String routeName = '/projects';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProjectsPage()
    );
  }

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with TickerProviderStateMixin {
  String? selectedCategory;
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  List<projCategories> _projCategories = [];
  late List<Projects> _projects;
  List<Projects> _filteredProjects = [];

  bool _isLoadingCat = true;
  bool _isLoadingProj = true;

  final ScrollController _scrollController = ScrollController();
  bool isRightButtonVisible = true; // Track the visibility of the right arrow button
  bool isLeftButtonVisible = false; // Track the visibility of the left arrow button

  void initState() {
    super.initState();
    // Initially, show all products
    _projects = [];
    _getProjCategories();
    _getProjects();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  _getProjCategories(){
    projectSVC.getProjCategory().then((projCategories){
      setState(() {
        _projCategories = projCategories;
      });
      _isLoadingCat = false;
      print("Length ${projCategories.length}");
    });
  }

  _getProjects(){
    projectSVC.getProjects().then((Projects){
      setState(() {
        _projects = Projects;
      });
      _isLoadingProj = false;
      print("Length ${Projects.length}");
    });
  }
  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPageIndex < (_projCategories.length / 2).ceil() - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Function to scroll the GridView to the right
  void scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100.0, // Adjust the scroll distance as needed
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut,
    );
  }

  void scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100.0, // Adjust the scroll distance as needed
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut,
    );
  }


  // Listener for the scroll controller
  void _scrollListener() {
    // Check if the GridView is at the rightmost edge
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        // Hide the right arrow button when at the edge
        isRightButtonVisible = false;
      });
    } else {
      setState(() {
        // Show the right arrow button when not at the edge
        isRightButtonVisible = true;
      });
    }

    // Check if the GridView is at the leftmost edge
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      setState(() {
        // Hide the right arrow button when at the edge
        isLeftButtonVisible = false;
      });
    } else {
      setState(() {
        // Show the right arrow button when not at the edge
        isLeftButtonVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'Projects', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: _isLoadingProj || _isLoadingCat
        ? Center(child: SpinningContainer(controller: _controller),)
        : SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(12.0),
            child: Column(
              children: [

                //project categories
                /*Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width * 1,
                     child: Stack(
                     children: [
                       PageView(
                         controller: _pageController,
                         scrollDirection: Axis.horizontal,
                         children: List.generate(
                           (_projCategories.length ).ceil(),
                               (pageIndex) {
                             return GridView.builder(
                               padding: EdgeInsets.symmetric(horizontal: 55.0),
                               scrollDirection: Axis.horizontal,
                               shrinkWrap: true,
                               gridDelegate:
                               const SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount: 1,
                                 crossAxisSpacing: 12.0,
                                 mainAxisSpacing: 12.0,
                                 mainAxisExtent: 120,
                               ),
                               itemCount: _projCategories.length,
                               itemBuilder: (context, index) {
                                 int actualIndex = pageIndex * 2 + index;
                                 if (actualIndex >= _projCategories.length) {
                                   return SizedBox.shrink();
                                 }
                                 return TextButton(
                                   onPressed: () {
                                    setState(() {
                                    selectedCategory = _projCategories[index].category;
                                    filterProjects();
                                       // Perform your desired action here
                                     });
                                   },
                                   child: Column(
                                     children: [
                                       Image.network(
                                         "${API.projCategImage + _projCategories[actualIndex].images}",
                                         color: Colors.deepOrange.shade400,
                                         height: 55,
                                         width: 45,
                                         alignment: Alignment.center,
                                       ),
                                       Text(
                                         "${_projCategories[actualIndex].title}",
                                         style: TextStyle(
                                           fontSize: 11,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         textAlign: TextAlign.center,
                                         maxLines: 2,
                                       ),
                                     ],
                                   ),
                                 );
                               },
                             );
                           },
                         ),
                       onPageChanged: (index) {
                         setState(() {
                           _currentPageIndex = index;
                         });
                       },
                     ),
                  Positioned(
                    left: 5.0,
                    top: 20.0,
                    child: ClipOval(
                      child: Material(
                        color: Colors.red, // Set the background color of the icon
                        child: InkWell(
                          onTap: _goToPreviousPage,
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white, // Set the color of the icon
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5.0,
                    top: 20.0,
                    child: ClipOval(
                      child: Material(
                        color: Colors.red, // Set the background color of the icon
                        child: InkWell(
                          onTap: _goToNextPage,
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white, // Set the color of the icon
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                     ],
                     ),
                ),*/
                Container(
                  height: screenHeight * 0.15,
                  width: screenWidth * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //lefft arrow
                      isLeftButtonVisible
                      ? Container(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.07,
                        child: IconButton(
                          onPressed: scrollLeft,
                          icon: Image(image: AssetImage("assets/icons/left_arrow.png")),
                          iconSize: screenLayout ? (screenHeight + screenWidth) / 50 : (screenHeight + screenWidth) / 75,
                        ),
                      )
                      : SizedBox.shrink(),


                      //categories
                      Container(
                        height: screenHeight * 0.13,
                        width: screenWidth * 0.75,
                        child: GridView.builder(
                          controller: _scrollController, // Assign the ScrollController
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: (screenHeight + screenWidth) / 90,
                            mainAxisSpacing: (screenHeight + screenWidth) / 90,
                            mainAxisExtent: screenLayout ? screenWidth * 0.3 : screenWidth * 0.2,
                          ),
                          itemCount: _projCategories.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedCategory = _projCategories[index].category;
                                  filterProjects();
                                  // Perform your desired action here
                                });
                              },
                              child: Column(
                                children: [
                                  ImageIcon(
                                    NetworkImage("${API.projCategImage + _projCategories[index].images}"),
                                    size: (screenHeight + screenWidth) / 25,
                                    color: Colors.deepOrange.shade400,
                                  ),

                                  SizedBox(height: 5,),

                                  Text(
                                    "${_projCategories[index].title}",
                                    style: TextStyle(
                                      fontSize: fontSmallSize,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      //right button
                      isRightButtonVisible
                      ? Container(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.07,
                        child: IconButton(
                          onPressed: scrollRight,
                          icon: Image(image: AssetImage("assets/icons/right_arrow.png")),
                          iconSize: screenLayout ? (screenHeight + screenWidth) / 50 : (screenHeight + screenWidth) / 75,
                        ),
                      )
                      : SizedBox.shrink(),
                    ],
                  ),
                ),


                //project items
                _filteredProjects.isEmpty
                    ? GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenLayout ? 2 : 3,
                    crossAxisSpacing: (screenHeight + screenWidth) / 90,
                    mainAxisSpacing: (screenHeight + screenWidth) / 90,
                    mainAxisExtent: screenHeight * 0.3,
                  ),
                  itemCount: _projects.length,
                  itemBuilder: (context, index){

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => detailedProjPage(projects: _projects[index]),
                          ),
                        );
                        /*setState(() {
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: detailedProjPage.routeName, arguments: {'projects': _projects[index]}),
                            screen: detailedProjPage(projects: _projects[index]),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        });*/
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.orange[200],
                        ), //no function??nasasapawan ng pictures
                        child: Column(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                height: screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("${API.projectsImage + _projects[index].images}"),
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) {
                                      // Handle image loading error here
                                      print("Image loading failed: $exception");
                                    },
                                  ),
                                ),

                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.3)],
                                      stops: [0.0, 1],
                                      begin: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: screenWidth * 0.7,
                                      margin: EdgeInsets.only(top: 50.0),
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0)],
                                        ),
                                      ),
                                      child: Text(
                                        "${_projects[index].title}",
                                        style: TextStyle(fontSize: fontExtraSize, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                )
                    : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenLayout ? 2 : 3,
                    crossAxisSpacing: (screenHeight + screenWidth) / 90,
                    mainAxisSpacing: (screenHeight + screenWidth) / 90,
                    mainAxisExtent: screenHeight * 0.3,
                  ),
                  itemCount: _filteredProjects.length,
                  itemBuilder: (context, index){

                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: detailedProjPage.routeName, arguments: {'projects': _filteredProjects[index]}),
                            screen: detailedProjPage(projects: _filteredProjects[index]),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.orange[200],
                        ), //no function??nasasapawan ng pictures
                        child: Column(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                height: screenHeight * 0.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage("${API.projectsImage + _filteredProjects[index].images}"), fit: BoxFit.cover),
                                ),

                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.3)],
                                      stops: [0.0, 1],
                                      begin: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: screenWidth * 0.7,
                                      margin: EdgeInsets.only(top: 50.0),
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0)],
                                        ),
                                      ),
                                      child: Text(
                                        "${_filteredProjects[index].title}",
                                        style: TextStyle(fontSize: fontExtraSize, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterProjects() {
    if (selectedCategory == null) {
      _filteredProjects = _projects;
    } else {
      _filteredProjects =
          _projects.where((Projects) => Projects.category == selectedCategory).toList();
    }
  }
}