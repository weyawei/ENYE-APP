import 'dart:io';

class ApiPlatform {
  static String getPlatform() {
    String platform;

    if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = ''; // Default case if it's neither Android nor iOS
    }

    return platform;
  }
}