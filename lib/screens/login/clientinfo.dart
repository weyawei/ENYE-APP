import 'package:flutter_session_manager/flutter_session_manager.dart';

class clientInfo {
  String client_id;
  String name;
  String contact_no;
  String email;
  String image;
  String login;

  clientInfo({
    required this.client_id,
    required this.name,
    required this.contact_no,
    required this.email,
    required this.image,
    required this.login,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> client = Map<String, dynamic>();
    client["client_id"] = this.client_id;
    client["name"] = this.name;
    client["contact_no"] = this.contact_no;
    client["email"] = this.email;
    client["image"] = this.image;
    client["login"] = this.login;
    return client;
  }

  static clientInfo fromJson(Map<String, dynamic> json) {
    return clientInfo(
      client_id: json['client_id'] as String,
      name: json['name'] as String,
      contact_no: json['contact_no'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      login: json['login'] as String,
    );
  }
}


Future <clientInfo> _getClientSessionStatus() async {
  clientInfo userInfo = clientInfo.fromJson(await SessionManager().get("user_data"));

  return userInfo;
}