import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:enye_app/config/api_connection.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

  //close the keyboard if nakalabas
  void _onButtonPressed() {
    FocusScope.of(context).unfocus(); // Close the keyboard
  }

  checkEmail () async {

  }

  Future<void> signUserUp() async {
    //useradmin.dart transfering to json

    var map = Map<String, dynamic>();
    //get the action do by the user transfer it to POST method
    map['action'] = "SIGN UP";
    map['name'] = nameController.text.trim();
    map['company_name'] = compnameController.text.trim();
    map['location'] = locationController.text.trim();
    map['project_name'] = projnameController.text.trim();
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
            content: Row(
              children: [
                Icon(Icons.check, color: Colors.greenAccent,),
                const SizedBox(width: 10,),
                Text("OTP is verified! Congratulations, SignUp Successfully."),
              ],
            ),
          ),
        ).closed.then((value) => Navigator.of(context).pop());
      } else {
        ScaffoldMessenger.of(context).showSnackBar( //registration failed
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
            content: Row(
              children: [
                Icon(Icons.close, color: Colors.white,),
                const SizedBox(width: 10,),
                Text("Error occured!"),
              ],
            ),
          ),
        );
      }
    }
  }

  void _showOTPDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final defaultPinTheme = PinTheme(
          width: 56,
          height: 56,
          textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    emailController.text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Please enter the OTP CODE to verify,",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                          content: Row(
                            children: [
                              Icon(Icons.close, color: Colors.white,),
                              const SizedBox(width: 10,),
                              Text("Invalid OTP !"),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.deepOrangeAccent,
                    child: Center(
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


  TextEditingController pin = TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/icons/enye.png"), fit: BoxFit.fill)
                    ),
                  ),

                  //lets create an account for you
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Let's create an account for you!", style: TextStyle(color: Colors.grey.shade800, fontSize: 18),),
                  ),

                  //fullname textfield
                  const SizedBox(height: 25,),
                  PersonNameTextField(
                    controller: nameController,
                    hintText: 'Fullname',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: compnameController,
                    hintText: 'Company Name',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: locationController,
                    hintText: 'Location',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: projnameController,
                    hintText: 'Project Name',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  Contact2TextField(
                    controller: contactController,
                    hintText: 'Contact # (09xxxxxxxxx)',
                    disabling: disabling,
                  ),

                  //email textfield
                  const SizedBox(height: 10,),
                  EmailTextField(
                    controller: emailController,
                    hintText: 'Email',
                    disabling: disabling,
                  ),

                  //password textfield
                  const SizedBox(height: 10,),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    disabling: disabling,
                  ),

                  //confirm password textfield
                  const SizedBox(height: 10,),
                  PasswordTextField(
                    controller: conpasswordController,
                    hintText: 'Confirm Password',
                    disabling: disabling,
                  ),

                  //sign-up button
                  const SizedBox(height: 25,),
                  customButton(
                    text: "Sign Up",
                    onTap: () async {
                      if (disabling == false) {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //password doesn't match with confirmation password
                          if (passwordController.text.trim() != conpasswordController.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                content: Row(
                                  children: [
                                    Icon(Icons.close, color: Colors.white,),
                                    const SizedBox(width: 10,),
                                    Text("Password doesn't match !"),
                                  ],
                                ),
                              ),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.orangeAccent,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(4))),
                                    content: Row(
                                      children: [
                                        Icon(Icons.info, color: Colors.orange,),
                                        const SizedBox(width: 10,),
                                        Text("Warning: Email is already taken."),
                                      ],
                                    ),
                                  ),
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
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("OTP has been sent"),
                                  ));
                                  _showOTPDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Oops, OTP send failed"),
                                  ));
                                }
                              }
                            }
                          }
                        }
                      }
                      _onButtonPressed();
                    },
                    clr: Colors.deepOrange,
                    fontSize: 19.0,
                  ),

                  //or continue with
                  /*const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade500,)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or continue with', style: TextStyle(color: Colors.grey.shade800,),),
                    ),
                    Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade500,)
                    ),
                  ],
                ),
              ),*/


                  //gmail + facebook sign in
                  /*const SizedBox(height: 25,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/icons/gmail.png'), height: 40, width: 40),
                  SizedBox(width: 25,),
                  Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),
                ],
              ),*/


                  //already have an account
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?', style: TextStyle(color: Colors.grey.shade800),),
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

                  const SizedBox(height: 60,),
                  if (isKeyboardVisible) SizedBox(height: MediaQuery.of(context).size.height * 0.4,),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
