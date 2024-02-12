import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05,),
      body: Center(
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
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
                          radius: 64,
                          backgroundImage: FileImage(imagepath!),
                        )
                            : showimage != null && showimage != ""
                            ? CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(API.clientsImages + showimage!),
                        )
                            : const CircleAvatar(
                          radius: 64,
                          foregroundColor: Colors.deepOrange,
                          child: Icon(Icons.photo, color: Colors.deepOrange, size: 50,),
                        ),

                        disabling == false
                            ? const Positioned(bottom: 2, left: 90,child: Icon(Icons.add_a_photo, color: Colors.deepOrange,),)
                            : const SizedBox.shrink(),
                      ],
                    ),
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
                  padding: const EdgeInsets.only(top: 8.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.yellow.shade700,
                        child: Icon(Icons.edit, color: Colors.yellowAccent, size: 21,),
                      ),
                    ],
                  ),
                )
            )
                : Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      editInfo();
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.save, color: Colors.greenAccent, size: 21,),
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
                      radius: 24,
                      backgroundColor: Colors.red.shade600,
                      child: Icon(Icons.close, color: Colors.white, size: 21,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

