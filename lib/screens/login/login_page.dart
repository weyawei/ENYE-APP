import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';
import '../../config/api_firebase.dart';
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

  Future<void> signUserIn() async {

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      dynamic token = await SessionManager().get("token");

      var res = await http.post( //pasiing value to result
        Uri.parse(API.login),
        body: {
          'email' : emailController.text.trim(),
          'password' : passwordController.text.trim(),
          'token' : token.toString(),
        },
      );

      if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
        var resBodyOfLogin = jsonDecode(res.body);

        if(resBodyOfLogin['login'] == true){

          var clientData = resBodyOfLogin["clients_data"];
          await SessionManager().set("client_data",  clientInfo(
              client_id: clientData["client_id"],
              name: clientData["name"],
              company_name: clientData["company_name"],
              location: clientData["location"],
              project_name: clientData["project_name"],
              contact_no: clientData["contact_no"],
              image: clientData["image"],
              email: clientData["email"]
          ));

          setState(() {
            disabling = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.greenAccent,),
                    const SizedBox(width: 10,),
                    Text("Congratulations, Login Successfully."),
                  ],
                ),
              ),
            ).closed.then((value) => Navigator.pop(context));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
              content: Row(
                children: [
                  Icon(Icons.close, color: Colors.white,),
                  const SizedBox(width: 10,),
                  Text("Incorrect email or password !"),
                ],
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade200,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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

              //email textfield
              SizedBox(height: 25,),
              EmailTextField(
                controller: emailController,
                hintText: 'Email',
                disabling: disabling,
              ),

              //password textfield
              SizedBox(height: 10,),
              PasswordTextField(
                controller: passwordController,
                hintText: 'Password',
                disabling: disabling,
              ),

              //forgot password
              /*Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (){},
                      child: Text('Forgot Password?', style: TextStyle(color: Colors.grey.shade800,),),
                    ),
                  ],
                ),
              ),*/

              //sign-in button
              SizedBox(height: 20,),
              customButton(
                text: "SIGN IN",
                onTap: (){
                  if (disabling == false) {
                    signUserIn();
                  }
                  _onButtonPressed();
                },
                clr: Colors.deepOrange,
                fontSize: 18.0,
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
              /*SizedBox(height: 25,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/icons/gmail.png'), height: 40, width: 40),
                  SizedBox(width: 25,),
                  Image(image: AssetImage('assets/icons/facebook-v2.png'), height: 40, width: 40,),
                ],
              ),*/

              //not a member sign up
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?', style: TextStyle(color: Colors.grey.shade800),),
                  const SizedBox(height: 4,),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => registerPage())).then((value) { setState(() {}); });
                    },
                    child: Text(
                      'Register now',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Center(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}


