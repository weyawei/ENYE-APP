import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';
import '../screens.dart';

class systemService {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_SYSTEMS = 'get_all_systems';
  static const GET_ALL_SYSDETAILS = 'get_all_sysdetails';
  static const GET_ALL_SYSTECHSPECS = 'get_all_systechspecs';

  //get data categories from database
  static Future <List<Systems>> getSystems() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_SYSTEMS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.systems), body: map); //passing value to result
      print('getCategories Response: ${res.body}');

      if(res.statusCode == 200){
        List<Systems> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve categories');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve categories');
      //return List<Categories>();
    }
  }

  static List<Systems> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Systems>((json) => Systems.fromJson(json)).toList();
  }

  static Future <List<SystemsDetail>> getSysDetails(String system_id) async {

      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_SYSDETAILS;
      map['id'] = system_id;

      //get all data of categories
      final res = await http.post(Uri.parse(API.systems), body: map); //passing value to result
      print('getSysTechSpecs Response: ${res.body}');

      if(res.statusCode == 200){
        List<SystemsDetail> list = parseResSysDetails(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve categories');
      }

  }

  static List<SystemsDetail> parseResSysDetails(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<SystemsDetail>((json) => SystemsDetail.fromJson(json)).toList();
  }

  static Future <List<SystemsTechSpecs>> getSysTechSpecs(String system_id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_SYSTECHSPECS;
      map['id'] = system_id;

      //get all data of categories
      final res = await http.post(Uri.parse(API.systems), body: map); //passing value to result
      print('getSysTechSpecs Response: ${res.body}');

      if(res.statusCode == 200){
        List<SystemsTechSpecs> list = parseResSysTechSpecs(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve categories');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve categories');
      //return List<Categories>();
    }
  }

  static List<SystemsTechSpecs> parseResSysTechSpecs(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<SystemsTechSpecs>((json) => SystemsTechSpecs.fromJson(json)).toList();
  }
}