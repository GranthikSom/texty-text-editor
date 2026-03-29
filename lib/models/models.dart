import 'package:flutter/material.dart';
import '../theme/colors.dart';

// ─── Terminal Line ─────────────────────────────────────────────────────────────

class TermLine {
  final String text;
  final Color color;
  const TermLine(this.text, this.color);
}

// ─── File Tree Node ────────────────────────────────────────────────────────────

class FileNode {
  final String icon;
  final String name;
  final int depth;
  final bool isDir;

  const FileNode({
    required this.icon,
    required this.name,
    required this.depth,
    required this.isDir,
  });
}

// ─── Static Demo Data ──────────────────────────────────────────────────────────

const List<FileNode> kDemoTree = [
  FileNode(icon: '📁', name: 'lib',          depth: 0, isDir: true),
  FileNode(icon: '🎯', name: 'main.dart',    depth: 1, isDir: false),
  FileNode(icon: '🎯', name: 'app.dart',     depth: 1, isDir: false),
  FileNode(icon: '📁', name: 'widgets',      depth: 1, isDir: true),
  FileNode(icon: '🎯', name: 'editor.dart',  depth: 2, isDir: false),
  FileNode(icon: '🎯', name: 'panel.dart',   depth: 2, isDir: false),
  FileNode(icon: '📁', name: 'models',       depth: 1, isDir: true),
  FileNode(icon: '🎯', name: 'file.dart',    depth: 2, isDir: false),
  FileNode(icon: '📄', name: 'pubspec.yaml', depth: 0, isDir: false),
  FileNode(icon: '📄', name: 'README.md',    depth: 0, isDir: false),
];

const String kDemoCode = '''import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Build the widget tree
    return MaterialApp(
      title: 'Zephyr Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _increment() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button:'),
            Text(
              '\$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

// ─── Initial Terminal Lines ────────────────────────────────────────────────────

List<TermLine> get kInitialTermLines => [
  const TermLine('zephyr@dev:~/project\$ flutter pub get', kTermGreen),
  const TermLine('Resolving dependencies...', kTextDim),
  const TermLine('  + cupertino_icons 1.0.8', kText),
  const TermLine('  + flutter_lints 4.0.0',   kText),
  const TermLine('Changed 2 dependencies!',   kString),
  const TermLine('', kText),
  const TermLine('zephyr@dev:~/project\$ flutter run -d chrome', kTermGreen),
  const TermLine('Launching lib/main.dart on Chrome...', kTextDim),
  const TermLine('✓ Built build/web', kString),
  const TermLine('', kText),
];
