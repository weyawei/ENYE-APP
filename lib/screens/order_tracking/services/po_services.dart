import 'dart:convert';

import '../../../config/config.dart';
import '../../screens.dart';

import 'package:http/http.dart' as http;

class QuotationPOServices {
  //this is same as in PHP code action made by the user CRUD

  static const GET_PO = 'get_po';
  static const GET_PO_ITEMS = 'get_po_items';

  static Future <List<QuotationPO>> getQuotationPO(String po_no) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_PO;
    map['po_no'] = po_no;

    //get all data of categories
    final res = await http.post(
      Uri.parse(API.quotation_po_details), body: map);
    print('get Quotation PO Response: ${res.body}');

    if (res.statusCode == 200) {
      List<QuotationPO> list = parsePO(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO');
      //return List<Categories>();
    }
  }

  static List<QuotationPO> parsePO(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<QuotationPO>((json) => QuotationPO.fromJson(json)).toList();
  }

  static Future <List<QuotationPOItems>> getQuotationPOItems(String quotation_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_PO_ITEMS;
    map['quotation_id'] = quotation_id;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.quotation_po_details), body: map);
    print('get Quotation PO Items Response: ${res.body}');

    if (res.statusCode == 200) {
      List<QuotationPOItems> list = parsePOItems(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO Items');
      //return List<Categories>();
    }
  }

  static List<QuotationPOItems> parsePOItems(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<QuotationPOItems>((json) => QuotationPOItems.fromJson(json)).toList();
  }


}