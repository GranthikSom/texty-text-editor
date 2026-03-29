import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/colors.dart';
import 'pages/editor_shell.dart';
import 'services/editor_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => EditorState(),
      child: const ZephyrApp(),
    ),
  );
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
