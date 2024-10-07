import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../widget/widgets.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  bool disabling = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> submitFeedback() async {
    FocusScope.of(context).unfocus();

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    setState(() {
      disabling = true;
      isLoading = true;  // Show the loading screen
    });

    dynamic token = await SessionManager().get("token");

    var res = await http.post( //pasiing value to result
      Uri.parse(API.feedback),
      body: {
        'fullname' : nameController.text.trim(),
        'email' : emailController.text.trim(),
        'company' : companyController.text.trim(),
        'subject' : subjectController.text.trim(),
        'message' : messageController.text.trim(),
        'token' : token.toString(),
      },
    );

    if (res.statusCode == 200){
      if(res.body == 'success'){
        showSnackbar(
            context: context,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            fontSize: fontNormalSize,
            message: "Your feedback has been successfully submitted.\nOur team will review it and contact you via email shortly.",
            bkColor: Colors.green,
            icon: Icons.check,
            isShowingErrorSnackbar: false,
            duration: 3
        );

        clearFields();
        setState(() {
          disabling = false;
          isLoading = false;
        });
      } else {
        // Show success snackbar and navigate
        setState(() {
          disabling = false;
          isLoading = false;
        });
        showSnackbar(
            context: context,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            fontSize: fontNormalSize,
            message: "Error occurred.",
            bkColor: Colors.redAccent,
            icon: Icons.dangerous_rounded,
            isShowingErrorSnackbar: false,
            duration: 3
        );
      }
    } else {
      setState(() {
        disabling = false;
        isLoading = false;
      });
      showSnackbar(
          context: context,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          fontSize: fontNormalSize,
          message: "Error occurred.",
          bkColor: Colors.redAccent,
          icon: Icons.dangerous_rounded,
          isShowingErrorSnackbar: false,
          duration: 3
      );
    }
  }

  clearFields(){
    nameController.clear();
    emailController.clear();
    companyController.clear();
    subjectController.clear();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
        return Scaffold(
          backgroundColor: Colors.deepOrange.shade200,
          // appBar: CustomAppBar(
          //   title: 'Feedback Form',
          //   imagePath: '',
          //   appBarHeight: screenHeight * 0.05,
          // ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: screenHeight * 0.035,),
                    Image(
                      image: AssetImage('assets/icons/feedback.png'),
                      height: fontXXXSize * 3.5,
                      width: fontXXXSize * 3.5,
                    ),
                    SizedBox(height: screenHeight * 0.01,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bug_report_outlined,
                                size: fontNormalSize * 2,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Report a bug",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.6,
                                      fontSize: fontSmallSize,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Something is broken?\nLet us know!",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white.withOpacity(0.75),
                                      letterSpacing: 0.6,
                                      fontSize: fontSmallSize * 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.075), // Added space to help with spacing
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  size: fontNormalSize * 1.75,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Suggest improvements",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.6,
                                          fontSize: fontSmallSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "What could we do better?",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white.withOpacity(0.75),
                                          letterSpacing: 0.6,
                                          fontSize: fontSmallSize * 0.8,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.035,),
                    PersonNameTextField(
                      controller: nameController,
                      hintText: 'Fullname',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.015,),
                    EmailTextField(
                      controller: emailController,
                      hintText: 'example@sample.com',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.015,),
                    CompanyTextField(
                      controller: companyController,
                      hintText: 'Company Name',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.015,),
                    NormalTextField(
                      controller: subjectController,
                      hintText: 'Subject',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.015,),
                    TextAreaField(
                      controller: messageController,
                      hintText: 'Messages/Concern',
                      disabling: disabling,
                    ),

                    SizedBox(height: screenHeight * 0.02,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: customButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (disabling == false) {
                              submitFeedback();
                            }
                          } else {
                            print('Form validation failed');
                          }
                        },
                        text: 'SUBMIT',
                        clr: Colors.deepOrange,
                        fontSize: fontExtraSize,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02,),
                    if (isKeyboardVisible) SizedBox(height: screenHeight * 0.4,),
                  ],
                ),
              ),

              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5), // Optional overlay
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
}
