import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../screens/screens.dart';

class checkSession {

  Future<bool> getUserSessionStatus() async {
    // Check if the key exists and is not empty
    if (await SessionManager().containsKey("client_data")) {
      var clientData = await SessionManager().get("client_data");
      return clientData != null && clientData.isNotEmpty;
    }
    return false;
  }

  Future <clientInfo> getClientsData() async {
    clientInfo ClientInfo = clientInfo.fromJson(await SessionManager().get("client_data"));
    return ClientInfo;
  }

  Future <String> getToken() async {
   dynamic token = await SessionManager().get("token");
    return token.toString();
  }

}