import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherWrapper {
  static var _instance = UrlLauncherWrapper._();

  static UrlLauncherWrapper get get => _instance;

  @visibleForTesting
  static void set(UrlLauncherWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = UrlLauncherWrapper._();

  UrlLauncherWrapper._();

  Future<bool> canLaunch(String url) => launcher.canLaunchUrl(Uri.parse(url));

  Future<bool> launch(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    BrowserConfiguration browserConfiguration = const BrowserConfiguration(),
    String? webOnlyWindowName,
  }) {
    return launcher.launchUrl(
      Uri.parse(url),
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      browserConfiguration: browserConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }
}
