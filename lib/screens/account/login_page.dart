import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class LoginPage extends StatefulWidget {

  final Function onLoginSuccess;
  LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool disabling = false;

  void initState(){
    super.initState();
  }

  bool _isShowingErrorSnackbar = false; // Flag to track if error snackbar is already being displayed
  Future<void> signUserIn() async {
    FocusScope.of(context).unfocus();

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
      disabling = true;
      setState(() {
        _isLoading = true;  // Show the loading screen
      });

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

          TokenServices.verificationEmail(emailController.text.trim(), 'Login').then((result) async {
            if('success' == result || 'Unverified' == result){
              var clientData = resBodyOfLogin["clients_data"];

              await SessionManager().set("client_data",  clientInfo(
                  client_id: clientData["client_id"],
                  name: clientData["name"],
                  contact_no: clientData["contact_no"],
                  company: clientData["company_name"],
                  image: clientData["image"],
                  email: clientData["email"],
                  login: 'SIGNIN',
                  status: result == 'success' ? "Verified" : "Unverified"
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
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.77),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                    content: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                          size: fontNormalSize * 1.5,
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
                ).closed.then((value) {
                  // productsNavigatorKey.currentState?.popUntil((route) => route.isFirst);
                  if(clientData["status"] == 'Inactive'){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassPage(verified: true, email: emailController.text.trim())),
                    ).then((value) { widget.onLoginSuccess(); });;
                  } else {
                    widget.onLoginSuccess();
                  }
                });
              });
            } else if ('exceed' == result) {
              setState(() {
                disabling = false;
                _isLoading = false;
              });
              showSnackbarFeedback(
                context,
                screenWidth,
                screenHeight,
                fontNormalSize,
                "Your login credentials are already used on 2 devices.",
                Icons.info,
                Colors.blue,
                6,
              );
            } else {
              // Show success snackbar and navigate
              setState(() {
                disabling = false;
                _isLoading = false;
              });
              showSnackbar(
                context: context,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                fontSize: fontNormalSize,
                message: "Error occurred...",
                bkColor: Colors.redAccent,
                icon: Icons.dangerous_rounded,
                isShowingErrorSnackbar: false,
                duration: 3
              );
            }
          });
        } else {
          // Show success snackbar and navigate
          setState(() {
            disabling = false;
            _isLoading = false;
          });
          showSnackbar(
            context: context,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            fontSize: fontNormalSize,
            message: "Incorrect email or password !",
            bkColor: Colors.redAccent,
            icon: Icons.dangerous_rounded,
            isShowingErrorSnackbar: false,
            duration: 3
          );
        }
      }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.deepOrange.shade200,
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo application
                  SizedBox(height: screenHeight * 0.10,),
                  Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.042,
                    width: screenWidth >= 600 ? screenWidth * 0.6 : screenWidth * 0.80,
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
                            FocusScope.of(context).unfocus();
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
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (disabling == false) {
                          signUserIn();
                        }
                      } else {
                        print('Form validation failed');
                      }
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
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isLoading = true;  // Show the loading screen
                          });

                          try {
                            // Request Apple sign-in credentials
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

                            // Verify email using your token service
                            TokenServices.verificationEmail(user.email.toString(), 'Login').then((result) async {
                              if ('success' == result || 'Unverified' == result) {
                                setState(() {
                                  _isLoading = false;  // Hide the loading screen
                                });

                                var verification_status = result == 'success' ? "Verified" : "Unverified";

                                // Continue with user account signup process for third-party sign-in
                                TokenServices.signupThirdParty('', user.email.toString(), 'APPLE').then((result) async {
                                  var resBodyOfLogin = jsonDecode(result);
                                  if (resBodyOfLogin['result'] == 'success') {
                                    var clientData = resBodyOfLogin["clients_data"];

                                    await SessionManager().set("client_data", clientInfo(
                                        client_id: user.uid.toString(),
                                        name: clientData["name"],
                                        contact_no: clientData["contact_no"],
                                        company: clientData["company_name"],
                                        image: clientData["image"],
                                        email: user.email.toString(),
                                        login: 'APPLE',
                                        status: verification_status
                                    ));

                                  } else {
                                    print("Error updating token");
                                  }
                                });

                                // Handle token update
                                dynamic token = await SessionManager().get("token");
                                Map<String, String?> deviceDetails = await checkSession().getDeviceDetails();

                                TokenServices.updateToken(token.toString(), user.email.toString(), 'APPLE', ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
                                  if ('success' == result) {
                                    print("Updated token successfully");
                                  } else {
                                    print("Error updating token");
                                  }
                                });

                                // Successful login callback
                                widget.onLoginSuccess();

                              } else if ('exceed' == result) {
                                setState(() {
                                  _isLoading = false;  // Hide the loading screen
                                });

                                // Clear stored session data to allow re-authentication
                                await FirebaseAuth.instance.signOut(); // Clear Firebase session
                                await SessionManager().remove("client_data"); // Clear saved client data

                                // Show a snackbar indicating that the limit has been reached
                                showSnackbar(
                                    context: context,
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    fontSize: fontNormalSize,
                                    message: "Your login credentials are already used on 2 devices.",
                                    bkColor: Colors.blue,
                                    icon: Icons.info,
                                    isShowingErrorSnackbar: false,
                                    duration: 6
                                );
                              } else {
                                setState(() {
                                  _isLoading = false;  // Hide the loading screen
                                });
                                showSnackbarFeedback(
                                  context,
                                  screenWidth,
                                  screenHeight,
                                  fontNormalSize,
                                  "Error occurred...",
                                  Icons.info,
                                  Colors.blue,
                                  6,
                                );
                              }
                            });
                          } catch (e) {
                            setState(() {
                              _isLoading = false;  // Hide the loading screen if there's an error
                            });
                            print("Error signing in with Apple: $e");
                          }
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
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isLoading = true;  // Show the loading screen
                          });

                          try {
                            // First, sign the user out to allow re-authentication
                            await FirebaseServices().signOut();
                            await GoogleSignIn().signOut();

                            // Now attempt to sign in again
                            await FirebaseServices().signInWithGoogle();

                            if (FirebaseAuth.instance.currentUser != null) {
                              // Continue if the user is signed in
                              TokenServices.verificationEmail(FirebaseAuth.instance.currentUser!.email.toString(), 'Login').then((result) async {
                                if('success' == result || 'Unverified' == result){
                                  setState(() {
                                    _isLoading = false;  // Hide the loading screen
                                  });

                                  var verification_status = result == 'success' ? "Verified" : "Unverified";

                                  TokenServices.signupThirdParty(FirebaseAuth.instance.currentUser!.displayName.toString(), FirebaseAuth.instance.currentUser!.email.toString(), 'GMAIL').then((result) async {
                                    var resBodyOfLogin = jsonDecode(result);
                                    if(resBodyOfLogin['result'] == 'success'){

                                      var clientData = resBodyOfLogin["clients_data"];

                                      await SessionManager().set("client_data",  clientInfo(
                                          client_id: FirebaseAuth.instance.currentUser!.uid.toString(),
                                          name: clientData["name"],
                                          contact_no: clientData["contact_no"],
                                          company: clientData["company_name"],
                                          image: FirebaseAuth.instance.currentUser!.photoURL.toString(),
                                          email: FirebaseAuth.instance.currentUser!.email.toString(),
                                          login: 'GMAIL',
                                          status: verification_status
                                      ));

                                      dynamic token = await SessionManager().get("token");
                                      Map<String, String?> deviceDetails = await checkSession().getDeviceDetails();

                                      TokenServices.updateToken(token.toString(), FirebaseAuth.instance.currentUser!.email.toString(), 'GMAIL', ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
                                        if('success' == result){
                                          print("Updated token successfully");
                                        } else {
                                          print("Error updating token");
                                        }
                                      });

                                      widget.onLoginSuccess();

                                    } else {
                                      print("Error updating token");
                                    }
                                  });
                                } else if ('exceed' == result) {
                                  setState(() {
                                    disabling = false;
                                    _isLoading = false;
                                  });

                                  // Allow the user to pick a new account by signing out the current session
                                  await GoogleSignIn().signOut();

                                  showSnackbarFeedback(
                                    context,
                                    screenWidth,
                                    screenHeight,
                                    fontNormalSize,
                                    "Your login credentials are already used on 2 devices. Please select another account.",
                                    Icons.info,
                                    Colors.blue,
                                    6,
                                  );
                                } else {
                                  setState(() {
                                    disabling = false;
                                    _isLoading = false;
                                  });
                                  showSnackbar(
                                      context: context,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      fontSize: fontNormalSize,
                                      message: "Error occurred...",
                                      bkColor: Colors.redAccent,
                                      icon: Icons.dangerous_rounded,
                                      isShowingErrorSnackbar: false,
                                      duration: 3
                                  );
                                }
                              });
                            } else {
                              setState(() {
                                _isLoading = false;  // Hide the loading screen if no account is picked
                              });
                              print("User did not select an account.");
                            }
                          } catch (e) {
                            setState(() {
                              _isLoading = false;  // Hide the loading screen if there's an error
                            });
                            print("Error signing in with Google: $e");
                          }
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
                          FocusScope.of(context).unfocus();
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
            ),

            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5), // Optional overlay
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
