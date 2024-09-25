import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:enye_app/config/api_connection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../widget/widgets.dart';

class registerPage extends StatefulWidget {
  static const String routeName = '/register';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => registerPage()
    );
  }

  registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();

}

class _registerPageState extends State<registerPage> {
  //text editing controllers
  final nameController = TextEditingController();
  final compnameController = TextEditingController();
  final locationController = TextEditingController();
  final projnameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = false;
  bool _isShowingErrorSnackbar = false;

  bool isLoading = false;

  _successSnackbar(context, message){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.greenAccent,
              size: fontNormalSize * 1.8,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Expanded(
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: message,
                      style: TextStyle(
                        fontSize: fontNormalSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).closed.then((value) => Navigator.of(context).pop());
  }

  void _onButtonPressed() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  Future<void> signUserUp() async {
    //useradmin.dart transfering to json

    var map = Map<String, dynamic>();
    //get the action do by the user transfer it to POST method
    map['action'] = "SIGN UP";
    map['name'] = nameController.text.trim();
    map['contact_no'] = contactController.text.trim();
    map['email'] = emailController.text.trim();
    map['password'] = passwordController.text.trim();

    var res = await http.post( //pasiing value to result
      Uri.parse(API.register),
      body: map,
    );

    if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
      var resBodyOfSignUp = jsonDecode(res.body);

      //if email is already taken
      if(resBodyOfSignUp['client_add'] == true){ //registration success
        setState(() {
          disabling = true;
        });

        _formKey.currentState?.reset();

        _successSnackbar(context, "OTP is verified! Congratulations, SignUp Successfully.");
      } else {
        custSnackbar(context, "Error occured !", Colors.redAccent, Icons.dangerous_rounded, Colors.white );
      }
    }
  }

  void _showOTPDialog() {
    showDialog(
      barrierDismissible: false, // Prevents closing the dialog by tapping outside
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

        var fontXSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);
        var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);
        var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
        var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

