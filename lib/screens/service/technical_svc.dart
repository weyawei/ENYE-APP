import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../screens.dart';

class TechnicalDataServices {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_TECHNICAL = 'get_all_technical';
  static const GET_CLIENT_TECHNICAL = 'get_client_technical';
  static const GET_HANDLER_DATA = 'get_handler_data';
  static const GET_HANDLER_DATA2 = 'get_handler_data2';
  static const GET_ALL_POSITIONS = 'get_all_pos';
  static const EDIT_TO_CANCELLED = 'edit_to_cancelled';
  static const EDIT_TO_ACCEPTED = 'edit_to_accepted';
  static const EDIT_TO_RESCHED = 'edit_to_resched';
  static const BOOKING = 'add_booking';
  static const GET_ALL_SERVICEORDER = 'get_all_serviceorder';
  static const GET_SO_DATA = 'get_so_data';
  static const GET_ALL_USERS = 'get_all_users';
  static const GET_ALL_SERVICEAPPOINT = 'get_all_serviceappoint';

  static const GET_ALL_ECUSERS = 'get_all_ecusers';
  static const GET_ALL_TSIS = 'get_all_tsis';
  static const GET_ALL_ECSO = 'get_all_ecso';
  static const GET_ALL_EVENTS = 'get_all_events';


  //get data users position from database
  static Future <List<ServiceOrder>> getServiceOrder() async {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_SERVICEORDER;

      //get all data of categories
      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('getServiceOrder Response: ${res.body}');

      if(res.statusCode == 200){
        List<ServiceOrder> list = parseServiceOrder(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Server Order');
        //return List<Categories>();
      }

  }

  static List<ServiceOrder> parseServiceOrder(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ServiceOrder>((json) => ServiceOrder.fromJson(json)).toList();
  }

  static Future<List<ServiceOrder>> getServiceOrderData(String so_id) async {

    var map = Map<String, dynamic>();
    map['action'] = GET_SO_DATA;
    map['so_id'] = so_id;

    //get all data of categories
    final res = await http.post(Uri.parse(API.serviceOrderData), body: map); //passing value to result
    print('getSO Response: ${res.body}');

    if(res.statusCode == 200){
      List<ServiceOrder> list = parseResponseSO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Technical Data');
      //return List<Categories>();
    }
  }

  static List<ServiceOrder> parseResponseSO(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ServiceOrder>((json) => ServiceOrder.fromJson(json)).toList();
  }


  static Future <List<ServiceAppointment>> getServiceAppoint() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_ALL_SERVICEAPPOINT;

    //get all data of categories
    final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
    print('getServiceOrder Response: ${res.body}');

    if(res.statusCode == 200){
      List<ServiceAppointment> list = parseServiceAppoint(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Server Order');
      //return List<Categories>();
    }

  }

  static List<ServiceAppointment> parseServiceAppoint(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ServiceAppointment>((json) => ServiceAppointment.fromJson(json)).toList();
  }


  //get data categories from database
  static Future <List<UsersInfo>> getUsersInfo() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_USERS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.users), body: map); //passing value to result
      print('getUsersInfo Response: ${res.body}');

      if(res.statusCode == 200){
        List<UsersInfo> list = parseUIResponse(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Users Info');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Users Info');
      //return List<Categories>();
    }
  }

  static List<UsersInfo> parseUIResponse(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UsersInfo>((json) => UsersInfo.fromJson(json)).toList();
  }

  //get data users position from database
  static Future <List<Position>> getPositions() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_POSITIONS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.position), body: map); //passing value to result
      print('getPosition Response: ${res.body}');

      if(res.statusCode == 200){
        List<Position> list = parseResPosition(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Position');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Position');
      //return List<Categories>();
    }
  }

  static List<Position> parseResPosition(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Position>((json) => Position.fromJson(json)).toList();
  }

  //get handler data from database
  static Future <List<UserAdminData>> handlerData(String user_id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_HANDLER_DATA;
      map['user_id'] = user_id;

      //get all data of categories
      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('Handler Data Response: ${res.body}');

      if(res.statusCode == 200){
        List<UserAdminData> list = parseResHandler(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Handler Data');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Handler Data');
      //return List<Categories>();
    }
  }

  static List<UserAdminData> parseResHandler(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UserAdminData>((json) => UserAdminData.fromJson(json)).toList();
  }


  //get handler data from database
  static Future <List<UserAdminData2>> handlerData2() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_HANDLER_DATA2;

      //get all data of categories
      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('Handler Data Response: ${res.body}');

      if(res.statusCode == 200){
        List<UserAdminData2> list = parseResHandler2(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Handler Data2');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Handler Data2');
      //return List<Categories>();
    }
  }

  static List<UserAdminData2> parseResHandler2(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UserAdminData2>((json) => UserAdminData2.fromJson(json)).toList();
  }



  //get all bookings para sa date disabling from database
  static Future <List<TechnicalData>> getTechnicalData() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_TECHNICAL;

      //get all data of categories
      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('getTechnicalData Response: ${res.body}');

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

  //get booking of certain client from database
  static Future <List<TechnicalData>> clientTechnicalData(String client_id) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_CLIENT_TECHNICAL;
      map['client_id'] = client_id;

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

  static Future<String> addBooking(
      String svc_id, String service,
      String svc_title, String svc_desc,
      String req_name, String req_position,
      String cli_remarks, String atch_file, String atch_data,
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
      map['date_booked'] = date_sched;
      map['req_name'] = req_name;
      map['req_position'] = req_position;
      map['cli_remarks'] = cli_remarks;
      map['atch_file'] = atch_file;
      map['atch_data'] = atch_data;
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

  //edit TO CANCEL BOOKING in database
  static Future<String> editCancelBooking(String id, String svcId, String reason) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_CANCELLED;
      map['id'] = id;
      map['svcId'] = svcId;
      map['reason'] = reason;

      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('editToCancelled Response: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //edit TO ACCEPT THE BOOKING
  static Future<String> editToAccepted(String id, String svcId/*, String sDateSched, String eDateSched*/) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_ACCEPTED;
      map['id'] = id;
      map['svcId'] = svcId;
      /*map['sDateSched'] = sDateSched;
      map['eDateSched'] = eDateSched;*/

      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('editToAcceptedResponse: ${res.body}');

      if(res.statusCode == 200){
        return res.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  //edit TO ACCEPT THE BOOKING
  static Future<String> editToResched(String id, String svcId, String sDateSched, String eDateSched, String notes) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = EDIT_TO_RESCHED;
      map['id'] = id;
      map['svcId'] = svcId;
      map['sDateSched'] = sDateSched;
      map['eDateSched'] = eDateSched;
      map['notes'] = notes;

      final res = await http.post(Uri.parse(API.booking), body: map); //passing value to result
      print('editToReschedResponse: ${res.body}');

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