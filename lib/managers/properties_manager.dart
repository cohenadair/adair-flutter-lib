import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../utils/properties_file.dart';

/// A class for accessing data in configuration files.
class PropertiesManager {
  static var _instance = PropertiesManager._();

  static PropertiesManager get get => _instance;

  @visibleForTesting
  static void set(PropertiesManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = PropertiesManager._();

  PropertiesManager._();

  final String _keyClientSenderEmail = "clientSender.email";
  final String _keyRevenueCatApiKey = "revenueCat.apiKey";
  final String _keyRevenueCatGoogleApiKey = "revenueCat.googleApiKey";
  final String _keyRevenueCatAppleApiKey = "revenueCat.appleApiKey";
  final String _keySupportEmail = "support.email";
  final String _keySendGridApiKey = "sendGrid.apikey";

  final String _path = "assets/sensitive.properties";
  final String _feedbackTemplatePath = "assets/feedback_template";

  late PropertiesFile _properties;
  late String _feedbackTemplate;

  Future<void> init() async {
    _properties = PropertiesFile(await rootBundle.loadString(_path));
    _feedbackTemplate = await rootBundle.loadString(_feedbackTemplatePath);
  }

  String get clientSenderEmail =>
      _properties.stringForKey(_keyClientSenderEmail);

  @Deprecated("Use revenueCatGoogleApiKey and revenueCatAppleApiKey")
  String get revenueCatApiKey => _properties.stringForKey(_keyRevenueCatApiKey);

  String get revenueCatGoogleApiKey =>
      _properties.stringForKey(_keyRevenueCatGoogleApiKey);

  String get revenueCatAppleApiKey =>
      _properties.stringForKey(_keyRevenueCatAppleApiKey);

  String get supportEmail => _properties.stringForKey(_keySupportEmail);

  String get sendGridApiKey => _properties.stringForKey(_keySendGridApiKey);

  String get feedbackTemplate => _feedbackTemplate;
}
