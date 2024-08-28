import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../projects/project_page2.dart';
import '../screens.dart';
import 'news.dart';

class homePage extends StatefulWidget {
  static const String routeName = '/home';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => homePage()
    );
  }

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> with TickerProviderStateMixin{
  // final List<String> dashboard = [
  //   "${API.dashboard}BMS.png",
  //   "${API.dashboard}ems_ecbills.png",
  //   "${API.dashboard}prod1.png",
  //   "${API.dashboard}prod2.png",
  //   "${API.dashboard}sys1.png",
  //   "${API.dashboard}sys2.png",
  // ];

  final List<String> dashboard = [
   /* "assets/backgrounds/ems_ecbills.png",
    "assets/backgrounds/BMS.png",
    "assets/backgrounds/prod1.png",
    "assets/backgrounds/prod2.png",
    "assets/backgrounds/sys1.png",
    "assets/backgrounds/sys2.png",*/

    "assets/backgrounds/EMS ECB.jpg",
    "assets/backgrounds/BMS.jpg",
    "assets/backgrounds/SYSTEM1.jpg",
    "assets/backgrounds/SYSTEM2.jpg",
  ];

  late List<Projects> _projectsTop;
  int _current = 0;

  final ScrollController _scrollController = ScrollController();
  List<String> _frames = [];
  int _currentFrame = 0;


  late AnimationController _handSwipeController;
  late AnimationController _upwardController;
  int _playCount = 0;
  bool _isHandSwipeVisible = true;

  int currentIndex = 0;
  bool type = false;

  PageController _pageController = new PageController();

  //late showing of text
  bool showAnim = false;

  var lottieController;

  void _launchURL (String url) async{
    try {
      bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }

  void _delaySome () {
    Future.delayed(Duration(milliseconds: 3000), () {
      setState((){
        showAnim = true;
      });
    });
  }

  _getProjectsTop() {
    projectSVC.getProjects().then((ProjectsTop) {
      setState(() {
        _projectsTop = ProjectsTop.where((proj) => proj.proj_system == '1').toList();
      });
      print("Length ${ProjectsTop.length}");
    });
  }

  void initState() {
    super.initState();
    // Initially, show all products
    _projects = [];
    _getProjects();

    _projectsTop = [];
    _getProjectsTop();

    _news = [];
    _getNews();

    _loadFrames();
    _scrollController.addListener(_onScroll);

    _handSwipeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _upwardController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _handSwipeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _playCount++;
        if (_playCount >= 4) {
          setState(() {
            _isHandSwipeVisible = false;
          });
        } else {
          _handSwipeController.forward(from: 0.0);
        }
      }
    });

    _handSwipeController.forward();
  }

  @override
  void dispose() {
    _handSwipeController.dispose();
    _upwardController.dispose();
    _projects = [];
    _projectsTop = [];
    super.dispose();
  }

  void _loadFrames() async {
   // List<Future<Uint8List>> frameFutures = [];
    for (int i = 1; i <= 69; i++) {
      final String path = 'assets/image/Layer ${i.toString().padLeft(1, '0')}.svg';
      _frames.add(path);
    }
    setState(() {});
  }

  Future<Uint8List> _loadFrame(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  void _onScroll() {
    setState(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double scrollFraction = _scrollController.offset / maxScroll;
      int totalFrames = _frames.length - 1;
      _currentFrame = (scrollFraction * totalFrames).round().clamp(0, totalFrames);
    });
  }

 /* void _loadFrames() async {
    for (int i = 1; i <= 10; i++) {
      final String path = 'assets/images/Motorized Fan Coil Valve_2_out${i.toString().padLeft(4, '0')}.jpg';
      final ByteData data = await rootBundle.load(path);
      final Uint8List bytes = data.buffer.asUint8List();
      _frames.add(bytes);
    }
    setState(() {});
  }

  void _onScroll() {
    setState(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double scrollFraction = _scrollController.offset / maxScroll;
      int totalFrames = _frames.length - 3;
      _currentFrame = (scrollFraction * totalFrames).round().clamp(0, totalFrames);
    });
  }
*/

 /* void _loadFrames() {
    for (int i = 1; i <= 10; i++) {
      _frames.add('assets/images/Motorized Fan Coil Valve_2_out${i.toString().padLeft(4, '0')}.jpg');
    }
  }

  void _onScroll() {
    setState(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double scrollFraction = _scrollController.offset / maxScroll;
      int totalFrames = _frames.length - 1;
      _currentFrame = (scrollFraction * totalFrames).round().clamp(0, totalFrames);
    });
  }*/

  bool _isLoadingProj = true;
  late List<Projects> _projects;
  _getProjects(){
    projectSVC.getProjects().then((Projects){
      setState(() {
        _projects = Projects;
      });
      _isLoadingProj = false;
      print("Length ${Projects.length}");
    });
  }

  late List<news> _news;
  _getNews(){
    productService.getProductNews().then((News){
      setState(() {
        _news = News;
      });
      _isLoadingProj = false;
      print("Length ${News.length}");
    });
  }


  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final double backgroundHeight = MediaQuery.of(context).size.width * 0.5;
    final double carouselHeight = MediaQuery.of(context).size.width * 0.7;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
    //  appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: ListView(
        children: [
          MasonryGridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            children: <Widget> [

              //first dashboard
              Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      height: screenHeight * 0.9,
                      key: ValueKey<int>(currentIndex),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(dashboard[currentIndex]), fit: BoxFit.fill),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.black.withOpacity(0.2),),
                      ),
                    ),
                  ),

                  Container(
                    height: screenHeight * 0.75,
                    margin: EdgeInsets.only(top: screenHeight * 0.05,),
                    child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (val){
                          setState(() {
                            currentIndex = val;
                          });
                        },
                        itemCount: dashboard.length,
                        itemBuilder: (context, int index) {
                          return FractionallySizedBox(
                            heightFactor: 0.9,
                            widthFactor: 0.85,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  image: DecorationImage(image: AssetImage(dashboard[index]), fit: BoxFit.fill)
                              )
                            ),
                          );
                        }
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      axisDirection: Axis.horizontal,
                      controller: _pageController,
                      count: dashboard.length,
                      effect: ExpandingDotsEffect(dotColor: Colors.orange.withAlpha(75), activeDotColor: Colors.deepOrange.withAlpha(75)),
                      onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.bounceOut,),
                    ),
                  )
                ],
              ),

              /*SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Stack(
                  children: [
                    if (_frames.isNotEmpty)
                      SvgPicture.asset(
                        _frames[_currentFrame],
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    if (_isHandSwipeVisible)
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.height * 0.4, // Set the width
                          height: MediaQuery.of(context).size.height * 0.5, // Set the height
                          child: Lottie.asset(
                            'assets/lottie/hand_swipe.json',
                            controller: _handSwipeController,
                            onLoaded: (composition) {
                              _handSwipeController.duration = composition.duration;
                            },
                          ),
                        ),
                      ),
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 10,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: SizedBox(
                          height: 50,
                          child: Lottie.asset(
                            'assets/lottie/upward2.json',
                            controller: _upwardController,
                            onLoaded: (composition) {
                              _upwardController.duration = composition.duration;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
*/

              //who are we
              Container(
                margin: EdgeInsets.symmetric(vertical: screenWidth / 7),
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75,),
                    Text(
                      "Who We Are",
                      style: TextStyle(
                        fontSize: fontXXXSize,
                        fontFamily: 'Rowdies',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.deepOrange.shade600
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text(
                      "CHECK OUR STORY",
                      style: TextStyle(
                        fontSize: fontExtraSize,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        text: TextSpan(children: <TextSpan>
                        [
                          TextSpan(text: '  Enyecontrols',
                            style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: " is a controls company which is actively involved in more than 90% of all major projects nationwide. Our wide range of clients includes commercial buildings, data centers, hotels, semiconductors, hospitals, and manufacturing plants, retail buildings, residential including fit-outs and retrofits.",
                            style: TextStyle(fontSize: fontNormalSize, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: " We are known for project design, conceptualization, supply, installation of controls systems and devices but most importantly preventive maintenance and after-sales technical support.",
                            style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ]
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),
                    videoPlayerView(
                      url: "https://enye.com.ph/enyecontrols_app/enye/corporate.mp4",
                      dataSourceType: DataSourceType.network
                    ),

                   /* Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Stack(
                        children: [
                          if (_frames.isNotEmpty)
                            SvgPicture.asset(
                              _frames[_currentFrame],
                              fit: BoxFit.fill,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          SingleChildScrollView(
                            controller: _scrollController,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 40,
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),

              //mission vission aims
              /*Container(
                margin: EdgeInsets.symmetric(vertical: screenWidth / 8),
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      "Our Mission & Vision",
                      style: TextStyle(
                          fontSize: fontXXSize,
                          fontFamily: 'Rowdies',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.deepOrange.shade600
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                    ),

                    SizedBox(height: 10,),
                    Text(
                      "OUR AIMS",
                      style: TextStyle(
                        fontSize: fontExtraSize,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Lottie.asset(
                      'assets/lottie/mission_vision.json',
                      height: screenHeight / 12 ,
                      width: screenWidth / 5,
                    ),

                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        ImageIcon(
                          AssetImage("assets/icons/market.png"),
                          color: Colors.deepOrange.shade700,
                          size: (screenHeight + screenWidth) / 12,
                        ),

                        Container(
                          width: screenWidth * 0.5,
                          child: RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO BE A MARKET LEADER',
                                style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' in all our business fields by continuing to "challenge our own success"',
                                style: TextStyle(fontSize: fontNormalSize, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            textAlign: TextAlign.right,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO OUR CUSTOMERS',
                                style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' , we will be a complete solution to their business requirements by giving "the BEST products, technical support and after-sales services"',
                                style: TextStyle(fontSize: fontNormalSize, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        ),

                        ImageIcon(
                          AssetImage("assets/icons/customer.png"),
                          color: Colors.deepOrange.shade700,
                          size: (screenHeight + screenWidth) / 12,
                        ),
                      ],
                    ),

                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage("assets/icons/business_partner.png"),
                          color: Colors.deepOrange.shade700,
                          size: (screenHeight + screenWidth) / 12,
                        ),

                        Container(
                          width: screenWidth * 0.6,
                          child: RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO OUR BUSINESS PARTNERS',
                                style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' , a mutual benefit relationship.',
                                style: TextStyle(fontSize: fontNormalSize, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),*/


            /*  SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    padding: EdgeInsets.all(16.0),
    child: Text(
    'Our Achievements',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    ),
    CarouselSlider(
    options: CarouselOptions(
    height: 200.0,
    enlargeCenterPage: true,
    autoPlay: true,
    ),
    items: [1, 2, 5].map((i) {
    return Builder(
    builder: (BuildContext context) {
    return Card(
    elevation: 5,
    child: SingleChildScrollView(
      child: Column(
      children: [
      Image.asset('assets/backgrounds/awards_bg$i.jpg', fit: BoxFit.cover),
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Award Title $i'),
      ),
      Text('Year $i'),
      ],
      ),
    ),
    );
    },
    );
    }).toList(),
    ),
    Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(
    'Detailed Recognition',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    ),
    ...[1, 2, 5].map((i) {
    return Card(
    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: ListTile(
    contentPadding: EdgeInsets.all(16.0),
    leading: Image.asset('assets/backgrounds/awards_bg$i.jpg', width: 50, height: 50),
    title: Text('Award Title $i'),
    subtitle: Text('Year $i\nDescription of the award'),
    ),
    );
    }).toList(),
    ],
    ),
    ),*/


        //      SizedBox(height: screenHeight * 0.125,),
              /*ContactsHome(),*/

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Projects",
                            style: TextStyle(
                              fontFamily: "Rowdies",
                              fontSize: MediaQuery.of(context).size.width * 0.065,
                              fontWeight: FontWeight.bold,
                              color: Colors.red, // Adjust the color as needed
                            ),
                          ),
                          Spacer(),
                          Text("See all"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProjectPage2()), // Replace YourNewPage with the page you want to navigate to
                              );
                            },
                            child: Icon(
                              Icons.arrow_circle_right_outlined,
                              size: MediaQuery.of(context).size.width * 0.08,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 1.175,
                        viewportFraction: 0.7,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: _projects.where((project) => project.proj_system == "1").map((project) =>
                          InkWell(
                            onTap: (){
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: detailedProjPage.routeName),
                                screen: detailedProjPage(projects: project),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.7, // Adjust width as needed
                                        height: MediaQuery.of(context).size.width * 0.7 * 1.3, // Adjust height as needed
                                        child: CachedNetworkImage(
                                          imageUrl: "${API.projectsImage + project.images}", // Main image URL
                                          fit: BoxFit.fill, // Adjust this to change how the image fits within the container
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: Colors.black,
                                            child: Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 40.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(200, 0, 0, 0),
                                            Color.fromARGB(0, 0, 0, 0),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                     /* child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                                        child: Text(
                                          project.title,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),*/
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ).toList(),
                    ),
                  ],
                ),
              ),


              SizedBox(height: screenHeight * 0.125,),

              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "News And Updates",
                      style: TextStyle(
                        fontFamily: "Rowdies",
                        fontSize: MediaQuery.of(context).size.width * 0.065,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: min(_news.length, 3),
                      itemBuilder: (context, index) {
                        final news = _news[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullArticleNews(newsletter: news, selectedIndex: index),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image at the top
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider("${API.projectsImage + news.news_image}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          child: CachedNetworkImage(
                                            imageUrl: "${API.projectsImage + news.news_image}",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.black,
                                              child: Center(
                                                child: Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Text below the image
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news.title,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      news.isExpanded
                                          ? Text(
                                        news.description,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.03,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 1,
                                          color: Colors.black,
                                        ),
                                      )
                                          : RichText(
                                        text: TextSpan(
                                          text: news.description.length > 100
                                              ? news.description.substring(0, 100)
                                              : news.description,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.03,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 1,
                                            color: Colors.black,
                                          ),
                                          children: news.description.length > 100
                                              ? [
                                            TextSpan(
                                              text: '... See More',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    news.isExpanded = true;
                                                  });
                                                },
                                            ),
                                          ]
                                              : [],
                                        ),
                                      ),
                                      if (news.description.length > 100 && news.isExpanded)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              news.isExpanded = !news.isExpanded;
                                            });
                                          },
                                          child: Text(
                                            news.isExpanded ? "See Less" : "",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width * 0.028,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
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
                      },
                    ),
                  ],
                ),
              ),


              SizedBox(height: 30,),
              // follow us
              Lottie.asset(
                  'assets/lottie/follow_us.json',
                  frameRate: FrameRate.max,
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.6,
                  controller: lottieController
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: Image(image: AssetImage("assets/icons/facebook-v2.png"), height: (screenHeight + screenWidth) / 25, width: (screenHeight + screenWidth) / 25,),
                      onTap: () async{
                        setState(() {
                          _launchURL("https://www.facebook.com/EnyeControl/");
                        });
                      }
                  ),

                  SizedBox(width: 18,),
                  GestureDetector(
                      child: Image(image: AssetImage("assets/icons/instagram.png"), height: (screenHeight + screenWidth) / 25, width: (screenHeight + screenWidth) / 25,),
                      onTap: () async{
                        setState(() {
                          _launchURL("https://www.instagram.com/enyecontrols/");
                        });
                      }
                  ),

                  SizedBox(width: 18,),
                  GestureDetector(
                      child: Image(image: AssetImage("assets/icons/twitter-new.png"), height: (screenHeight + screenWidth) / 25, width: (screenHeight + screenWidth) / 25,),
                      onTap: () async{
                        setState(() {
                          _launchURL("https://x.com/enyecontrols");
                        });
                      }
                  ),

                  SizedBox(width: 18,),
                  GestureDetector(
                      child: Image(image: AssetImage("assets/icons/youtube-round-2.png"), height: (screenHeight + screenWidth) / 25, width: (screenHeight + screenWidth) / 25,),
                      onTap: () async{
                        setState(() {
                          _launchURL("https://www.youtube.com/channel/UCTPwjwa1YioMkHZCvYjrAnw");
                        });
                      }
                  ),

                  SizedBox(width: 18,),
                  GestureDetector(
                      child: Image(image: AssetImage("assets/icons/linkedin.png"), height: (screenHeight + screenWidth) / 25, width: (screenHeight + screenWidth) / 25,),
                      onTap: () async{
                        setState(() {
                          _launchURL("https://www.linkedin.com/company/enyecontrols");
                        });
                      }
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05,),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactsHome()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
                  height: screenHeight * 0.07,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.deepOrange),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        size: fontExtraSize * 1.3,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: fontExtraSize,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 60,),
            ],
          ),
        ]
      ),
    );
  }
}
