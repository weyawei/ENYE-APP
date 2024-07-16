import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:enye_app/config/api_connection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isShowingErrorSnackbar = false; // Flag to track if error snackbar is already being displayed

  _custSnackbar(context, message, Color color, IconData iconData){

    if (_isShowingErrorSnackbar) return; // If error snackbar is already visible, do nothing
    _isShowingErrorSnackbar = true; // Set the flag to indicate that error snackbar is being shown

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: (screenHeight + screenWidth) / 75,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Text(
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
          ],
        ),
      ),
    ).closed.then((_) {
      // After snackbar is closed, reset the flag
      _isShowingErrorSnackbar = false;
    });
  }

  _successSnackbar(context, message){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.greenAccent,
              size: (screenHeight + screenWidth) / 75,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Text(
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
          ],
        ),
      ),
    ).closed.then((value) => Navigator.of(context).pop());
  }

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

  //close the keyboard if nakalabas
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
        _custSnackbar(
          context,
          "Error occured !",
          Colors.redAccent,
          Icons.dangerous_rounded
        );
      }
    }
  }

  void _showOTPDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

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

        return Dialog(
          // Set dialog properties such as shape, elevation, etc.
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Kindly check the email provided",
                    style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    emailController.text,
                    style: TextStyle(fontSize: fontExtraSize, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Please enter the OTP CODE to verify,",
                    style: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold),
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
                    Navigator.of(context).pop(); // Close the dialog
                    if (await myauth.verifyOTP(otp: pin.text)) {
                      signUserUp();
                    } else {
                      _custSnackbar(
                          context,
                          "Invalid OTP !",
                          Colors.redAccent,
                          Icons.dangerous_rounded
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.deepOrangeAccent,
                    child: Center(
                      child: Text(
                        "Verify",
                        style: TextStyle(
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontSize: fontExtraSize
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
                              _launchURL("https://www.enyecontrols.com/privacypolicy/terms.html");
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
                              _launchURL("https://www.enyecontrols.com/privacypolicy/policy.html");
                            },
                        ),
                      ],
                    ),
                  ),

                  //sign-up button
                  SizedBox(height: screenHeight * 0.015,),
                  customButton(
                    text: "Sign Up",
                    onTap: () async {
                      if (disabling == false) {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //password doesn't match with confirmation password
                          if (passwordController.text.trim() != conpasswordController.text.trim()) {
                            _custSnackbar(
                                context,
                                "Password doesn't match !",
                                Colors.redAccent,
                                Icons.dangerous_rounded
                            );
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
                                _custSnackbar(
                                    context,
                                    "Warning: Email is already taken.",
                                    Colors.orangeAccent,
                                    Icons.info
                                );
                              } else {
                                myauth.setConfig(
                                  appEmail: "ronfrancia.enye@gmail.com",
                                  appName: "ENYE CONTROLS",
                                  userEmail: emailController.text,
                                  otpLength: 6,
                                  otpType: OTPType.digitsOnly,
                                );
                                if (await myauth.sendOTP() == true) {
                                  _custSnackbar(
                                      context,
                                      "OTP has been sent",
                                      Colors.green,
                                      Icons.check_box
                                  );
                                  _showOTPDialog();
                                } else {
                                  _custSnackbar(
                                      context,
                                      "Oops, OTP send failed !",
                                      Colors.redAccent,
                                      Icons.dangerous_rounded
                                  );
                                }
                              }
                            }
                          }
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
