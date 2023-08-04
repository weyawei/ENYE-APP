import 'package:flutter_session_manager/flutter_session_manager.dart';

class userAdmin {
  final String name;
  final String email;
  final String password;

  userAdmin({required this.name,required this.email,required this.password});

  Map <String, dynamic> toJson() => {

    'name' : name,
    'email' : email,
    'password' : password,
  };
}

class clientInfo {
  String client_id;
  String name;
  String company_name;
  String location;
  String project_name;
  String contact_no;
  String email;
  String image;

  clientInfo({
    required this.client_id,
    required this.name,
    required this.company_name,
    required this.location,
    required this.project_name,
    required this.contact_no,
    required this.email,
    required this.image,
  });

  factory clientInfo.toJson(Map<String, dynamic> json) {
    return clientInfo(
      client_id: json['client_id'] as String,
      name: json['name'] as String,
      company_name: json['company_name'] as String,
      location: json['location'] as String,
      project_name: json['project_name'] as String,
      contact_no: json['contact_no'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
    );
  }
}

Future <clientInfo> _getClientSessionStatus() async {
  clientInfo userInfo = clientInfo.toJson(await SessionManager().get("user_data"));

  return userInfo;
}