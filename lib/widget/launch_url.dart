import 'package:url_launcher/url_launcher.dart';

void launchURL(String urlString) async {
  Uri url = Uri.parse(urlString);
  try {
    bool launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Launch the app if installed
    );

    if (!launched) {
      // Fallback to launching in a web view if the app is not installed
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // or LaunchMode.externalNonBrowserApplication
      );
    }
  } catch (e) {
    // Fallback to launching in a web view if there's an error
    await launchUrl(
      url,
      mode: LaunchMode.inAppWebView, // or LaunchMode.externalNonBrowserApplication
    );
  }
}
