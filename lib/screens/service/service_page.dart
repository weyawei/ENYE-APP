import 'package:enye_app/screens/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../config/api_firebase.dart';
import '../../config/app_checksession.dart';
import '../../widget/widgets.dart';
import '../screens.dart';
import 'booking_service.dart';

class ServicePage extends StatefulWidget {
  static const String routeName = '/service';

  ServicePage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => ServicePage()
    );
  }

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  bool? userSessionFuture;

  clientInfo? ClientInfo;

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.37,),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message.toString().toUpperCase(), style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logoutClient() async {
    await SessionManager().remove("client_data");
    await FirebaseServices().signOut();
    setState(() async {
      userSessionFuture = false;
      ClientInfo = null; // Clear the client info
      await FirebaseServices().signOut();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginPage())).then((value) { setState(() {}); });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: Lottie.network(
                    'https://lottie.host/e0b46b50-377a-4679-9f7d-d860fa44c7fd/2CntC1k3EB.json',
                    frameRate: FrameRate.max,
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userSessionFuture == true ? "Hello ${ClientInfo?.name}," : "Hello Guest !",
                        style: GoogleFonts.lalezar(
                          textStyle:
                          TextStyle(fontSize: 26, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                        )
                    ),
                   // Text("${FirebaseAuth.instance.currentUser!.displayName}"),
                    Text( FirebaseAuth.instance.currentUser?.displayName != null ? "${FirebaseAuth.instance.currentUser?.displayName}": "Hello Guest !"),
                    PopupMenuButton(
                      icon: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.11,
                        decoration: BoxDecoration(
                         // image: DecorationImage(image: AssetImage("assets/icons/user.png")),
                          image: DecorationImage(image: FirebaseAuth == true ? Image.network("${FirebaseAuth.instance.currentUser!.photoURL}").image : AssetImage("assets/icons/user.png")),
                        ),
                      ),
                      onSelected: (value) {
                        if (value == '/login'){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => loginPage())).then((value) { setState(() {}); });
                          /*PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: loginPage.routeName,),
                            screen: loginPage(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );*/
                        } else if (value == '/logout'){
                          logoutClient();
                        }
                      },
                      itemBuilder: (BuildContext bc) {
                        if (userSessionFuture == true) {
                          return [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.person, color: Colors.deepOrange,),
                                  SizedBox(width: 10,),
                                  Text("Profile", style: TextStyle(fontWeight: FontWeight.w600),)
                                ],
                              ),
                              value: '/profile',
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.deepOrange,),
                                  SizedBox(width: 10,),
                                  Text("Logout", style: TextStyle(fontWeight: FontWeight.w600),)
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
                                  Icon(Icons.login, color: Colors.deepOrange,),
                                  SizedBox(width: 10,),
                                  Text("Login", style: TextStyle(fontWeight: FontWeight.w600),)
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

          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

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
              fontSize: 18,
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //status button
              GestureDetector(
                onTap: (){
                  if (userSessionFuture == true) {

                  } else {
                    _errorSnackbar(context, "Login first !");
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.26,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        alignment: Alignment(0.0, -0.3),
                        image: AssetImage("assets/icons/service-status.png"),
                        scale: 2.75,
                      )
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Status",
                        style: GoogleFonts.rowdies(
                          textStyle: TextStyle(fontSize: 15, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
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

                  } else {
                    _errorSnackbar(context, "Login first !");
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.26,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        alignment: Alignment(0.0, -0.3),
                        image: AssetImage("assets/icons/service-history.png"),
                        scale: 2.75,
                      )
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("History",
                        style: GoogleFonts.rowdies(
                          textStyle: TextStyle(fontSize: 15, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
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

                  } else {
                    _errorSnackbar(context, "Login first !");
                  }
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.26,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.deepOrange.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          alignment: Alignment(0.0, -0.3),
                          image: AssetImage("assets/icons/question.png"),
                          scale: 2.75,
                        )
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text("Help",
                          style: GoogleFonts.rowdies(
                            textStyle: TextStyle(fontSize: 15, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                          ),
                        ),
                      ),
                    )
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}

