import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_connection.dart';
import '../screens.dart';

class TechnicalDataServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_TECHNICAL = 'get_all_technical';
  static const BOOKING = 'add_booking';

  //get data categories from database
  static Future <List<TechnicalData>> getTechnicalData() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_TECHNICAL;

      //get all data of categories
      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('getTechnicalDatas Response: ${res.body}');

      if(res.statusCode == 200){
        List<TechnicalData> list = parseResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Technical Data');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<TechnicalData> parseResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TechnicalData>((json) => TechnicalData.fromJson(json)).toList();
  }

  static Future<String> addBooking(
      String svc_id, String service,
      String svc_title, String svc_desc,
      String date_sched, String client_id,
      String client_name, String client_company,
      String client_location, String client_projectname,
      String client_contact, String client_email) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = BOOKING;
      //name of category entered by user
      map['code'] = svc_id;
      map['service'] = service;
      map['subject'] = svc_title;
      map['desc'] = svc_desc;
      map['date_sched'] = date_sched;
      map['client_id'] = client_id;
      map['name'] = client_name;
      map['company'] = client_company;
      map['location'] = client_location;
      map['project'] = client_projectname;
      map['contact'] = client_contact;
      map['email'] = client_email;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('Booking Response: ${res.body}');

      //if status is okay in web server
      if(res.statusCode == 200){
        //return result from PHP backend
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  /*static Future<String> pushNotif(String title, String body) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_COMPLETED;
      map['title'] = title;
      map['body'] = body;

      final res = await http.post(Uri.parse(API.pushNotif), body: map); //passing value to result
      print('pushNotif Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }*/
}