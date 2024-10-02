import 'dart:convert';

import '../../../config/config.dart';
import '../../screens.dart';

import 'package:http/http.dart' as http;

class ClientPOServices {

  static const GET_PO_DETAILS = 'get_po_details';
  static const GET_CLIENT_PO = 'get_client_po';
  static const GET_SAVED_CLIENT_PO = 'get_saved_client_po';
  static const SAVE_OR_UNSAVE_TRACKINGNO = 'save_or_unsave_tracking_no';

  static Future <List<PODetails>> getPODetails(String po_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_PO_DETAILS;
    map['po_id'] = po_id;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.client_po), body: map);
    print('get PO Details Response: ${res.body}');

    if (res.statusCode == 200) {
      List<PODetails> list = parsePODetails(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO Items');
      //return List<Categories>();
    }
  }

  static List<PODetails> parsePODetails(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PODetails>((json) => PODetails.fromJson(json)).toList();
  }

  static Future <List<ClientPO>> getClientPO(String po_no) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_CLIENT_PO;
    map['po_no'] = po_no;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.client_po), body: map);
    print('get Client PO Response: ${res.body}');

    if (res.statusCode == 200) {
      List<ClientPO> list = parseClientPO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO Items');
      //return List<Categories>();
    }
  }

  static List<ClientPO> parseClientPO(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ClientPO>((json) => ClientPO.fromJson(json)).toList();
  }

  static Future <List<ClientPO>> getSavedClientPO(String email) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_SAVED_CLIENT_PO;
    map['email'] = email;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.client_po), body: map);
    print('get Saved Client PO Response: ${res.body}');

    if (res.statusCode == 200) {
      List<ClientPO> list = parseSavedClientPO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Saved Client PO');
      //return List<Categories>();
    }
  }

  static List<ClientPO> parseSavedClientPO(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ClientPO>((json) => ClientPO.fromJson(json)).toList();
  }

  static Future<String> saveOrUnsaveTrackingNo(String client_email, String tracking_no, String po_id, String what_to_do) async {
    try{
      var map = Map<String, dynamic>();
      //get the action do by the user transfer it to POST method
      map['action'] = SAVE_OR_UNSAVE_TRACKINGNO;
      //name of category entered by user
      map['client_email'] = client_email;
      map['tracking_no'] = tracking_no;
      map['po_id'] = po_id;
      map['what_to_do'] = what_to_do;

      //config API to connect web server
      final res = await http.post(Uri.parse(API.client_po), body: map); //passing value to result
      print('Saved Client PO Response: ${res.body}');

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
}