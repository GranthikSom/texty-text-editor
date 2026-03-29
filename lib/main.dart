import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/colors.dart';
import 'pages/vim_shell.dart';

void main() {
  runApp(const VimApp());
}

class VimApp extends StatelessWidget {
  const VimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zephyr',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const VimShell(),
    );
  }
}
