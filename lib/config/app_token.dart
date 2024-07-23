import 'package:http/http.dart' as http;

import '../../config/config.dart';

class TokenServices {

  static Future<String> updateToken(String fcmToken, String email) async {
    try{
      var map = Map<String, dynamic>();
      map['fcmToken'] = fcmToken;
      map['email'] = email;

      final res = await http.post(Uri.parse(API.token), body: map); //passing value to result
      print('Token Response: ${res.body}');

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