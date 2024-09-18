import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../config/config.dart';
import '../../screens.dart';

class NewsServices {
  static const GET_NEWS = 'get_news';
  static const GET_NEWS_ARTICLE = 'get_news_article';
  static const GET_NEWS_CONTENT = 'get_news_content';

  static Future <List<NewsUpdates>> getNewsUpdates() async {
    var map = Map<String, dynamic>();
    map['action'] = GET_NEWS;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.news), body: map);
    print('get News Response: ${res.body}');

    if (res.statusCode == 200) {
      List<NewsUpdates> list = parseNews(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO');
      //return List<Categories>();
    }
  }

  static Future <List<NewsUpdates>> getNewsArticle(String news_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_NEWS_ARTICLE;
    map['news_id'] = news_id;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.news), body: map);
    print('get News Response: ${res.body}');

    if (res.statusCode == 200) {
      List<NewsUpdates> list = parseNewsArticle(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO');
      //return List<Categories>();
    }
  }

  static Future <List<NewsContents>> getNewsContent(String news_id) async {
    var map = Map<String, dynamic>();
    map['action'] = GET_NEWS_CONTENT;
    map['news_id'] = news_id;

    //get all data of categories
    final res = await http.post(
        Uri.parse(API.news), body: map);
    print('get News Contents Response: ${res.body}');

    if (res.statusCode == 200) {
      List<NewsContents> list = parseNewsContents(res.body);
      return list;
    } else {
      throw Exception('Failed to retrieve Quotation PO');
      //return List<Categories>();
    }
  }

  static List<NewsUpdates> parseNews(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<NewsUpdates>((json) => NewsUpdates.fromJson(json)).toList();
  }

  static List<NewsUpdates> parseNewsArticle(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<NewsUpdates>((json) => NewsUpdates.fromJson(json)).toList();
  }

  static List<NewsContents> parseNewsContents(String responseBody) {
    //conversion from web server into data by using categories.dart
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<NewsContents>((json) => NewsContents.fromJson(json)).toList();
  }
}