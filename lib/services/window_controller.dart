import 'package:flutter/services.dart';

class WindowController {
  static const MethodChannel _channel = MethodChannel('zephyr/window');

  static Future<void> minimize() async {
    await _channel.invokeMethod('minimize');
  }

  static Future<void> maximize() async {
    await _channel.invokeMethod('maximize');
  }

  static Future<void> close() async {
    await _channel.invokeMethod('close');
  }

  static Future<bool> isMaximized() async {
    final result = await _channel.invokeMethod<bool>('isMaximized');
    return result ?? false;
  }

  static Future<void> startDragging() async {
    await _channel.invokeMethod('startDragging');
  }
}
