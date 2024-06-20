import 'package:enye_app/config/app_checksession.dart';
import 'package:flutter/material.dart';
import 'package:enye_app/screens/services/survey_data.dart';
import 'package:enye_app/screens/services/survey_svc.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // Import for utf8 encoding
import '../../widget/responsive_text_utils.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  List<TextEditingController> answersController = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchToken();
    _getSurvey();
    _getChoices();
  }

  Future<void> _fetchToken() async {
    String fetchedToken = await checkSession().getToken();
    setState(() {
      token = Uri.encodeComponent(fetchedToken); // URL-encode the token
    });
    print('Fetched Token: $token');
  }

  List<Survey> _survey = [];
  _getSurvey() {
    SurveyDataServices.getSurvey().then((survey) {
      setState(() {
        _survey = survey;
      });

      answersController = List.generate(_survey.length, (index) => TextEditingController());
    });
  }

  List<SurveyChoices> _choices = [];
  _getChoices() {
    SurveyDataServices.getSurveyChoices().then((choices) {
      setState(() {
        _choices = choices;
      });
    });
  }


  _custSnackbar(context, message, Color color, IconData iconData){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.82),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: fontNormalSize * 1.8,
            ),
            SizedBox(width: screenWidth * 0.03,),
            Expanded(
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.start,
                text: TextSpan(children: <TextSpan>
                [
                  TextSpan(
                    text: message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.white
                      ),
                    ),
                  ),
                ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _addSurvey() async {
    if (token.isEmpty) {
      await _fetchToken();
    }
    print('User Token Response: ${token.toString()}');

    // Collect survey responses
    List<Map<String, dynamic>> responses = _survey.map((survey) {
      final selectedChoices = _choices
          .where((choice) => choice.sq_id == survey.sq_id && choice.isSelected)
          .map((choice) => choice.choices)
          .toList();

      String selectedChoicesStr = selectedChoices.join(', ');

      return {
        'token': token.toString(), //survey.sq_id
        'question': survey.sq_id,
        'selectedChoices': selectedChoicesStr.isEmpty ? commentController.text : selectedChoicesStr,
      };
    }).toList();

    responses.forEach((response) {
      SurveyDataServices.addSurvey(
        response['token']!,
        response['question']!,
        response['selectedChoices']!,
      ).then((result) {
        if (result.contains("Successfully saved !")) {
          _custSnackbar(
              context,
              "Successfully saved !",
              Colors.green,
              Icons.check_box
          );
        }
      });
    });
  }



  Future<void> _addUserInfo() async {
    if (token.isEmpty) {
      await _fetchToken();
    }

    print('User Token Response: ${token.toString()}');
    List<Map<String, String>> surveyData = collectSurveyData();

      SurveyDataServices.addUserInfo(

        token.toString(), nameController.text, companyNameController.text, designationController.text, emailController.text,
        contactNumberController.text, surveyData

      ).then((result) {
        print(result);
      });
  }

  String getSelectedChoices(String sqId) {
    return _choices.where((choice) => choice.sq_id == sqId && choice.isSelected).map((choice) => choice.choices).join(', ');
  }

  List<Map<String, String>> collectSurveyData() {
    List<Map<String, String>> surveyData = [];
    for (int i = 0; i < _survey.length; i++) {
      surveyData.add({
        'sq_id': _survey[i].sq_id,
        'question': _survey[i].question,
        'answer': answersController[i].text,
      });
    }
    return surveyData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.all(8.0)),
                  Text(
                    'We are developing a mobile app to enhance our service and make it easier for you to interact with us. Your feedback is essential to ensure we meet your needs effectively.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name (Optional)',
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(
                      labelText: 'Company Name (Optional)',
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  TextFormField(
                    controller: designationController,
                    decoration: InputDecoration(
                      labelText: 'Designation (Optional)',
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address (Optional)',
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                  TextFormField(
                    controller: contactNumberController,
                    decoration: InputDecoration(
                      labelText: 'Contact Number (Optional)',
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            Divider(), // Divider between user information and survey questions
            // Survey Questions Section
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _survey.length,
              itemBuilder: (context, index) {
                final survey = _survey[index];
                final filteredChoices = _choices.where((choice) => choice.sq_id == survey.sq_id).toList();

                if (filteredChoices.isEmpty) {
                  // Render an essay question with a TextFormField
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              survey.question,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: answersController[index],
                              maxLines: 3, // Adjust the number of lines for the answer input
                              decoration: InputDecoration(
                                hintText: 'Write your answer here',
                                contentPadding: EdgeInsets.all(12.0),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                // Optionally handle onChanged if needed
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Render a checkbox question with CheckboxListTile
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              survey.question,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ...filteredChoices.map((choice) {
                              return CheckboxListTile(
                                title: Text(choice.choices),
                                value: choice.isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    choice.isSelected = value ?? false;
                                    answersController[index].text = getSelectedChoices(survey.sq_id);
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(padding: const EdgeInsets.all(15),
            child: Text("Thank you for providing valuable feedback. Your input will help us create an app that best serves your needs.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold
              ),
            ),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle submission of selected options and user information
          // Example: Printing the user information
          print('Name: ${nameController.text}');
          print('Company Name: ${companyNameController.text}');
          print('Designation: ${designationController.text}');
          print('Email Address: ${emailController.text}');
          print('Contact Number: ${contactNumberController.text}');

          List<Map<String, String>> surveyData = collectSurveyData();
          print(surveyData);

          _addUserInfo();
          // _addSurvey();
          // Add logic to save or process the selected options and user information
        },
        child: Icon(Icons.check),
      ),


    );
  }

  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    companyNameController.dispose();
    designationController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    for (var controller in answersController) {
      controller.dispose();
    }
    answersController.clear(); // Optionally clear the list
    super.dispose();
  }
}
