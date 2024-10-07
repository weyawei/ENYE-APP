import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../screens.dart';

class EngineeringServices {
  //this is same as in PHP code action made by the user CRUD

  static const GET_APPOINTMENT_EMAILBASED = 'get_appointment_emailbased';
  static const GET_TSIS_EVENTS_EMAILBASED = 'get_tsis_events_emailbased';
  static const GET_TSIS_EVENTS_EMAILBASED_COMPLETE = 'get_tsis_events_emailbased_complete';
  static const GET_ALL_ECUSERS = 'get_all_ecusers';
  static const GET_SO_TSISID = 'get_so_tsisid';
  static const GET_TSIS_BYID = 'get_tsis_byid';
  static const GET_SO_BYID = 'get_so_byid';

  static Future <List<TechnicalData>> getAppointmentsEmailBased(String email) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_APPOINTMENT_EMAILBASED;
    map['email'] = email;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
    print('get Appointment Email Based Response: ${res.body}');

    if(res.statusCode == 200){
      List<TechnicalData> list = parseAppointment(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Appointment');
    }
  }

  static List<TechnicalData> parseAppointment(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TechnicalData>((json) => TechnicalData.fromJson(json)).toList();
  }

  static Future <List<EngTSIS>> getTSISbyID(String tsis_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_TSIS_BYID;
    map['tsis_id'] = tsis_id;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
    print('get EcTSIS Email Based Response: ${res.body}');

    if(res.statusCode == 200){
      List<EngTSIS> list = parseTsisEvents(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcTSIS');
    }

  }

  static Future <List<EngTSIS>> getTsisEventsEmailBasedComplete(String email) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_TSIS_EVENTS_EMAILBASED_COMPLETE;
    map['email'] = email;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
    print('get EcTSIS Email Based Response: ${res.body}');

    if(res.statusCode == 200){
      List<EngTSIS> list = parseTsisEvents(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcTSIS');
    }
  }

  static Future <List<EngTSIS>> getTsisEventsEmailBased(String email) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_TSIS_EVENTS_EMAILBASED;
    map['email'] = email;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
    print('get EcTSIS Email Based Response: ${res.body}');

    if(res.statusCode == 200){
      List<EngTSIS> list = parseTsisEvents(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve EcTSIS');
    }
  }

  static List<EngTSIS> parseTsisEvents(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EngTSIS>((json) => EngTSIS.fromJson(json)).toList();
  }

  static Future <List<EcUsers>> getEngineeringUsers() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_ECUSERS;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
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

  static Future <List<EcSO>> getSOtsisid(String tsis_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_SO_TSISID;
    map['tsis_id'] = tsis_id;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
    print('get SO TSIS ID Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcSO> list = parseSO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve SO TSIS ID');
      //return List<Categories>();
    }
  }

  static Future <List<EcSO>> getSObyID(String so_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_SO_BYID;
    map['so_id'] = so_id;

    //get all data of categories
    final res = await http.post(Uri.parse(API.technical), body: map); //passing value to result
    print('get Service Order Response: ${res.body}');

    if(res.statusCode == 200){
      List<EcSO> list = parseSO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Service Order');
      //return List<Categories>();
    }

  }

  static List<EcSO> parseSO(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<EcSO>((json) => EcSO.fromJson(json)).toList();
  }


}