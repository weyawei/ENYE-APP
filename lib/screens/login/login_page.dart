import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';


class loginPage extends StatefulWidget {
  static const String routeName = '/login';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => loginPage()
    );
  }

  loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = false;

  //close the keyboard if nakalabas
  void _onButtonPressed() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  bool _isShowingErrorSnackbar = false; // Flag to track if error snackbar is already being displayed
  Future<void> signUserIn() async {
    if (_isShowingErrorSnackbar) return; // If error snackbar is already visible, do nothing
    _isShowingErrorSnackbar = true; // Set the flag to indicate that error snackbar is being shown

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      dynamic token = await SessionManager().get("token");

      var res = await http.post( //pasiing value to result
        Uri.parse(API.login),
        body: {
          'email' : emailController.text.trim(),
          'password' : passwordController.text.trim(),
        },
      );

      if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
        var resBodyOfLogin = jsonDecode(res.body);
        if(resBodyOfLogin['login'] == true){

          var clientData = resBodyOfLogin["clients_data"];
          await SessionManager().set("client_data",  clientInfo(
              client_id: clientData["client_id"],
              name: clientData["name"],
              contact_no: clientData["contact_no"],
              company: clientData["company_name"],
              image: clientData["image"],
              email: clientData["email"],
              login: 'SIGNIN',
              status: "Unverified"
          ));
          Map<String, String?> deviceDetails = await checkSession().getDeviceDetails();
          TokenServices.updateToken(token.toString(), clientData["email"], 'SIGNIN', ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
            if('success' == result){
              print("Updated token successfully");
            } else {
              print("Error updating token");
            }
          });

          setState(() {
            disabling = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.greenAccent,
                      size: (screenHeight + screenWidth) / 75,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "Congratulations, Login Successfully.",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).closed.then((value) => Navigator.pop(context, true));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
              content: Row(
                children: [
                  Icon(
                    Icons.close,
                    color: Colors.white,
                    size: (screenHeight + screenWidth) / 75,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Incorrect email or password !",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: fontNormalSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).closed.then((_) {
            // After snackbar is closed, reset the flag
            _isShowingErrorSnackbar = false;
          }
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      backgroundColor: Colors.deepOrange.shade200,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo application
              SizedBox(height: screenHeight * 0.2,),
              Container(
                alignment: Alignment.center,
                height: screenHeight * 0.042,
                width: screenWidth * 0.78,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/logo/enyecontrols.png"), fit: BoxFit.fill)
                ),
              ),

              //email textfield
              SizedBox(height: screenHeight * 0.08,),
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

              //forgot password
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassPage(verified: false, email: '',))).then((value) { setState(() {}); });
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: fontSmallSize,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //sign-in button
              SizedBox(height: screenHeight * 0.01,),
              customButton(
                text: "SIGN IN",
                onTap: (){
                  if (disabling == false) {
                    signUserIn();
                  }
                  _onButtonPressed();
                },
                clr: Colors.deepOrange,
                fontSize: fontExtraSize,
              ),

              //or continue with
              SizedBox(height: screenHeight * 0.05,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.05),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade500,)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.025),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          fontSize: fontSmallSize,
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

              SizedBox(height: screenHeight * 0.017,),
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
                        name: '',
                        contact_no: '',
                        company: '',
                        image: '', // Use photoURL if not null, otherwise use an empty string
                        email: user.email.toString(),
                        login: 'APPLE', // Indicate this as an Apple login
                        status: "Unverified"
                      ));

                      Map<String, String?> deviceDetails = await checkSession().getDeviceDetails();

                      dynamic token = await SessionManager().get("token");
                      TokenServices.updateToken(token.toString(), FirebaseAuth.instance.currentUser!.email.toString(), 'APPLE', ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
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
                        contact_no: '',
                        company: '',
                        image: FirebaseAuth.instance.currentUser!.photoURL.toString(),
                        email: FirebaseAuth.instance.currentUser!.email.toString(),
                        login: 'GMAIL',
                        status: "Unverified"
                      ));

                      Map<String, String?> deviceDetails = await checkSession().getDeviceDetails();

                      dynamic token = await SessionManager().get("token");
                      TokenServices.updateToken(token.toString(), FirebaseAuth.instance.currentUser!.email.toString(), 'GMAIL', ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
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

              //LOGIN WITH GOOGLE RON COMMENT LANG MUNA
              /*Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseServices().signInWithGoogle();
                    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServicePage()));
                      Navigator.pop(context);

                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)){
                            return Colors.black26;
                          }
                          return Colors.white;
                        })
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Image.asset('assets/logo/google_icon.png' ,width: 40, height: 40,),
                            const SizedBox(
                              width: 20,
                            ),
                            Center(
                              child: Text("Login with Google",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}


