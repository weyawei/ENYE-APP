import 'dart:convert';

import 'package:enye_app/config/api_connection.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final conpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = false;

  Future<void> signUserUp() async {

    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {

      //password doesn't match with confirmation password
      if (passwordController.text.trim() != conpasswordController.text.trim()){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
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
        //useradmin.dart transfering to json
        /*userAdmin userAdminModel = userAdmin(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        var res = await http.post( //pasiing value to result
          Uri.parse(API.register),
          body: userAdminModel.toJson(),
        );

        if (res.statusCode == 200){ //from flutter app the connection with API to server  - success
          var resBodyOfSignUp = jsonDecode(res.body);

          //if email is already taken
          if(resBodyOfSignUp['email_taken'] == true){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange,),
                    const SizedBox(width: 10,),
                    Text("Warning: Email is already taken."),
                  ],
                ),
              ),
            );
            _formKey.currentState?.reset();

          } else if(resBodyOfSignUp['user_add'] == true){ //registration success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.greenAccent,),
                    const SizedBox(width: 10,),
                    Text("Congratulations, SignUp Successfully."),
                  ],
                ),
              ),
            );
            _formKey.currentState?.reset();
          } else {
            ScaffoldMessenger.of(context).showSnackBar( //registration failed
              const SnackBar(
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
        }*/
      }

    }
  }

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
                    controller: null,
                    hintText: 'Company Name',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: null,
                    hintText: 'Location',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: null,
                    hintText: 'Project Name',
                    disabling: disabling,
                  ),

                  const SizedBox(height: 10,),
                  NormalTextField(
                    controller: null,
                    hintText: 'Contact No',
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
                    onTap: signUserUp,
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
                          Navigator.of(context).popUntil(ModalRoute.withName("/login"));
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
