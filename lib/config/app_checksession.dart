import 'package:flutter_session_manager/flutter_session_manager.dart';

class checkSession {

  Future<bool> getUserSessionStatus() async {
    return SessionManager().containsKey("user_data");
  }

}