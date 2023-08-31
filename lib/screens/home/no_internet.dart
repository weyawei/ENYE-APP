import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoInternetHandler extends StatefulWidget {
  final Widget child;

  const NoInternetHandler({required this.child});

  @override
  _NoInternetHandlerState createState() => _NoInternetHandlerState();
}

class _NoInternetHandlerState extends State<NoInternetHandler> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _loadConnectionStatus(); // Load previous connection status
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() {
            _hasConnection = result != ConnectivityResult.none;
            _saveConnectionStatus(_hasConnection); // Save the new connection status
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return _hasConnection ? widget.child : NoInternetPage();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  _loadConnectionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasConnection = prefs.getBool('hasConnection') ?? true;
    });
  }

  _saveConnectionStatus(bool hasConnection) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasConnection', hasConnection);
  }
}

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Please check your internet connection and try again."),
          ],
        ),
      ),
    );
  }
}