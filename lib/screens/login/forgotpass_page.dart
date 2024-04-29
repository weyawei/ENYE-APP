import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';

class ForgotPassPage extends StatefulWidget {
  static const String routeName = '/forgotpass';

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ForgotPassPage()
    );
  }

  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();

}

class _ForgotPassPageState extends State<ForgotPassPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TextEditingController pin = TextEditingController();

  bool disabling = false;
  bool verified = false;
  EmailOTP myauth = EmailOTP();

  //snackbars
  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            const Icon(Icons.check, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            const Icon(Icons.close, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  //otp code verification
  void _showOTPDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // This prevents dialog from closing when tapping outside
      builder: (BuildContext context) {
        final defaultPinTheme = PinTheme(
          width: 56,
          height: 56,
          textStyle: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
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

        return WillPopScope(
          onWillPop: () async {
            // Disable back button press
            return false;
          },
          child: Dialog(
            // Set dialog properties such as shape, elevation, etc.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Kindly check the email provided",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    emailController.text,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Please enter the OTP CODE to verify,",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                      setState(() {
                        verified = true;
                        disabling = false;
                      });
                      _successSnackbar(context, "OTP has been verified! ✅");
                    } else {
                      setState(() {
                        disabling = false;
                        pin.clear();
                      });
                      _errorSnackbar(context, "Invalid OTP !");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.deepOrangeAccent,
                    child: const Center(
                      child: Text(
                        "Verify",
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

  //close the keyboard if nakalabas
  void _onButtonPressed() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  //change password
  Future<void> resetPassword() async {

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      //password doesn't match with confirmation password
      if (passwordController.text.trim() != conpasswordController.text.trim()){
        _errorSnackbar(context, "Password doesn't match !");
      } else {
        setState(() {
          disabling = true;
        });

        var map = Map<String, dynamic>();
        //get the action do by the user transfer it to POST method
        map['action'] = "RESET PASSWORD";
        map['email'] = emailController.text.trim();
        map['password'] = passwordController.text.trim();

        var res = await http.post( //pasiing value to result
          Uri.parse(API.resetPassword),
          body: map,
        );

        if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
          var resBodyOfSignUp = jsonDecode(res.body);

          //if email is already taken
          if(resBodyOfSignUp['reset_password'] == true){ //registration success
            _formKey.currentState?.reset();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.greenAccent,),
                    const SizedBox(width: 10,),
                    Text("Password successfully changed !"),
                  ],
                ),
              ),
            ).closed.then((value) => Navigator.of(context).pop());
          } else {
            setState(() {
              disabling = false;
            });
            _errorSnackbar(context, "Error occured!");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade200,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //logo application
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.33,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/icons/enye.png"), fit: BoxFit.fill)
                    ),
                  ),

                  //lets create an account for you
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Let's reset your password !", style: TextStyle(color: Colors.grey.shade800, fontSize: 18),),
                  ),

                  const SizedBox(height: 50,),
                  verified == true
                  ? Column(
                    children: [
                      //password textfield
                      PasswordTextField(
                        controller: passwordController,
                        hintText: 'New Password *',
                        disabling: disabling,
                      ),

                      //confirm password textfield
                      const SizedBox(height: 10,),
                      PasswordTextField(
                        controller: conpasswordController,
                        hintText: 'Confirm Password *',
                        disabling: disabling,
                      ),

                      //sign-up button
                      const SizedBox(height: 25,),
                      customButton(
                        onTap: () {
                          if (disabling == false) {
                            resetPassword();
                          }
                          _onButtonPressed();
                        },
                        text: 'RESET PASSWORD',
                        clr: Colors.deepOrange,
                        fontSize: 14.0,
                      ),
                    ],
                  )
                  : Column(
                    children: [
                      //email textfield
                      EmailTextField(
                        controller: emailController,
                        hintText: 'Email',
                        disabling: disabling,
                      ),

                      //sign-up button
                      const SizedBox(height: 25,),
                      customButton(
                        onTap: () async {
                          _onButtonPressed();
                          if (disabling == false) {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              disabling = true;
                              var map = Map<String, dynamic>();
                              //get the action do by the user transfer it to POST method
                              map['action'] = "CHECK EMAIL";
                              map['email'] = emailController.text.trim();

                              var res = await http.post( //pasiing value to result
                                Uri.parse(API.resetPassword),
                                body: map,
                              );

                              if (res.statusCode == 200) { //from flutter app the connection with API to server  - success
                                var resBodyOfSignUp = jsonDecode(res.body);

                                //if email is already taken
                                if (resBodyOfSignUp['email_taken'] == true) {
                                  myauth.setConfig(
                                    appEmail: "ronfrancia.enye@gmail.com",
                                    appName: "ENYE CONTROLS",
                                    userEmail: emailController.text,
                                    otpLength: 6,
                                    otpType: OTPType.digitsOnly,
                                  );
                                  if (await myauth.sendOTP() == true) {
                                    _successSnackbar(context, "OTP has been sent");
                                    _showOTPDialog();
                                  } else {
                                    _errorSnackbar(context, "Oops, OTP send failed");
                                    disabling = false;
                                  }
                                } else {
                                  _errorSnackbar(context, "Email NOT Found !");
                                  disabling = false;
                                }
                              }
                            }
                          }
                        },
                        text: "VERIFY EMAIL",
                        clr: Colors.deepOrange,
                        fontSize: 16.0
                      ),
                    ],
                  ),

                  //already have an account
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Remember your password ?', style: TextStyle(color: Colors.grey.shade800),),
                      const SizedBox(height: 4,),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Login now',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
