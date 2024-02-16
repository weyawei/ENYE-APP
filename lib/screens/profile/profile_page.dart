import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ProfilePage()
    );
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //text editing controllers
  final nameController = TextEditingController();
  final compnameController = TextEditingController();
  final locationController = TextEditingController();
  final projnameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool disabling = true;

  bool _isUpdating = false;

  File? imagepath;
  String? imagename;
  String? imagedata;
  String? showimage;
  ImagePicker imagePicker = ImagePicker();


  bool? userSessionFuture;

  clientInfo? ClientInfo;

  void initState(){
    super.initState();

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
          });
          _showValues(ClientInfo!);
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });
  }

  Future<void> selectImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagepath = File(getimage!.path);
      imagename = getimage.path.split('/').last;
      imagedata = base64Encode(imagepath!.readAsBytesSync());
      print(imagepath);
    });
  }

  checkUpdatedSession(){
    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
          });
          _showValues(ClientInfo!);
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });
  }

  //snackbars
  _custSnackbar(context, message, Color color, IconData iconData){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
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
    );
  }

  _showValues(clientInfo ClientInfo){
    showimage = ClientInfo.image;
    nameController.text = ClientInfo.name;
    compnameController.text = ClientInfo.company_name;
    locationController.text = ClientInfo.location;
    projnameController.text = ClientInfo.project_name;
    contactController.text = ClientInfo.contact_no;
    emailController.text = ClientInfo.email;
  }

  Future<void> editInfo() async {
    setState(() {
      _isUpdating = true;
    });
    if (_formKey.currentState!.validate()) {
      //kapag same picture disregard lang
      if (imagepath == null) {
        imagename = showimage;
        imagedata = '';
      }

      var res = await http.post( //pasiing value to result
        Uri.parse(API.editClientInfo),
        body: {
          'client_id' : ClientInfo?.client_id.toString(),
          'name' : nameController.text.trim(),
          'company' : compnameController.text.trim(),
          'location' : locationController.text.trim(),
          'project' : projnameController.text.trim(),
          'contact' : contactController.text.trim(),
          'email' : emailController.text.trim(),
          'imagename' : imagename,
          'imagedata' : imagedata,
        },
      );

      if (res.statusCode == 200) { //from flutter app the connection with API to server  - success
        var resBodyOfSignUp = jsonDecode(res.body);

        //if email is already taken
        if (resBodyOfSignUp['email_taken'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
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
          _formKey.currentState?.reset();
        } else
        if (resBodyOfSignUp['editClientInfo'] == true) { //registration success
          await SessionManager().set("client_data",  clientInfo(
              client_id: ClientInfo!.client_id.toString(),
              name: nameController.text,
              company_name: compnameController.text,
              location: locationController.text,
              project_name: projnameController.text,
              contact_no: contactController.text,
              image: imagename.toString(),
              email: emailController.text,
              login: ClientInfo!.login.toString()
          ));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              content: Row(
                children: [
                  Icon(Icons.check, color: Colors.greenAccent,),
                  const SizedBox(width: 10,),
                  Text("User Information edited successfully."),
                ],
              ),
            ),
          );
          setState(() {
            _isUpdating = false;
            disabling = true;
            imagepath = null;
            checkUpdatedSession();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar( //registration failed
            const SnackBar(
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              content: Row(
                children: [
                  Icon(Icons.close, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text("Error occured!"),
                ],
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> deleteClient() async {
    var res = await http.post( //pasiing value to result
      Uri.parse(API.deleteClientInfo),
      body: {
        'client_id' : ClientInfo?.client_id.toString(),
      },
    );

    if (res.statusCode == 200) { //from flutter app the connection with API to server  - success
      var resBodyOfSignUp = jsonDecode(res.body);

      //if email is already taken
      if (resBodyOfSignUp['deleteClientInfo'] == true) {
        dynamic token = await SessionManager().get("token");

        await SessionManager().remove("client_data");
        await FirebaseServices().signOut();

        //clear the client_id in a token
        TokenServices.updateToken(token.toString(), "").then((result) {
          if('success' == result){
            print("Updated token successfully");
          } else {
            print("Error updating token");
          }
        });

        setState(() {
          userSessionFuture = false;
          ClientInfo = null; // Clear the client info
          Navigator.of(context).pop();
        });
      } else {
        _custSnackbar(context, "Error occured!", Colors.redAccent, Icons.dangerous_rounded);
      }
    } else {
      _custSnackbar(context, "Error occured!!", Colors.redAccent, Icons.dangerous_rounded);
    }
  }

  Future<void> deleteGmail() async {
    await FirebaseServices().signInWithGoogle();
    FirebaseAuth.instance.currentUser!.delete();
    await SessionManager().remove("client_data");
    await FirebaseServices().signOut();

    Navigator.of(context).pop();
  }

  Future<void> deleteApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Use the credential to sign in or create a user account with Firebase
    final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    final AuthCredential appleCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    // Sign in with Firebase using the Apple credentials
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(appleCredential);
    final User user = userCredential.user!;

    user.delete();
    await SessionManager().remove("client_data");
    await FirebaseServices().signOut();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: Center(
        child: ClientInfo?.login == "SIGNIN"
         ? ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02,),
                    InkWell(
                      onTap: (){
                        if(disabling != true){
                          selectImage();
                        }
                      },
                      child: Stack(
                        children: [
                          imagepath != null
                              ? CircleAvatar(
                            radius: (screenHeight + screenWidth) / 18,
                            backgroundImage: FileImage(imagepath!),
                          )
                              : showimage != null && showimage != ""
                              ? CircleAvatar(
                            radius: (screenHeight + screenWidth) / 18,
                            backgroundImage: NetworkImage(API.clientsImages + showimage!),
                          )
                              : CircleAvatar(
                            radius: (screenHeight + screenWidth) / 18,
                            foregroundColor: Colors.deepOrange,
                            child: Icon(Icons.photo, color: Colors.deepOrange, size: (screenHeight + screenWidth) / 18,),
                          ),

                          disabling == false
                              ? const Positioned(bottom: 2, left: 90,child: Icon(Icons.add_a_photo, color: Colors.deepOrange,),)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),

                    //fullname textfield
                    SizedBox(height: screenHeight * 0.02,),
                    PersonNameTextField(
                      controller: nameController,
                      hintText: 'Fullname',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.01,),
                    NormalTextField(
                      controller: compnameController,
                      hintText: 'Company Name',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.01,),
                    NormalTextField(
                      controller: locationController,
                      hintText: 'Location',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.01,),
                    NormalTextField(
                      controller: projnameController,
                      hintText: 'Project Name',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.01,),
                    Contact2TextField(
                      controller: contactController,
                      hintText: 'Contact # (09xxxxxxxxx)',
                      disabling: disabling,
                    ),

                    //email textfield
                    SizedBox(height: screenHeight * 0.01,),
                    EmailTextField(
                      controller: emailController,
                      hintText: 'Email',
                      disabling: disabling,
                    ),

                  ],
                ),
              ),

              //edit cancel save
              _isUpdating == false
                  ? GestureDetector(
                  onTap: (){
                    setState(() {
                      _isUpdating = true;
                      disabling = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02, right: screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: (screenHeight + screenWidth) / 45,
                          backgroundColor: Colors.yellow.shade700,
                          child: Icon(Icons.edit, color: Colors.yellowAccent, size: (screenHeight + screenWidth) / 50,),
                        ),
                      ],
                    ),
                  )
              )
                  : Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02, right: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        editInfo();
                      },
                      child: CircleAvatar(
                        radius: (screenHeight + screenWidth) / 45,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.save, color: Colors.greenAccent, size: (screenHeight + screenWidth) / 50,),
                      ),
                    ),

                    SizedBox(width: 15,),

                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _isUpdating = false;
                          disabling = true;
                          imagepath = null;
                          _showValues(ClientInfo!);
                        });
                      },
                      child: CircleAvatar(
                        radius: (screenHeight + screenWidth) / 45,
                        backgroundColor: Colors.red.shade600,
                        child: Icon(Icons.close, color: Colors.white, size: (screenHeight + screenWidth) / 50,),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
                child: customButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'ACCOUNT DELETION',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rowdies(
                            textStyle: TextStyle(
                                fontSize: fontExtraSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                letterSpacing: 0.8
                            ),
                          ),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Are you sure to delete your account?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: fontNormalSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'CANCEL',
                              style: GoogleFonts.rowdies(
                                textStyle: TextStyle(
                                    fontSize: fontExtraSize,
                                    color: Colors.black54,
                                    letterSpacing: 0.8
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                deleteClient();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                              'YES',
                              style: GoogleFonts.rowdies(
                                textStyle: TextStyle(
                                    fontSize: fontExtraSize,
                                    color: Colors.redAccent,
                                    letterSpacing: 0.8
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  text: 'DELETE ACCOUNT',
                  clr: Colors.redAccent,
                  fontSize: fontExtraSize,
                ),
              ),
            ],
          )
         : ClientInfo?.login == "APPLE"
          ? ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02,),
                  InkWell(
                    onTap: (){
                      if(disabling != true){
                        selectImage();
                      }
                    },
                    child: Stack(
                      children: [
                        imagepath != null
                            ? CircleAvatar(
                          radius: (screenHeight + screenWidth) / 18,
                          backgroundImage: FileImage(imagepath!),
                        )
                            : showimage != null && showimage != ""
                            ? CircleAvatar(
                          radius: (screenHeight + screenWidth) / 18,
                          backgroundImage: NetworkImage(API.clientsImages + showimage!),
                        )
                            : CircleAvatar(
                          radius: (screenHeight + screenWidth) / 18,
                          foregroundColor: Colors.deepOrange,
                          child: Icon(Icons.photo, color: Colors.deepOrange, size: (screenHeight + screenWidth) / 18,),
                        ),

                        disabling == false
                            ? const Positioned(bottom: 2, left: 90,child: Icon(Icons.add_a_photo, color: Colors.deepOrange,),)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),

                  //fullname textfield
                  SizedBox(height: screenHeight * 0.02,),
                  EmailTextField(
                    controller: emailController,
                    hintText: 'Email',
                    disabling: disabling,
                  ),

                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
                child: customButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'ACCOUNT DELETION',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rowdies(
                            textStyle: TextStyle(
                                fontSize: fontExtraSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                letterSpacing: 0.8
                            ),
                          ),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Are you sure to delete your account?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: fontNormalSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'CANCEL',
                              style: GoogleFonts.rowdies(
                                textStyle: TextStyle(
                                    fontSize: fontExtraSize,
                                    color: Colors.black54,
                                    letterSpacing: 0.8
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                deleteApple();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                              'YES',
                              style: GoogleFonts.rowdies(
                                textStyle: TextStyle(
                                    fontSize: fontExtraSize,
                                    color: Colors.redAccent,
                                    letterSpacing: 0.8
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  text: 'DELETE ACCOUNT',
                  clr: Colors.redAccent,
                  fontSize: fontExtraSize,
                ),
              ),
            ],
          )
          : ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.02,),
                InkWell(
                  onTap: (){
                    if(disabling != true){
                      selectImage();
                    }
                  },
                  child: Stack(
                    children: [
                      imagepath != null
                          ? CircleAvatar(
                        radius: (screenHeight + screenWidth) / 18,
                        backgroundImage: FileImage(imagepath!),
                      )
                          : showimage != null && showimage != ""
                          ? CircleAvatar(
                        radius: (screenHeight + screenWidth) / 18,
                        backgroundImage: Image.network("${ClientInfo?.image}").image,
                      )
                          : CircleAvatar(
                        radius: (screenHeight + screenWidth) / 18,
                        foregroundColor: Colors.deepOrange,
                        child: Icon(Icons.photo, color: Colors.deepOrange, size: (screenHeight + screenWidth) / 18,),
                      ),

                      disabling == false
                          ? const Positioned(bottom: 2, left: 90,child: Icon(Icons.add_a_photo, color: Colors.deepOrange,),)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),

                //fullname textfield
                SizedBox(height: screenHeight * 0.02,),
                PersonNameTextField(
                  controller: nameController,
                  hintText: 'Name',
                  disabling: disabling,
                ),

                //fullname textfield
                SizedBox(height: screenHeight * 0.02,),
                EmailTextField(
                  controller: emailController,
                  hintText: 'Email',
                  disabling: disabling,
                ),

              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
              child: customButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'ACCOUNT DELETION',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rowdies(
                          textStyle: TextStyle(
                              fontSize: fontExtraSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              letterSpacing: 0.8
                          ),
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Are you sure to delete your account?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: fontNormalSize,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.rowdies(
                              textStyle: TextStyle(
                                  fontSize: fontExtraSize,
                                  color: Colors.black54,
                                  letterSpacing: 0.8
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              deleteGmail();
                              Navigator.of(context).pop();
                            });
                          },
                          child: Text(
                            'YES',
                            style: GoogleFonts.rowdies(
                              textStyle: TextStyle(
                                  fontSize: fontExtraSize,
                                  color: Colors.redAccent,
                                  letterSpacing: 0.8
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                text: 'DELETE ACCOUNT',
                clr: Colors.redAccent,
                fontSize: fontExtraSize,
              ),
            ),
          ],
        )
      ),
    );
  }
}

