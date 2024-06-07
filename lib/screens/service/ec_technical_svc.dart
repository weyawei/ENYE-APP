import 'dart:convert';
import 'package:enye_app/screens/service/ec_technical_data.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../screens.dart';

class ECTechnicalDataServices {
  //this is same as in PHP code action made by the user CRUD

  static const GET_ALL_ECUSERS = 'get_all_ecusers';
  static const GET_ALL_TSIS = 'get_all_tsis';
  static const GET_ALL_ECSO = 'get_all_ecso';
  static const GET_ALL_ECSOPDF = 'get_all_ecsoPdf';
  static const GET_ALL_EVENTS = 'get_all_events';



  static Future <List<EcUsers>> getEcUsers() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_ECUSERS;

    //get all data of categories
    final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
    print('get EcUsers Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcUsers> list = parseEcUsers(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcUsers');
      //return List<Categories>();
    }

  }

  static List<EcUsers> parseEcUsers(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EcUsers>((json) => EcUsers.fromJson(json)).toList();
  }

  static Future <List<EcEvent>> getEcEvents() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_EVENTS;

    //get all data of categories
    final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
    print('get EcEvents Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcEvent> list = parseEcEvents(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcEvents');
      //return List<Categories>();
    }

  }

  static List<EcEvent> parseEcEvents(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EcEvent>((json) => EcEvent.fromJson(json)).toList();
  }


  static Future <List<EcSO>> getEcSO() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_ECSO;

    //get all data of categories
    final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
    print('get EcSO Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcSO> list = parseEcSO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcSO');
      //return List<Categories>();
    }

  }

  static List<EcSO> parseEcSO(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EcSO>((json) => EcSO.fromJson(json)).toList();
  }


  static Future <List<EcSO>> getEcSOPDF(String so_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_ECSOPDF;
    map['so_id'] = so_id;

    //get all data of categories
    final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
    print('get EcSO Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcSO> list = parseEcSOPDF(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcSO');
      //return List<Categories>();
    }

  }

  static List<EcSO> parseEcSOPDF(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EcSO>((json) => EcSO.fromJson(json)).toList();
  }


  static Future <List<EcTSIS>> getEcTSIS() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_TSIS;

    //get all data of categories
    final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
    print('get EcTSIS Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcTSIS> list = parseEcTSIS(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcTSIS');
      //return List<Categories>();
    }

  }

  static List<EcTSIS> parseEcTSIS(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EcTSIS>((json) => EcTSIS.fromJson(json)).toList();
  }


}