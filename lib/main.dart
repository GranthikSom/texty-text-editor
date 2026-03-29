import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'pages/editor_shell.dart';

void main() {
  runApp(const ZephyrApp());
}

class ZephyrApp extends StatelessWidget {
  const ZephyrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zephyr Editor',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const EditorShell(),
    );
  }
}
