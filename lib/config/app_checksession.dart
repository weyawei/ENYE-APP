import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../screens/screens.dart';

class checkSession {

  Future<bool> getUserSessionStatus() async {
    return SessionManager().containsKey("client_data");
  }

  Future <clientInfo> getClientsData() async {
    clientInfo ClientInfo = clientInfo.fromJson(await SessionManager().get("client_data"));
    return ClientInfo;
  }

}