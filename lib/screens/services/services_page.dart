import 'dart:convert';
import 'dart:io';

import 'package:enye_app/screens/service/chat/chat_page.dart';
import 'package:enye_app/screens/service/tracker/tracker_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ServicesPage extends StatefulWidget {
  static const String routeName = '/service';

  RemoteMessage? message;

  ServicesPage({required this.message});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}
class _ServicesPageState extends State<ServicesPage> {
  RemoteMessage message = RemoteMessage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool disabling = false;

  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool screenLayout = ResponsiveTextUtils.getLayout(screenWidth);

    var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);

    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.03),
                child: Center(
                  child: Lottie.asset(
                      'assets/lottie/service_page.json',
                      frameRate: FrameRate.max,
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hello !",
                        style: GoogleFonts.lalezar(
                          textStyle:
                          TextStyle(fontSize: fontExtraSize, letterSpacing: 1.5, color: Colors.deepOrange.shade700),
                        )
                    ),

                    Container(
                      height: (screenHeight + screenWidth) / 26,
                      width: (screenHeight + screenWidth) / 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.deepOrange, // Change this to your desired color
                          width: 1.0, // Adjust the width of the border
                        ),
                        image: DecorationImage(
                          image: AssetImage("assets/icons/user_orange.png"),
                          fit: BoxFit.fill, // Ensure the image covers the entire container
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01),
          EmailTextField(
            controller: emailController,
            hintText: 'Email',
            disabling: disabling,
          ),

          //password textfield
          SizedBox(height: screenHeight * 0.02,),
          PasswordTextField(
            controller: passwordController,
            hintText: 'Password',
            disabling: disabling,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassPage())).then((value) { setState(() {}); });
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: fontSmallSize,
                        letterSpacing: 1.2,
                        color: Colors.grey.shade800,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: customButton(
              text: "LOGIN",
              onTap: (){
                if (disabling == false) {
                  // signUserIn();
                }
                // _onButtonPressed();
              },
              clr: Colors.deepOrange,
              fontSize: fontExtraSize,
            ),
          ),

          //or continue with
          SizedBox(height: screenHeight * 0.01,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.03),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.3,
                    color: Colors.grey.shade500,)
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.025),
                  child: Text(
                    'Or continue with',
                    style: TextStyle(
                      fontSize: fontXSmallSize,
                      letterSpacing: 1.2,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey.shade500,)
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01,),
          //gmail + facebook sign in
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //apple id login
            Platform.isIOS
              ? GestureDetector(
                onTap: () async {

                  final credential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );

                  // Concatenate givenName and familyName to form the full name
                  String? fullName;
                  if (credential.givenName != null && credential.familyName != null) {
                    fullName = "${credential.givenName!} ${credential.familyName!}";
                  }

                  print("Full Name: $fullName"); // Debugging


                  // Use the credential to sign in or create a user account with Firebase
                  final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
                  final AuthCredential appleCredential = oAuthProvider.credential(
                    idToken: credential.identityToken,
                    accessToken: credential.authorizationCode,
                  );

                  // Sign in with Firebase using the Apple credentials
                  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(appleCredential);
                  final User user = userCredential.user!;

                  print("Apple ID : " + user.uid.toString());
                  print("Apple EMAIL : " + user.email.toString());
                  print("Apple Name : " + user.displayName.toString());

                  // Set client data in session manager
                  await SessionManager().set("client_data", clientInfo(
                    client_id: user.uid.toString(),
                    name: '', // Use fullName if not null, otherwise use an empty string
                    company_name: '',
                    location: '',
                    project_name: '',
                    contact_no: '',
                    image: '', // Use photoURL if not null, otherwise use an empty string
                    email: user.email.toString(),
                    login: 'APPLE', // Indicate this as an Apple login
                  ));


                  dynamic token = await SessionManager().get("token");
                  TokenServices.updateToken(token.toString(), FirebaseAuth.instance.currentUser!.uid.toString()).then((result) {
                    if('success' == result){
                      print("Updated token successfully");
                    } else {
                      print("Error updating token");
                    }
                  });
                  Navigator.pop(context, true);
                },
                child: Image(
                  image: AssetImage('assets/icons/apple.png'),
                  height: (screenHeight + screenWidth) / 28,
                  width: (screenHeight + screenWidth) / 28,
                ),
              )
              : SizedBox.shrink(),

            Platform.isIOS
              ? SizedBox(width: screenWidth * 0.05,)
              : SizedBox.shrink(),

              GestureDetector(
                onTap: () async {
                  await FirebaseServices().signInWithGoogle();
                  await SessionManager().set("client_data",  clientInfo(
                    client_id: FirebaseAuth.instance.currentUser!.uid.toString(),
                    name: FirebaseAuth.instance.currentUser!.displayName.toString(),
                    company_name: '',
                    location: '',
                    project_name: '',
                    contact_no: '',
                    image: FirebaseAuth.instance.currentUser!.photoURL.toString(),
                    email: FirebaseAuth.instance.currentUser!.email.toString(),
                    login: 'GMAIL',
                  ));

                  dynamic token = await SessionManager().get("token");
                  TokenServices.updateToken(token.toString(), FirebaseAuth.instance.currentUser!.uid.toString()).then((result) {
                    if('success' == result){
                      print("Updated token successfully");
                    } else {
                      print("Error updating token");
                    }
                  });
                  Navigator.pop(context, true);
                },
                child: Image(
                  image: AssetImage('assets/icons/gmail.png'),
                  height: (screenHeight + screenWidth) / 28,
                  width: (screenHeight + screenWidth) / 28,
                ),
              ),

              /*SizedBox(width: 25,),
                  Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),*/
            ],
          ),

          SizedBox(height: screenHeight * 0.01,),
          //not a member sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not a member?',
                style: TextStyle(
                    fontSize: fontSmallSize,
                    letterSpacing: 1.2,
                    color: Colors.grey.shade800
                ),
              ),
              SizedBox(height: screenHeight * 0.04,),
              TextButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => registerPage())).then((value) { setState(() {}); });
                },
                child: Text(
                  'Register now',
                  style: TextStyle(
                      fontSize: fontSmallSize,
                      letterSpacing: 1.2,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
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