        final defaultPinTheme = PinTheme(
          width: 56,
          height: 56,
          textStyle: TextStyle(fontSize: fontExtraSize, color: Colors.white, fontWeight: FontWeight.w600),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrange),
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepOrange.shade50,
          ),
        );
        final focusedPinTheme = defaultPinTheme.copyDecorationWith(
          border: Border.all(color: Colors.deepOrange.shade200),
          borderRadius: BorderRadius.circular(8),
        );
        final submittedPinTheme = defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration?.copyWith(
            color: Colors.deepOrange.shade300,
          ),
        );

        String errorMessage = ''; // Define an error message variable

      return StatefulBuilder(
         builder: (BuildContext context, StateSetter setState)
        {
          return Dialog(
            // Set dialog properties such as shape, elevation, etc.
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Close the dialog manually
                      },
                    ),
                  ),

                  if (errorMessage.isNotEmpty) // Show the error message if it's not empty
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Kindly check the email you provided:",
                      style: TextStyle(fontSize: fontNormalSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      emailController.text,
                      style: TextStyle(fontSize: fontNormalSize,
                         // fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.01),
                    child: Text(
                      "Please enter the 6 Digit OTP CODE  that we sent to you:",
                      style: TextStyle(
                          fontSize: fontXSmallSize,
                          fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Pinput(
                      controller: pin,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,

                      // scrollPadding: EdgeInsets.all(5),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //  Navigator.of(context).pop(); // Close the dialog
                      if (await myauth.verifyOTP(otp: pin.text)) {
                        Navigator.of(context)
                            .pop(); // Close the dialog only if OTP is valid
                        signUserUp();
                      } else {
                       /* custSnackbar(context, "Invalid OTP !", Colors.redAccent,
                            Icons.dangerous_rounded, Colors.white);*/
                        // Update the error message and re-render the dialog
                        setState(() {
                          errorMessage = "Invalid OTP! Please try again.";
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            letterSpacing: 1.2,
                            color: Colors.white,
                            fontSize: fontExtraSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      },
    );
  }


  TextEditingController pin = TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
        return Scaffold(
          backgroundColor: Colors.deepOrange.shade200,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //logo application
                  SizedBox(height: screenHeight * 0.12,),
                  Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.042,
                    width: screenWidth * 0.78,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/logo/enyecontrols.png"), fit: BoxFit.fill)
                    ),
                  ),

                  //lets create an account for you
                  SizedBox(height: screenHeight * 0.03,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Text(
                      "Let's create an account for you!",
                      style: TextStyle(
                        letterSpacing: 1.2,
                        color: Colors.grey.shade800,
                        fontSize: fontNormalSize,
                      ),
                    ),
                  ),

                  //fullname textfield
                  SizedBox(height: screenHeight * 0.03,),
                  PersonNameTextField(
                    controller: nameController,
                    hintText: 'Fullname',
                    disabling: disabling,
                  ),

                  SizedBox(height: screenHeight * 0.008,),
                  Contact2TextField(
                    controller: contactController,
                    hintText: 'Contact # (09xxxxxxxxx)',
                    disabling: disabling,
                  ),

                  //email textfield
                  SizedBox(height: screenHeight * 0.008,),
                  EmailTextField(
                    controller: emailController,
                    hintText: 'Email',
                    disabling: disabling,
                  ),

                  //password textfield
                  SizedBox(height: screenHeight * 0.008,),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    disabling: disabling,
                  ),

                  //confirm password textfield
                  SizedBox(height: screenHeight * 0.008,),
                  PasswordTextField(
                    controller: conpasswordController,
                    hintText: 'Confirm Password',
                    disabling: disabling,
                  ),

                  //tapping agree
                  SizedBox(height: screenHeight * 0.05,),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'By tapping Sign Up, I agree to the ',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 1.2,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        TextSpan(
                          text: '\n Terms and Conditions',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL("https://www.enyecontrols.com/privacypolicy/terms.html");
                            },
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 1.2,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                            fontSize: fontSmallSize,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL("https://www.enyecontrols.com/privacypolicy/policy.html");
                            },
                        ),
                      ],
                    ),
                  ),

                  //sign-up button
                  SizedBox(height: screenHeight * 0.015,),
                  isLoading
                      ? CircularProgressIndicator()
                      : customButton(
                    text: "Sign Up",
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (disabling == false) {
                        // Start loading
                        setState(() {
                          isLoading = true;
                        });
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //password doesn't match with confirmation password
                          if (passwordController.text.trim() != conpasswordController.text.trim()) {
                            custSnackbar(context, "Password doesn't match !", Colors.redAccent, Icons.close, Colors.white );
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            //check email if meron na sa database

                            var map = Map<String, dynamic>();
                            //get the action do by the user transfer it to POST method
                            map['action'] = "CHECK EMAIL";
                            map['email'] = emailController.text.trim();

                            var res = await http.post( //pasiing value to result
                              Uri.parse(API.register),
                              body: map,
                            );

                            if (res.statusCode == 200) { //from flutter app the connection with API to server  - success
                              var resBodyOfSignUp = jsonDecode(res.body);

                              //if email is already taken
                              if (resBodyOfSignUp['email_taken'] == true) {
                                custSnackbar(context, "Warning : Email is already taken.", Colors.orange, Icons.info, Colors.white );
                              } else {
                                myauth.setConfig(
                                  appEmail: "ronfrancia.enye@gmail.com",
                                  appName: "ENYECONTROLS",
                                  userEmail: emailController.text,
                                  otpLength: 6,
                                  otpType: OTPType.digitsOnly,
                                );
                                if (await myauth.sendOTP() == true) {
                                  custSnackbar(context, "OTP has been sent", Colors.green, Icons.check, Colors.greenAccent );
                                  _showOTPDialog();
                                } else {
                                  custSnackbar(context, "Oops, OTP send failed !", Colors.redAccent, Icons.dangerous_rounded, Colors.white );
                                }
                              }
                            }
                            // Stop loading after API response
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          // Stop loading if form validation fails
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                      _onButtonPressed();
                    },
                    clr: Colors.deepOrange,
                    fontSize: fontExtraSize,
                  ),

                  //already have an account
                  SizedBox(height: screenHeight * 0.008),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: fontSmallSize,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade800
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.002,),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Login now',
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

                  SizedBox(height: screenHeight * 0.1,),
                  if (isKeyboardVisible) SizedBox(height: screenHeight * 0.3,),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
