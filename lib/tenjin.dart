
import 'dart:async';

import 'package:flutter/services.dart';

class Tenjin {
  static const MethodChannel _channel = MethodChannel('tenjin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
