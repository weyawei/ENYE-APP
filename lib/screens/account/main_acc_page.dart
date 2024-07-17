import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class MainAccPage extends StatefulWidget {
  final Function onLogoutSuccess;
  MainAccPage({super.key, required this.onLogoutSuccess});

  @override
  State<MainAccPage> createState() => _MainAccPageState();
}

class _MainAccPageState extends State<MainAccPage> {
  RemoteMessage message = RemoteMessage();
  bool? userSessionFuture;
  clientInfo? ClientInfo;

  void initState(){
    super.initState();

    _checkSession();
  }

  _checkSession(){
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
  }

  void _handleClientInfo() {
    setState(() {
      _checkSession();
    });
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

    widget.onLogoutSuccess();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            color: Colors.deepOrange,
            height: screenHeight * 0.17,
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.02,
                  right: screenWidth * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          ).then((_) => _handleClientInfo());
                        },
                        child: Material(
                          elevation: 7.0, // Adjust the elevation to control the shadow
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(8.0), // Adjust padding as needed
                            child: Icon(
                              Icons.settings, // Replace with your desired icon
                              color: Colors.deepOrange,
                              size: fontExtraSize * 1.25, // Adjust icon size as needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),

                Positioned(
                  top: screenHeight * 0.09,
                  left: fontNormalSize * 5 + screenWidth * 0.1,
                  child: Text(
                    "Hi, " + (ClientInfo?.name ?? 'Guest') + " !",
                    style: TextStyle(
                      fontSize: fontExtraSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.13,
                  width: screenWidth,
                  child: Container(
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    )
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.07,
                  left: screenWidth * 0.065,
                  child: Material(
                    elevation: 5.0, // Adjust the elevation to control the shadow depth
                    shape: CircleBorder(),
                    child: Container(
                      width: fontNormalSize * 5,
                      height: fontNormalSize * 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.deepOrange,
                          width: 4.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: fontNormalSize * 2.5, // Adjust radius to fit within the border
                        backgroundImage: ClientInfo != null && ClientInfo!.image.isNotEmpty
                            ? NetworkImage(API.clientsImages + ClientInfo!.image)
                            : AssetImage('assets/icons/user_orange.png') as ImageProvider, // Cast AssetImage to ImageProvider
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              top: screenHeight * 0.02,
            ),
            child: Text(
              "Services",
              style: TextStyle(
                color: Colors.black26,
                fontSize: fontSmallSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
              ),
            ),
          ),

          // services buttons
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.025,
                horizontal: screenWidth * 0.1
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingSystem()),
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.14,
                    width: screenWidth * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/service-appointment.png",
                          height: screenHeight * 0.06,
                        ),
                        SizedBox(height: screenHeight * 0.01),

                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: 'Create',
                                style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade700
                                ),
                              ),

                              TextSpan(text: '\n Appointment',
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange.shade700
                                ),
                              ),
                            ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => ProfilePage()),
                    // ).then((_) => _getServices() );
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => StatusPage(message: message)),
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.14,
                    width: screenWidth * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/service-status.png", // Replace with your image path
                          height: screenHeight * 0.06, // Adjust the size as needed
                        ),
                        SizedBox(height: screenHeight * 0.01), // Space between image and text
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: 'Appointment',
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange.shade700
                                ),
                              ),

                              TextSpan(text: '\n Status',
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange.shade700
                                ),
                              ),
                            ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.025,
                horizontal: screenWidth * 0.1
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TSIStatusPage(email: ClientInfo!.email)),
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.14,
                    width: screenWidth * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/technical-status.png", // Replace with your image path
                          height: screenHeight * 0.06, // Adjust the size as needed
                        ),
                        SizedBox(height: screenHeight * 0.01),  // Space between image and text
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(children: <TextSpan>
                            [
                              TextSpan(text: 'Technical',
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange.shade700
                                ),
                              ),

                              TextSpan(text: '\n Status',
                                style: TextStyle(
                                    fontSize: fontSmallSize,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange.shade700
                                ),
                              ),
                            ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: screenHeight * 0.14,
                  width: screenWidth * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/service-history.png", // Replace with your image path
                        height: screenHeight * 0.06, // Adjust the size as needed
                      ),
                      SizedBox(height: screenHeight * 0.01), // Space between image and text
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          text: TextSpan(children: <TextSpan>
                          [
                            TextSpan(text: 'Technical',
                              style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade700
                              ),
                            ),

                            TextSpan(text: '\n History',
                              style: TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade700
                              ),
                            ),
                          ]
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox( height: screenHeight * 0.1 ),

          // Contact Us : Ms Mau contacts
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: GestureDetector(
              onTap: () {

              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.88,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.support_agent_outlined, // Replace with the desired icon
                        color: Colors.deepOrange,
                        size: fontExtraSize * 1.75, // Adjust size as needed
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        "Contact Us",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: fontNormalSize,
                          letterSpacing: 1.5
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox( height: screenHeight * 0.01 ),

          // Logout Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1 ),
            child: customButton(
              onTap: () {
                logoutClient();
              },
              text: 'LOGOUT',
              clr: Colors.red,
              fontSize: fontNormalSize,
            ),
          ),
        ],
      )
    );
  }
}
