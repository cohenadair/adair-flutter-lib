import 'package:adair_flutter_lib/managers/manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../utils/properties_file.dart';

/// A class for accessing data in configuration files.
class PropertiesManager implements Manager {
  static var _instance = PropertiesManager._();

  static PropertiesManager get get => _instance;

  @visibleForTesting
  static void set(PropertiesManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = PropertiesManager._();

  PropertiesManager._();

  static const String _keyClientSenderEmail = "clientSender.email";
  static const String _keyRevenueCatGoogleApiKey = "revenueCat.googleApiKey";
  static const String _keyRevenueCatAppleApiKey = "revenueCat.appleApiKey";
  static const String _keySupportEmail = "support.email";
  static const String _keyMailjetApiKey = "mailjet.apiKey";
  static const String _keyMailjetSecretKey = "mailjet.secretKey";

  static const String _path = "assets/sensitive.properties";
  static const String _feedbackTemplatePath = "assets/feedback_template";

  late PropertiesFile _properties;
  late String _feedbackTemplate;

  @override
  Future<void> init() async {
    _properties = PropertiesFile(await rootBundle.loadString(_path));
    _feedbackTemplate = await rootBundle.loadString(_feedbackTemplatePath);
  }

  String get clientSenderEmail => stringForKey(_keyClientSenderEmail);

  String get revenueCatGoogleApiKey => stringForKey(_keyRevenueCatGoogleApiKey);

  String get revenueCatAppleApiKey => stringForKey(_keyRevenueCatAppleApiKey);

  String get supportEmail => stringForKey(_keySupportEmail);

  String get mailjetApiKey => stringForKey(_keyMailjetApiKey);

  String get mailjetSecretKey => stringForKey(_keyMailjetSecretKey);

  String get feedbackTemplate => _feedbackTemplate;

  String stringForKey(String key) => _properties.stringForKey(key);
}
