import 'dart:async';

import 'package:flutter/services.dart';

class HardwareButtons {
  static const MethodChannel _channel =
      const MethodChannel('hardware_buttons');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
