import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class projectSVC {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_PROJCATEGORY = 'get_all_projcat';
  static const GET_ALL_PROJECTS = 'get_all_projects';


  //get data categories from database
  static Future <List<projCategories>> getProjCategory() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PROJCATEGORY;

      //get all data of categories
      final res = await http.post(Uri.parse(API.projects), body: map); //passing value to result
      print('getProjCategory Response: ${res.body}');

      if(res.statusCode == 200){
        List<projCategories> list = parseResponseProjCateg(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Project Categories');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Project Categories');
      //return List<Categories>();
    }
  }

  static List<projCategories> parseResponseProjCateg(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<projCategories>((json) => projCategories.fromJson(json)).toList();
  }

  static Future <List<Projects>> getProjects() async {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PROJECTS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.projects), body: map); //passing value to result
      print('getProjects Response: ${res.body}');

      if(res.statusCode == 200){
        List<Projects> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Project');
        //return List<Categories>();
      }
  }

  static List<Projects> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Projects>((json) => Projects.fromJson(json)).toList();
  }

}