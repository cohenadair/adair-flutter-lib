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

  String get clientSenderEmail => stringForKey(_keyClientSenderEmail);

  String get revenueCatGoogleApiKey => stringForKey(_keyRevenueCatGoogleApiKey);

  String get revenueCatAppleApiKey => stringForKey(_keyRevenueCatAppleApiKey);

  String get supportEmail => stringForKey(_keySupportEmail);

  String get sendGridApiKey => stringForKey(_keySendGridApiKey);

  String get feedbackTemplate => _feedbackTemplate;

  String stringForKey(String key) => _properties.stringForKey(key);
}
