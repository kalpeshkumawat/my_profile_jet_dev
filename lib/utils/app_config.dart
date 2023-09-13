import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  static Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/secure/config.json");
  }

  static Future<String> getUserEmail() async {
    String jsonString = await _loadFromAsset();
    final jsonResponse = jsonDecode(jsonString)['email'];

    return jsonResponse;
  }

  static Future<String> getUserName() async {
    String jsonString = await _loadFromAsset();
    final jsonResponse = jsonDecode(jsonString)['name'];

    return jsonResponse;
  }
}
