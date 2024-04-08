import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

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

class _homePageState extends State<homePage>{
  final List<String> dashboard = [
    "${API.dashboard}BMS.png",
    "${API.dashboard}ems_ecbills.png",
    "${API.dashboard}prod1.png",
    "${API.dashboard}prod2.png",
    "${API.dashboard}sys1.png",
    "${API.dashboard}sys2.png",
  ];

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

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
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
                        image: DecorationImage(image: NetworkImage(dashboard[currentIndex]), fit: BoxFit.fill),
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
                                  image: DecorationImage(image: NetworkImage(dashboard[index]), fit: BoxFit.fill)
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
                          TextSpan(text: '  ENYE LTD. CORP.',
                            style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: " is actively involved in the project design conceptualization and supply of fully innovative and state-of-the-art HVAC products and control systems. Our strength basically lies on flexibility and adaptability which allow us to tailor-fit our systems to the end user's specific requirements supported by our highly trained after-sales-technical support engineers,",
                            style: TextStyle(fontSize: fontExtraSize, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: " We gained the reputation of being a total solution provider.",
                            style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                        ]
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),
                    videoPlayerView(
                      url: "https://enye.com.ph/enyecontrols_app/enye/corporate.mp4",
                      dataSourceType: DataSourceType.network
                    ),
                  ],
                ),
              ),

              //mission vission aims
              Container(
                margin: EdgeInsets.symmetric(vertical: screenWidth / 8),
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75,),
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
                    Lottie.network(
                      'https://lottie.host/68b583d9-5d17-4b1a-91fd-5ea004b4e059/vJsIqeClYC.json',
                      height: screenHeight / 10 ,
                      width: screenWidth / 5,
                    ),

                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        ImageIcon(
                          NetworkImage("${API.dashboard}market.png"),
                          color: Colors.deepOrange.shade700,
                          size: (screenHeight + screenWidth) / 10,
                        ),

                        Container(
                          width: screenWidth * 0.5,
                          child: RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO BE A MARKET LEADER',
                                style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' in all our business fields by continuing to "challenge our own success"',
                                style: TextStyle(fontSize: fontExtraSize, color: Colors.grey, letterSpacing: 0.8),),
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
                                style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' , we will be a complete solution to their business requirements by giving "the BEST products, technical support and after-sales services"',
                                style: TextStyle(fontSize: fontExtraSize, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        ),

                        ImageIcon(
                          NetworkImage("${API.dashboard}customer.png"),
                          color: Colors.deepOrange.shade700,
                          size: (screenHeight + screenWidth) / 10,
                        ),
                      ],
                    ),

                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          NetworkImage("${API.dashboard}business_partner.png"),
                          color: Colors.deepOrange.shade700,
                          size: (screenHeight + screenWidth) / 10,
                        ),

                        Container(
                          width: screenWidth * 0.6,
                          child: RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO OUR BUSINESS PARTNERS',
                                style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' , a mutual benefit relationship.',
                                style: TextStyle(fontSize: fontExtraSize, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40,),
              ContactsHome(),

              SizedBox(height: 60,),
              // follow us
              Lottie.network(
                  'https://lottie.host/b4271de5-63c3-47d2-b756-71bf41c8c643/ARaXZtHsJ8.json',
                  frameRate: FrameRate.max,
                  height: screenHeight * 0.2,
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
                      child: Image(image: AssetImage("assets/icons/twitter.png"), height: (screenHeight + screenWidth) / 25, width: (screenHeight + screenWidth) / 25,),
                      onTap: () async{
                        setState(() {
                          _launchURL("https://twitter.com/enyecontrols");
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

              SizedBox(height: 60,),
            ],
          ),
        ]
      ),

      /*floatingActionButton: SpeedDial(
        icon: Icons.share,
        backgroundColor: Colors.deepOrange,
        overlayColor: Colors.deepOrange,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
              child: Image(image: AssetImage("assets/icons/facebook-v2.png"),),
              onTap: () async{
                setState(() {
                  _launchURL("https://www.facebook.com/EnyeControl/");
                });
              }
          ),

          SpeedDialChild(
              child: Image(image: AssetImage("assets/icons/instagram.png"),),
              onTap: () async{
                setState(() {
                  _launchURL("https://www.instagram.com/enyecontrols/");
                });
              }
          ),

          SpeedDialChild(
              child: Image(image: AssetImage("assets/icons/twitter.png"),),
              onTap: () async{
                setState(() {
                  _launchURL("https://twitter.com/enyecontrols");
                });
              }
          ),

          SpeedDialChild(
              child: Image(image: AssetImage("assets/icons/youtube-round-2.png"),),
              onTap: () async{
                setState(() {
                  _launchURL("https://www.youtube.com/channel/UCTPwjwa1YioMkHZCvYjrAnw");
                });
              }
          ),

          SpeedDialChild(
              child: Image(image: AssetImage("assets/icons/linkedin.png"),),
              onTap: () async{
                setState(() {
                  _launchURL("https://www.linkedin.com/company/enyecontrols");
                });
              }
          ),
        ],
      ),*/
    );
  }
}
