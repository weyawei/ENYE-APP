import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class MainAccPage2 extends StatefulWidget {
  final Function onLogoutSuccess;
  MainAccPage2({super.key, required this.onLogoutSuccess});

  @override
  State<MainAccPage2> createState() => _MainAccPage2State();
}

class _MainAccPage2State extends State<MainAccPage2> {
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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    dynamic token = await SessionManager().get("token");

    await SessionManager().remove("client_data");
    await FirebaseServices().signOut();

    //clear the client_id in a token
    TokenServices.updateToken(token.toString(), "", "", ApiPlatform.getPlatform()).then((result) {
      if('success' == result){
        print("Updated token successfully");
      } else {
        print("Error updating token");
      }
    });
    widget.onLogoutSuccess();
  }

  Future<void> _launchURL (String url) async{
    try {
      bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }

  void showSampleDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent_outlined, // Replace with your desired icon
                color: Colors.deepOrange,
                size: fontNormalSize * 2, // Adjust icon size as needed
              ),
              SizedBox(width: screenWidth * 0.01,),
              Text(
                "Contact Us",
                style: TextStyle(
                    fontSize: fontNormalSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.deepOrange
                ),
              )
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "For services concern : ",
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: fontSmallSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2
                ),
              ),

              TextButton.icon(
                onPressed: (){
                  final phoneNumber  = '(02) 7616-5949';
                  final url = 'tel:$phoneNumber';

                  _launchURL(url);
                },
                icon: Icon(Icons.fax, size: fontNormalSize * 1.5, color: Colors.deepOrange.withOpacity(0.5),),
                label: Text('(02) 7616-5949',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: fontSmallSize,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,),
                ),
              ),

              TextButton.icon(
                onPressed: (){
                  final phoneNumber  = '+639171387114';
                  final url = 'tel:$phoneNumber';

                  _launchURL(url);
                },
                icon: Icon(Icons.phone, size: fontNormalSize * 1.5, color: Colors.deepOrange.withOpacity(0.5),),
                label: Text('(+63) 917-138-7114',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: fontSmallSize,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,),
                ),
              ),

              TextButton.icon(
                onPressed: (){
                  final toEmail  = 'enyecontrols@enyecontrols.com';
                  final url = 'mailto:$toEmail';

                  _launchURL(url);
                },
                icon: Icon(Icons.mail, size: fontNormalSize * 1.5, color: Colors.deepOrange.withOpacity(0.5),),
                label: Text('enyecontrols@enyecontrols.com',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: fontSmallSize,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void appointmentDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_outlined, // Replace with your desired icon
                color: Colors.deepOrange,
                size: fontNormalSize * 2, // Adjust icon size as needed
              ),
              SizedBox(width: screenWidth * 0.01,),
              Text(
                "Appointment",
                style: TextStyle(
                    fontSize: fontNormalSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.deepOrange
                ),
              )
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // services buttons
              Row(
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
                      height: screenHeight * 0.13,
                      width: screenWidth * 0.31,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/service-appointment.png",
                            height: screenHeight * 0.05,
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
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AppointmentStatusPage(message: message, email: ClientInfo!.email,)),
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.13,
                      width: screenWidth * 0.31,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/service-status.png", // Replace with your image path
                            height: screenHeight * 0.05, // Adjust the size as needed
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


            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void technicalDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.manage_history, // Replace with your desired icon
                color: Colors.deepOrange,
                size: fontNormalSize * 2, // Adjust icon size as needed
              ),
              SizedBox(width: screenWidth * 0.01,),
              Text(
                "Status & History",
                style: TextStyle(
                    fontSize: fontNormalSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.deepOrange
                ),
              )
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TechnicalStatusPage(email: ClientInfo!.email)),
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.13,
                      width: screenWidth * 0.31,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              "assets/icons/technical-status.png", // Replace with your image path
                              height: screenHeight * 0.05 // Adjust the size as needed
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

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TechnicalHistoryPage(message: message, email: ClientInfo!.email)),
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.13,
                      width: screenWidth * 0.31,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/service-history.png", // Replace with your image path
                            height: screenHeight * 0.05, // Adjust the size as needed
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
                    ),
                  )
                ],
              ),


            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  bool _snackbarShown = false;

  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely reference the ScaffoldMessenger here
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    // Do not call ScaffoldMessenger.of(context) in dispose
    // Use the stored reference instead
    _scaffoldMessenger?.hideCurrentSnackBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(ClientInfo?.name == '' || ClientInfo?.contact_no == '' && !_snackbarShown){
        _snackbarShown = true;
        showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Please complete the required fields by clicking the icon in the upper right corner for verification. \n Thank you!");
      } else if (ClientInfo?.status == "Unverified" && !_snackbarShown) {
        _snackbarShown = true;
        showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
      } else {

      }
    });

    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              color: Colors.deepOrange,
              height: screenHeight * 0.14,
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.01,
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
                          child: Stack(
                            clipBehavior: Clip.none, // Allow content to overflow the bounds of the stack
                            children: [
                              Material(
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
                              if(ClientInfo?.name == '' || ClientInfo?.contact_no == '' || ClientInfo?.company == '')
                              Positioned(
                                top: -5, // Adjust the position of the exclamation point
                                left: -5, // Position it on the upper left corner of the icon
                                child: Container(
                                  padding: EdgeInsets.all(5.0), // Add padding for a circular look
                                  decoration: BoxDecoration(
                                    color: Colors.red, // Red background for the exclamation point
                                    shape: BoxShape.circle, // Make it circular
                                    border: Border.all(
                                      color: Colors.white, // White border color
                                      width: 1.0, // Border width
                                    ),
                                  ),
                                  child: Text(
                                    '!',
                                    style: TextStyle(
                                      color: Colors.white, // White text color for visibility
                                      fontSize: fontSmallSize, // Adjust font size as needed
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: screenHeight * 0.06,
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
                    top: screenHeight * 0.1,
                    width: screenWidth,
                    child: Container(
                        height: screenHeight * 0.08,
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
                    top: screenHeight * 0.043,
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
                              color: Colors.deepOrange.shade100,
                              width: 4.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: fontNormalSize * 2.5, // Adjust radius to fit within the border
                            backgroundImage: ClientInfo != null && ClientInfo!.image.isNotEmpty
                                ? ClientInfo!.login == "GMAIL"
                                ? Image.network("${ClientInfo!.image}").image
                                : Image.network("${API.clientsImages + ClientInfo!.image}").image
                                : AssetImage('assets/icons/user_orange.png') as ImageProvider, // Cast AssetImage to ImageProvider
                          )
                      ),
                    ),
                  ),
                ],   //
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015,
                horizontal: screenWidth * 0.05,
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

            Column(
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.0075,
                      horizontal: screenWidth * 0.14
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(ClientInfo?.status == "Unverified") {
                            showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
                          } else {
                            appointmentDialog(context);
                          }
                        },
                        child: Container(
                          height: screenHeight * 0.13,
                          width: screenWidth * 0.71,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  "assets/icons/service-appointment.png", // Replace with your image path
                                  height: screenHeight * 0.05 // Adjust the size as needed
                              ),
                              SizedBox(height: screenHeight * 0.01),  // Space between image and text
                              Flexible(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  text: TextSpan(children: <TextSpan>
                                  [
                                    TextSpan(text: 'Set',
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
                      )
                    ],
                  ),
                ),




                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.0075,
                      horizontal: screenWidth * 0.14
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(ClientInfo?.status == "Unverified") {
                            showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
                          } else {
                            technicalDialog(context);
                          }
                        },
                        child: Container(
                          height: screenHeight * 0.13,
                          width: screenWidth * 0.71,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  "assets/icons/technical-status.png", // Replace with your image path
                                  height: screenHeight * 0.05 // Adjust the size as needed
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

                                    TextSpan(text: '\n Status & History',
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
                      vertical: screenHeight * 0.0075,
                      horizontal: screenWidth * 0.14
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(ClientInfo?.status == "Unverified") {
                            showPersistentSnackBar(context, screenWidth, screenHeight, fontNormalSize, "Verification in progress! \nOur team is reviewing your account. Thank you for understanding!");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderTrackingPage()),
                            );
                          }
                        },
                        child: Container(
                          height: screenHeight * 0.13,
                          width: screenWidth * 0.71,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  "assets/icons/tracking.png", // Replace with your image path
                                  height: screenHeight * 0.05 // Adjust the size as needed
                              ),
                              SizedBox(height: screenHeight * 0.01),  // Space between image and text
                              Flexible(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  text: TextSpan(children: <TextSpan>
                                  [
                                    TextSpan(text: 'Order',
                                      style: TextStyle(
                                          fontSize: fontSmallSize,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange.shade700
                                      ),
                                    ),

                                    TextSpan(text: '\n Tracking',
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
              ],
            ),

            SizedBox( height: screenHeight * 0.05 ),

            // Contact Us : Ms Mau contacts
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: GestureDetector(
                onTap: () {
                  showSampleDialog(context);
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

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.deepOrange.shade300, size: fontNormalSize * 1.5,),
                          SizedBox(width: 5),
                          Text(
                            'LOGOUT',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rowdies(
                              textStyle: TextStyle(
                                fontSize: fontNormalSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        'Are you sure to logout your account?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: fontNormalSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8
                          ),
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontSize: fontNormalSize,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              logoutClient();
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text(
                            "YES",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontNormalSize,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade400),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
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
