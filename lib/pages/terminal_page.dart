import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

// ─── Terminal Page ─────────────────────────────────────────────────────────────

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final _input  = TextEditingController();
  final _scroll = ScrollController();
  final _focus  = FocusNode();
  int _tab = 0;

  late final List<TermLine> _lines;

  @override
  void initState() {
    super.initState();
    _lines = List.from(kInitialTermLines);
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit(String val) {
    if (val.trim().isEmpty) return;
    setState(() {
      _lines.add(TermLine('zephyr@dev:~/project\$ $val', kTermGreen));
      _lines.add(TermLine(_fakeOutput(val), kText));
      _lines.add(const TermLine('', kText));
    });
    _input.clear();
    _focus.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearTerminal() => setState(() => _lines.clear());

  String _fakeOutput(String cmd) {
    final c = cmd.trim().toLowerCase();
    if (c == 'clear')           { _clearTerminal(); return ''; }
    if (c == 'help')            return 'Available: flutter, dart, ls, pwd, echo, clear';
    if (c.startsWith('flutter'))return 'Running flutter command... ✓';
    if (c.startsWith('dart'))   return 'Dart VM service: http://127.0.0.1:8181/';
    if (c == 'ls')              return 'lib/  test/  pubspec.yaml  README.md  analysis_options.yaml';
    if (c == 'pwd')             return '/home/user/zephyr_project';
    if (c.startsWith('echo '))  return cmd.substring(5);
    if (c == 'git status')      return 'On branch main\n2 files modified, 1 new file';
    if (c == 'git log')         return 'commit a3f9b12  HEAD -> main\nAuthor: dev\nDate: today\n\n    Initial commit';
    return 'zsh: command not found: $cmd';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPanelAlt,
      child: Column(children: [
        // ── Tab bar ──────────────────────────────────────────────────────
        _TerminalTabBar(
          current: _tab,
          onTabChanged: (i) => setState(() => _tab = i),
          onClear: _clearTerminal,
        ),
        // ── Content area ─────────────────────────────────────────────────
        Expanded(child: switch (_tab) {
          1 => const _ProblemsView(),
          2 => const _OutputView(),
          _ => _TerminalOutput(lines: _lines, scrollController: _scroll),
        }),
        // ── Input row ────────────────────────────────────────────────────
        if (_tab == 0) _TerminalInput(
          controller: _input,
          focusNode: _focus,
          onSubmit: _submit,
        ),
      ]),
    );
  }
}

// ─── Terminal Tab Bar ──────────────────────────────────────────────────────────

class _TerminalTabBar extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onClear;

  const _TerminalTabBar({
    required this.current,
    required this.onTabChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: const BoxDecoration(
        color: kPanel,
        border: Border(
          top:    BorderSide(color: kBorder),
          bottom: BorderSide(color: kBorder),
        ),
      ),
      child: Row(children: [
        PanelTab(label: 'TERMINAL', index: 0, current: current, onTap: onTabChanged),
        PanelTab(label: 'PROBLEMS', index: 1, current: current, onTap: onTabChanged),
        PanelTab(label: 'OUTPUT',   index: 2, current: current, onTap: onTabChanged),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: [
            EditorIconBtn(icon: Icons.add,            tooltip: 'New Terminal'),
            const SizedBox(width: 4),
            EditorIconBtn(icon: Icons.delete_outline, tooltip: 'Clear', onTap: onClear),
            const SizedBox(width: 4),
            EditorIconBtn(icon: Icons.minimize,       tooltip: 'Minimise'),
          ]),
        ),
      ]),
    );
  }
}

// ─── Terminal Output ───────────────────────────────────────────────────────────

class _TerminalOutput extends StatelessWidget {
  final List<TermLine> lines;
  final ScrollController scrollController;

  const _TerminalOutput({required this.lines, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: lines.length,
      itemBuilder: (_, i) => Text(
        lines[i].text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: lines[i].color,
          height: 1.6,
        ),
      ),
    );
  }
}

// ─── Terminal Input ────────────────────────────────────────────────────────────

class _TerminalInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmit;

  const _TerminalInput({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '›',
            style: const TextStyle(
              color: kTermGreen,
              fontSize: 16,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          style: const TextStyle(
            fontFamily: 'monospace', fontSize: 12, color: kText,
          ),
          cursorColor: kAccent,
          cursorWidth: 2,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Type a command... (try: ls, flutter run, git status)',
            hintStyle: TextStyle(
              color: kLineNum, fontFamily: 'monospace', fontSize: 12,
            ),
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          onSubmitted: onSubmit,
        )),
      ]),
    );
  }
}

// ─── Problems View ─────────────────────────────────────────────────────────────

class _ProblemsView extends StatelessWidget {
  const _ProblemsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _problemItem(Icons.warning_amber_rounded, kTermYellow,
            'main.dart', 12, 'Prefer const with constant constructors.'),
        _problemItem(Icons.warning_amber_rounded, kTermYellow,
            'app.dart',   7, 'Avoid print calls in production code.'),
        _problemItem(Icons.info_outline_rounded,  const Color(0xFF89B4FA),
            'pubspec.yaml', 1, 'Package flutter_lints has a newer version available.'),
      ],
    );
  }

  Widget _problemItem(IconData icon, Color color, String file, int line, String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(msg, style: const TextStyle(
            fontFamily: 'monospace', fontSize: 12, color: kText,
          )),
          const SizedBox(height: 2),
          Text('$file : line $line', style: const TextStyle(
            fontFamily: 'monospace', fontSize: 10, color: kTextDim,
          )),
        ])),
      ]),
    );
  }
}

// ─── Output View ───────────────────────────────────────────────────────────────

class _OutputView extends StatelessWidget {
  const _OutputView();

  @override
  Widget build(BuildContext context) {
    const lines = [
      '[flutter_tools] Compiling lib/main.dart for the Web...',
      '[flutter_tools] lib/main.dart compiled.',
      '[dart_dev] Running analysis...',
      '[dart_dev] No issues found.',
      '[hot_reload] Hot reload performed in 234ms.',
    ];
    return ListView(
      padding: const EdgeInsets.all(10),
      children: lines.map((l) => Text(l,
        style: const TextStyle(
          fontFamily: 'monospace', fontSize: 12, color: kTextDim, height: 1.7,
        ),
      )).toList(),
    );
  }
}
