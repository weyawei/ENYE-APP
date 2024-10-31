import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../screens/screens.dart';

class checkSession {

  Future<bool> getUserSessionStatus() async {
    // Check if the key exists and is not empty
    if (await SessionManager().containsKey("client_data")) {
      var clientData = await SessionManager().get("client_data");
      // return clientData != null || clientData.isNotEmpty;
      return clientData != null || clientData['name'] != null || clientData['name'].isNotEmpty || clientData.isNotEmpty;
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

  // Method to get the device model; accept BuildContext as a parameter
  Future<Map<String, String?>> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceModel;
    String? deviceBrand;
    String? deviceManufacturer;
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = "${androidInfo.model} (${androidInfo.brand})";
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine;
        deviceId = iosInfo.identifierForVendor;
      } else {
        deviceModel = "Unknown Device";
        deviceId = "Unknown ID";
      }
    } catch (e) {
      deviceModel = "Error retrieving device model";
      deviceId = "Error retrieving device Id";
    }

    return {
      "model": deviceModel,
      "id": deviceId,
    };
  }
}