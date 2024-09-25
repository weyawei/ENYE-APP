import 'dart:convert';

import '../../../config/config.dart';
import '../../screens.dart';

import 'package:http/http.dart' as http;

class ClientPOServices {

  static const GET_PO_DETAILS = 'get_po_details';
  static const GET_CLIENT_PO = 'get_client_po';

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
}