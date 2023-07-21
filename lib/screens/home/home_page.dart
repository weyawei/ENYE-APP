
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../config/api_connection.dart';
import '../../widget/widgets.dart';

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
    "${API.dashboard}2.png",
    "${API.dashboard}1.png",
    "${API.dashboard}3.png",
  ];

  final List<String> dashboardText1 = [
    '"Committed to be your',
    '"Challenging Innovation"',
    '"We Hand Over',
  ];

  final List<String> dashboardText2 = [
    'Business Partner of Choice!!"',
    "campaign is our aggressive move in setting the standard in Energy Saving by providing the approppriate products & solutions that will solve current HVAC problems and enhance efficiency.",
    'Best After Sales Services"',
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

    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png',),
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
                      height: MediaQuery.of(context).size.height,
                      key: ValueKey<int>(currentIndex),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(dashboard[currentIndex]), fit: BoxFit.fill),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(color: Colors.black.withOpacity(0.2),),
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
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
                            heightFactor: 0.8,
                            widthFactor: 0.9,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    image: DecorationImage(image: NetworkImage(dashboard[index]), fit: BoxFit.fill)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: DefaultTextStyle(
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontFamily: 'Rowdies',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                        child: AnimatedTextKit(
                                          isRepeatingAnimation: false,
                                          repeatForever: false,
                                          onFinished: (){
                                            setState(() {
                                              type = true;
                                            });
                                          },
                                          animatedTexts: [ TyperAnimatedText(dashboardText1[index], curve: Curves.easeIn, speed: Duration(milliseconds: 150)), ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10,),
                                    type ? Container(
                                      padding: EdgeInsets.only(left: 40),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: DefaultTextStyle(
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                        child: AnimatedTextKit(
                                          onFinished: (){
                                              type = false;
                                          },
                                          isRepeatingAnimation: false,
                                          repeatForever: false,
                                          animatedTexts: [ TyperAnimatedText(dashboardText2[index], curve: Curves.easeIn, speed: Duration(milliseconds: 70)), ],
                                        ),
                                      ),
                                    ) : Text("")
                                  ],)
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
                margin: EdgeInsets.symmetric(vertical: 50),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75,),
                    Text(
                      "Who We Are",
                      style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: 'Rowdies',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.deepOrange.shade600
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text(
                      "CHECK OUR STORY",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),

                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        text: TextSpan(children: <TextSpan>
                        [
                          TextSpan(text: '  ENYE LTD. CORP.',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: " is actively involved in the project design conceptualization and supply of fully innovative and state-of-the-art HVAC products and control systems. Our strength basically lies on flexibility and adaptability which allow us to tailor-fit our systems to the end user's specific requirements supported by our highly trained after-sales-technical support engineers,",
                            style: TextStyle(fontSize: 15, color: Colors.grey, letterSpacing: 0.8),),
                          TextSpan(text: " We gained the reputation of being a total solution provider.",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
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
                margin: EdgeInsets.symmetric(vertical: 50),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75,),
                    Text(
                      "Our Mission & Vision",
                      style: TextStyle(
                          fontSize: 34.0,
                          fontFamily: 'Rowdies',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.deepOrange.shade600
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                    ),

                    SizedBox(height: 10,),
                    Text(
                      "OUR AIMS",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                    Lottie.network(
                      'https://lottie.host/68b583d9-5d17-4b1a-91fd-5ea004b4e059/vJsIqeClYC.json',
                      height: 75,
                      width: 75,
                    ),

                    SizedBox(height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image(image: NetworkImage("${API.dashboard}market.png"), fit: BoxFit.fill),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO BE A MARKET LEADER',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' in all our business fields by continuing to "challenge our own success"',
                                style: TextStyle(fontSize: 15, color: Colors.grey, letterSpacing: 0.8),),
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
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO OUR CUSTOMERS',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' , we will be a complete solution to their business requirements by giving "the BEST products, technical support and after-sales services"',
                                style: TextStyle(fontSize: 15, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image(image: NetworkImage("${API.dashboard}customer.png"), fit: BoxFit.fill),
                        ),
                      ],
                    ),

                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image(image: NetworkImage("${API.dashboard}business_partner.png"), fit: BoxFit.fill),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: '  TO OUR BUSINESS PARTNERS',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8),),
                              TextSpan(text: ' , a mutual benefit relationship.',
                                style: TextStyle(fontSize: 15, color: Colors.grey, letterSpacing: 0.8),),
                            ]
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60,),
              // follow us
              Lottie.network(
                'https://lottie.host/b4271de5-63c3-47d2-b756-71bf41c8c643/ARaXZtHsJ8.json',
                frameRate: FrameRate.max,
                height: 150,
                width: 500,
                controller: lottieController,
                onLoaded: (composition) {
                  lottieController.duration = Duration(milliseconds: 10);
                  lottieController.forward();
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Image(image: AssetImage("assets/icons/facebook-v2.png"), height: 50, width: 50,),
                    onTap: () async{
                      setState(() {
                        _launchURL("https://www.facebook.com/EnyeControl/");
                      });
                    }
                  ),

                  SizedBox(width: 15,),
                  GestureDetector(
                    child: Image(image: AssetImage("assets/icons/instagram.png"), height: 50, width: 50,),
                    onTap: () async{
                      setState(() {
                        _launchURL("https://www.instagram.com/enyecontrols/");
                      });
                    }
                  ),

                  SizedBox(width: 15,),
                  GestureDetector(
                    child: Image(image: AssetImage("assets/icons/twitter.png"), height: 50, width: 50,),
                    onTap: () async{
                      setState(() {
                        _launchURL("https://twitter.com/enyecontrols");
                      });
                    }
                  ),

                  SizedBox(width: 15,),
                  GestureDetector(
                    child: Image(image: AssetImage("assets/icons/youtube-round-2.png"), height: 50, width: 50,),
                    onTap: () async{
                      setState(() {
                        _launchURL("https://www.youtube.com/channel/UCTPwjwa1YioMkHZCvYjrAnw");
                      });
                    }
                  ),

                  SizedBox(width: 15,),
                  GestureDetector(
                    child: Image(image: AssetImage("assets/icons/linkedin.png"), height: 50, width: 50,),
                    onTap: () async{
                      setState(() {
                        _launchURL("https://www.linkedin.com/company/enyecontrols");
                      });
                    }
                  ),
                ],
              ),

              SizedBox(height: 60,)
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
