import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheck {
  static Future<void> checkForUpdate(BuildContext context) async {
    final String apiUrl = 'https://enye.com.ph/enyecontrols_app_test/enye/check_version.php'; // Replace with your API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("BodyVersion: $data");

        // Fetch the latest version based on platform
        String latestVersion = Platform.isAndroid
            ? data['play_store_version'] ?? '0.0.0'
            : data['app_store_version'] ?? '0.0.0';

        // Log the latest version
        print("Latest Version for Platform: $latestVersion");

        // Get current app version
        String currentVersion = await getCurrentVersion();
        print("Current App Version: $currentVersion");

        // Compare the versions
        if (_isUpdateRequired(currentVersion, latestVersion)) {
          _showUpdateDialog(context);
        }
      } else {
        // Handle error
        print('Failed to load version data');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  // Get the current version of the app from package info
  static Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // Compare two version strings (major.minor.patch)
  static bool _isUpdateRequired(String currentVersion, String latestVersion) {
    return currentVersion != latestVersion;
  }

  // Show update dialog if an update is required
  static void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Optional branding or logo
                Icon(
                  Icons.update,
                  size: 60,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Update Available',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                // Content Text
                Text(
                  'A new version of the app is available. Please update to the latest version for the best experience.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Redirect to the Play Store or App Store
                      String url = Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=com.enyecontrols.enye' // Play Store URL
                          : 'https://apps.apple.com/ph/app/enyecontrols/id6476119131'; // App Store URL
                      launch(url);
                    },
                    child: Text(
                      'Update Now',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Optional later button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog if user doesn't want to update now
                  },
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
