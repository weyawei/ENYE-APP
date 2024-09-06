import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../screens.dart';
import 'main_acc_page2.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/account';

  @override
  State<AccountPage> createState() => _AccountPageState();
}
class _AccountPageState extends State<AccountPage> {
  bool? userSessionFuture;
  clientInfo? ClientInfo;

  void initState(){
    super.initState();

    _checkSession();
  }

  _checkSession(){
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
          });
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return userSessionFuture == true ? MainAccPage2(onLogoutSuccess: _handleLoginSuccess) : LoginPage(onLoginSuccess: _handleLoginSuccess);
  }
}
