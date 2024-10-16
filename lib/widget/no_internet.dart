import 'dart:async';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets.dart';

class NoInternetHandler extends StatefulWidget {
  final Widget child;

  const NoInternetHandler({required this.child});

  @override
  _NoInternetHandlerState createState() => _NoInternetHandlerState();
}

class _NoInternetHandlerState extends State<NoInternetHandler> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _hasConnection = true;
  bool _errorServer = false;

  @override
  void initState() {
    super.initState();
    _loadConnectionStatus(); // Load previous connection status
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          _checkInternetConnection(); // Check connection status
        });
  }

  @override
  Widget build(BuildContext context) {
    return _hasConnection ? widget.child : _errorServer ? NoInternetPage(_errorServer, onRetry: _checkInternetConnection,) : NoInternetPage(_hasConnection, onRetry: _checkInternetConnection,);
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

  _checkInternetConnection() async {
    try {
      // Wait for 5 seconds before declaring no connection
      await Future.delayed(Duration(seconds: 5));

      // Check internet connection first by pinging google.com
      final googleResponse = await http.get(Uri.parse("https://www.google.com"));

      if (googleResponse.statusCode == 200) {
        // Device has internet, now check the Enye server
        final enyeResponse = await http.get(Uri.parse("https://www.enye.com.ph"));

        setState(() {
          if (enyeResponse.statusCode == 200) {
            _hasConnection = true;  // Both internet and Enye server are working fine
            _errorServer = false;
          } else if (enyeResponse.statusCode == 503) {
            _hasConnection = true;  // Internet is fine but Enye server has an issue
            _errorServer = true;
          }
          _saveConnectionStatus(_hasConnection);  // Save the connection status
        });
      } else {
        setState(() {
          _hasConnection = false;  // No internet connection
          _errorServer = false;
          _saveConnectionStatus(false);  // Save the connection status
        });
      }
    } catch (e) {
      setState(() {
        _hasConnection = false;  // Error occurred, no internet connection
        _errorServer = false;
        _saveConnectionStatus(false);  // Save the connection status
      });
    }
  }
}

class NoInternetPage extends StatelessWidget {
  final bool error;
  final VoidCallback onRetry;
  NoInternetPage(this.error, {required this.onRetry});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXSize = ResponsiveTextUtils.getXFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);
    var fontXXXSize = ResponsiveTextUtils.getXXXFontSize(screenWidth);

    return Scaffold(
        backgroundColor: Colors.deepOrange.shade200,
        body: RefreshIndicator(
          onRefresh: () async {
            // Call the retry function when the user pulls to refresh
            onRetry();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Allow pull-to-refresh even if content is not scrollable
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.1,
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
                bottom: screenHeight * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      onRetry(); // Retry on tap
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Lottie.asset(
                          'assets/lottie/no_internet.json',
                          frameRate: FrameRate.max,
                          alignment: Alignment.center,
                          height: screenHeight * 0.5,
                          width: screenWidth * 0.84
                        ),

                        Column(
                          children: [
                            Text(
                              //if error = true ibig sabihin may error sa server
                              //if error = false ibig sabihin may Walang Internet
                                error ? "We are Under Maintenance." : "No Internet Connection",
                                textAlign: TextAlign.center,
                                style: error ? GoogleFonts.paytoneOne(
                                  textStyle: TextStyle(
                                      fontSize: fontXSize,
                                      letterSpacing: 1.2,
                                      color: Colors.deepOrange.shade700
                                  ),
                                ) : TextStyle(
                                    fontFamily: 'Rowdies',
                                    fontSize: fontXSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.deepOrange.shade700
                                ),
                            ),

                            const SizedBox(height: 15,),
                            Text(
                              textAlign: TextAlign.center,
                              error ? "Sorry for the inconvenience, will be back soon !" : "Please check your internet connection and try again.",
                              style: error ? GoogleFonts.alata(
                                textStyle: TextStyle(
                                    fontSize: fontSmallSize,
                                    color: Colors.white
                                ),
                              ) : TextStyle(
                                  fontSize: fontSmallSize,
                                  letterSpacing: 0.8,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.1),

                        Container(
                          height: screenHeight * 0.04,
                          width: screenWidth * 0.7,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/logo/enyecontrols.png"),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}