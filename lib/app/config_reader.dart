import 'dart:convert';
import 'package:flutter/services.dart';

abstract class ConfigReader {
  static Map<String, dynamic> _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getConfidentialOne() {
    return _config['confidential_1'] as String;
  }

  static String getConfidentialTwo() {
    return _config['confidential_2'] as String;
  }
}