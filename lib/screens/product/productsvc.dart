import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';
import '../screens.dart';

class productService {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_PRODUCT_CATEGORIES = 'get_all_prodcategory';
  static const GET_ALL_PRODUCT_SUBCATEGORIES = 'get_all_prodsubcategory';

  //get data categories from database
  static Future <List<productCategory>> getProdCategory() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_CATEGORIES;

      //get all data of categories
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('getProdCategory Response: ${res.body}');

      if(res.statusCode == 200){
        List<productCategory> list = parseResProdCategory(res.body);
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

  static List<productCategory> parseResProdCategory(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<productCategory>((json) => productCategory.fromJson(json)).toList();
  }

  static Future <List<productSubCategory>> getProdSubCategory() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_SUBCATEGORIES;

      //get all data of categories
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('getProdSubCategory Response: ${res.body}');

      if(res.statusCode == 200){
        List<productSubCategory> list = parseResProdSubCategory(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Sub Category');
        //return List<Categories>();
      }
    } catch (e) {
      throw Exception('Failed to retrieve Sub Category');
      //return List<Categories>();
    }
  }

  static List<productSubCategory> parseResProdSubCategory(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<productSubCategory>((json) => productSubCategory.fromJson(json)).toList();
  }
}