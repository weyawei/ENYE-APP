import 'dart:convert';
import 'package:enye_app/screens/service/ec_technical_data.dart';
import 'package:enye_app/screens/services/survey_data.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../screens.dart';

class SurveyDataServices {
  //this is same as in PHP code action made by the user CRUD

  static const GET_ALL_SURVEY = 'get_all_survey';
  static const GET_ALL_SURVEYCHOICES = 'get_all_surveyChoices';
  static const ADD_SURVEY = 'add_survey';
  static const ADD_USERINFO = 'add_userinfo';
  static const USER_SURVEY = 'user_survey';

  static Future <List<Survey>> getSurvey() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_SURVEY;

    //get all data of categories
    final res = await http.post(Uri.parse(API.survey), body: map); //passing value to result
    print('get Survey Response: ${res.body}');

    if(res.statusCode == 200){
      List<Survey> list = parseSurvey(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcUsers');
      //return List<Categories>();
    }

  }

  static List<Survey> parseSurvey(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Survey>((json) => Survey.fromJson(json)).toList();
  }



  static Future <List<SurveyChoices>> getSurveyChoices() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_SURVEYCHOICES;

    //get all data of categories
    final res = await http.post(Uri.parse(API.survey), body: map); //passing value to result
    print('get Survey Choices Response: ${res.body}');

    if(res.statusCode == 200){
      List<SurveyChoices> list = parseSurveyChoices(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcUsers');
      //return List<Categories>();
    }

  }

  static List<SurveyChoices> parseSurveyChoices(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<SurveyChoices>((json) => SurveyChoices.fromJson(json)).toList();
  }


  static Future<String> addSurvey(String token_id, String question, String choices) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = ADD_SURVEY;
      map['token_id'] = token_id;
      map['question'] = question;
      map['choices'] = choices;

      final res = await http.post(Uri.parse(API.survey), body: map); //passing value to result
      print('Add Survey Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }


  static Future<String> addUserInfo(String token_id, String name, String company_name, String designation, String email, String contact_no, List<Map<String, String>> surveyData) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = USER_SURVEY;
      map['token_id'] = token_id;
      map['name'] = name;
      map['company_name'] = company_name;
      map['designation'] = designation;
      map['email'] = email;
      map['contact_no'] = contact_no;
      map['survey_data'] = jsonEncode(surveyData);

      final res = await http.post(
        Uri.parse(API.survey), // replace with actual API endpoint
        body: map,
      );
      print('Add User Info Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

}