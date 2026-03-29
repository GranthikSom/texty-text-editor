import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class WindowController {
  static Future<void> minimize() async {
    // Use Flutter's built-in window handling
  }

  static Future<void> maximize() async {
    // Use Flutter's built-in window handling
  }

  static Future<void> close() async {
    // Use Flutter's built-in window handling
  }

  static Future<bool> isMaximized() async {
    return false;
  }
}

class DraggableTitleBar extends StatelessWidget {
  final Widget child;

  const DraggableTitleBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) {},
      child: child,
    );
  }
}
