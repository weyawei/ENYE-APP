import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/api_connection.dart';
import '../screens.dart';

class productService {
  //this is same as in PHP code action made by the user CRUD
  static const GET_ALL_PRODUCT_CATEGORIES = 'get_all_prodcategory';
  static const GET_ALL_PRODUCT_SUBCATEGORIES = 'get_all_prodsubcategory';
  static const GET_ALL_PRODUCTS = 'get_all_products';
  static const GET_ALL_PRODUCT_DETAILS = 'get_all_product_details';
  static const GET_ALL_PRODUCT_THUMBNAILS = 'get_all_product_thumbnails';
  static const GET_ALL_PRODUCT_SIZES = 'get_all_product_sizes';
  static const GET_ALL_PRODUCT_BANNER = 'get_all_product_banner';

  //get data categories from database
  static Future <List<productCategory>> getProdCategory() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_CATEGORIES;

      //get all data of categories
      final res = await http.post(
          Uri.parse(API.products), body: map); //passing value to result
      print('getProdCategory Response: ${res.body}');

      if (res.statusCode == 200) {
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

  static List<productCategory> parseResProdCategory(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<productCategory>((json) => productCategory.fromJson(json))
        .toList();
  }

  static Future <List<productSubCategory>> getProdSubCategory() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_SUBCATEGORIES;

      //get all data of categories
      final res = await http.post(
          Uri.parse(API.products), body: map); //passing value to result
      print('getProdSubCategory Response: ${res.body}');

      if (res.statusCode == 200) {
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

  static List<productSubCategory> parseResProdSubCategory(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<productSubCategory>((json) =>
        productSubCategory.fromJson(json)).toList();
  }

  static Future <List<product>> getProducts() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCTS;

      //get all data of categories
      final res = await http.post(
          Uri.parse(API.products), body: map); //passing value to result
      print('getProducts Response: ${res.body}');

      if (res.statusCode == 200) {
        List<product> list = parseResProducts(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Products');
      }
    } catch (e) {
      throw Exception('Failed to retrieve Products');
    }
  }

  static List<product> parseResProducts(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<product>((json) => product.fromJson(json)).toList();
  }

  static Future <List<detailedProduct>> getProductDetails(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_DETAILS;
      map['product_id'] = id;

      //get all data of categories
      final res = await http.post(
          Uri.parse(API.products), body: map); //passing value to result
      print('getProductDetails Response: ${res.body}');

      if (res.statusCode == 200) {
        List<detailedProduct> list = parseResDetailedProd(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Product Details');
      }
    } catch (e) {
      throw Exception('Failed to retrieve Product Details');
    }
  }

  static List<detailedProduct> parseResDetailedProd(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<detailedProduct>((json) => detailedProduct.fromJson(json))
        .toList();
  }



  static Future <List<thumb>> getProductThumb() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_THUMBNAILS;

      //get all data of categories
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('getProductThumb Response: ${res.body}');

      if(res.statusCode == 200){
        List<thumb> list = parseResThumb(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Product Details');
      }
    } catch (e) {
      throw Exception('Failed to retrieve Product Details');
    }
  }

  static List<thumb> parseResThumb(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<thumb>((json) => thumb.fromJson(json)).toList();
  }


  static Future <List<size>> getProductSize() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_SIZES;

      //get all data of categories
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('getProduct Sizes Response: ${res.body}');

      if(res.statusCode == 200){
        List<size> list = parseResSize(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Product Details');
      }
    } catch (e) {
      throw Exception('Failed to retrieve Product Details');
    }
  }

  static List<size> parseResSize(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<size>((json) => size.fromJson(json)).toList();
  }



  static Future <List<banner>> getProductBanner() async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL_PRODUCT_BANNER;

      //get all data of categories
      final res = await http.post(Uri.parse(API.products), body: map); //passing value to result
      print('getProduct Banner Response: ${res.body}');

      if(res.statusCode == 200){
        List<banner> list = parseResBanner(res.body);
        return list;
      } else {
        throw Exception('Failed to retrieve Product Details');
      }
    } catch (e) {
      throw Exception('Failed to retrieve Product Details');
    }
  }

  static List<banner> parseResBanner(String responseBody){
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<banner>((json) => banner.fromJson(json)).toList();
  }



}












