import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ServicePage extends StatefulWidget {
  static const String routeName = '/service';

  RemoteMessage? message;

  ServicePage({required this.message});

  Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => ServicePage(message: message,)
    );
  }

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  RemoteMessage message = RemoteMessage();
  bool? userSessionFuture;

  clientInfo? ClientInfo;

  _errorSnackbar(context, message){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(
          bottom: screenHeight * 0.04,
          left: screenWidth * 0.15,
          right: screenWidth * 0.15,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            SizedBox(width: screenWidth * 0.01,),
            Flexible(
              child: Text(
                message.toString().toUpperCase(),
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: fontNormalSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logoutClient() async {
    dynamic token = await SessionManager().get("token");

    await SessionManager().remove("client_data");
    await FirebaseServices().signOut();

    //clear the client_id in a token
    TokenServices.updateToken(token.toString(), "").then((result) {
      if('success' == result){
        print("Updated token successfully");
      } else {
        print("Error updating token");
      }
    });

    setState(() {
      userSessionFuture = false;
      ClientInfo = null; // Clear the client info
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginPage())).then((value) { setState(() {}); });
    });
  }

  void initState(){
    super.initState();
    if(widget.message!.data["goToPage"] == "Status"){
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => StatusPage(message: widget.message!)),
        );
      });
    } else if(widget.message!.data["goToPage"] == "Completed"){
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => HistoryPage(message: widget.message!)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
          });
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });

    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.03),
                child: Lottie.network(
                    'https://lottie.host/e0b46b50-377a-4679-9f7d-d860fa44c7fd/2CntC1k3EB.json',
                    frameRate: FrameRate.max,
                    alignment: Alignment.center,
                    height: screenHeight * 0.5,
                    width: screenWidth * 1
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userSessionFuture == true ? "Hello ${ClientInfo?.name}," : "Hello Guest !",
                        style: GoogleFonts.lalezar(
                          textStyle:
                          TextStyle(fontSize: fontExtraSize, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                        )
                    ),
                    // Text("${FirebaseAuth.instance.currentUser!.displayName}"),
                    //Text( FirebaseAuth.instance.currentUser?.displayName != null ? "${FirebaseAuth.instance.currentUser?.displayName}": "Hello Guest !"),
                    PopupMenuButton(
                      child: Container(
                        height: (screenHeight + screenWidth) / 23,
                        width: (screenHeight + screenWidth) / 23,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: userSessionFuture == true && ClientInfo?.image != ""
                              ? ClientInfo?.login == "GMAIL" ? Image.network("${ClientInfo?.image}").image : Image.network("${API.clientsImages + ClientInfo!.image}").image
                              : AssetImage("assets/icons/user.png"),
                          ),
                        ),
                      ),
                      onSelected: (value) {
                        if (value == '/login'){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginPage())).then((value) { setState(() {}); });
                        } else if (value == '/logout'){
                          logoutClient();
                        } else if (value == '/profile'){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage())).then((value) { setState(() {}); });
                        }
                      },
                      itemBuilder: (BuildContext bc) {
                        if (userSessionFuture == true) {
                          return [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.deepOrange,
                                    size: (screenHeight + screenWidth) / 50,
                                  ),
                                  SizedBox(width: screenWidth * 0.05,),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: fontExtraSize,
                                    ),
                                  )
                                ],
                              ),
                              value: '/profile',
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.deepOrange,
                                    size: (screenHeight + screenWidth) / 50,
                                  ),
                                  SizedBox(width: screenWidth * 0.05,),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: fontExtraSize,
                                    ),
                                  )
                                ],
                              ),
                              value: '/logout',
                            )
                          ];
                        } else {
                          return [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.login,
                                    color: Colors.deepOrange,
                                    size: (screenHeight + screenWidth) / 50,
                                  ),
                                  SizedBox(width: screenWidth * 0.05,),
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: fontExtraSize,
                                    ),
                                  )
                                ],
                              ),
                              value: '/login',
                            )
                          ];
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01),

          //book a service button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.0),
            child: customButton(
              onTap: () {
                if (userSessionFuture == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingSystem()),
                  );
                } else {
                  _errorSnackbar(context, "Login first before booking !");
                }
              },
              text: 'BOOK A SERVICE',
              clr: Colors.deepOrange,
              fontSize: fontExtraSize,
            ),
          ),

          SizedBox(height: screenHeight * 0.03),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //status button
              GestureDetector(
                onTap: (){
                  if (userSessionFuture == true) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatusPage(message: message))).then((value) { setState(() {}); });
                  } else {
                    _errorSnackbar(context, "Login first !");
                  }
                },
                child: Container(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.26,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        alignment: Alignment(0.0, -0.3),
                        image: AssetImage("assets/icons/service-status.png"),
                        scale: screenLayout ? 3.1 : 1.7,
                      )
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Status",
                        style: GoogleFonts.rowdies(
                          textStyle: TextStyle(fontSize: fontExtraSize, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //history button
              GestureDetector(
                onTap: (){
                  if (userSessionFuture == true) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPage(message: message))).then((value) { setState(() {}); });
                  } else {
                    _errorSnackbar(context, "Login first !");
                  }
                },
                child: Container(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.26,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        alignment: Alignment(0.0, -0.3),
                        image: AssetImage("assets/icons/service-history.png"),
                        scale: screenLayout ? 3.1 : 1.7,
                      )
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("History",
                        style: GoogleFonts.rowdies(
                          textStyle: TextStyle(fontSize: fontExtraSize, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //help button
              GestureDetector(
                onTap: (){
                  if (userSessionFuture == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Onbording()),
                    );
                  } else {
                    _errorSnackbar(context, "Login first !");
                  }
                },
                child: Container(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.26,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          alignment: Alignment(0.0, -0.3),
                          image: AssetImage("assets/icons/question.png"),
                          scale: screenLayout ? 3.1 : 1.7,
                        )
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text("Help",
                          style: GoogleFonts.rowdies(
                            textStyle: TextStyle(fontSize: fontExtraSize, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                          ),
                        ),
                      ),
                    ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

