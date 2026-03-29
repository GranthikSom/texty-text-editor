import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

// ─── Main Editor Page ──────────────────────────────────────────────────────────

class MainEditorPage extends StatefulWidget {
  const MainEditorPage({super.key});

  @override
  State<MainEditorPage> createState() => _MainEditorPageState();
}

class _MainEditorPageState extends State<MainEditorPage> {
  final _ctrl = TextEditingController(text: kDemoCode);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBg,
      child: Column(children: [
        _EditorTabBar(),
        Expanded(child: _EditorBody(controller: _ctrl)),
      ]),
    );
  }
}

// ─── Editor Tab Bar ────────────────────────────────────────────────────────────

class _EditorTabBar extends StatefulWidget {
  @override
  State<_EditorTabBar> createState() => _EditorTabBarState();
}

class _EditorTabBarState extends State<_EditorTabBar> {
  int _active = 0;
  final _tabs = [
    {'icon': '🎯', 'name': 'main.dart'},
    {'icon': '🎯', 'name': 'app.dart'},
    {'icon': '📄', 'name': 'pubspec.yaml'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: kPanel,
      child: Row(children: [
        ...List.generate(_tabs.length, (i) => _EditorTab(
          icon: _tabs[i]['icon']!,
          name: _tabs[i]['name']!,
          active: _active == i,
          onTap: () => setState(() => _active = i),
        )),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            EditorIconBtn(icon: Icons.vertical_split_rounded, tooltip: 'Split Editor'),
            const SizedBox(width: 4),
            EditorIconBtn(icon: Icons.more_horiz, tooltip: 'More Actions'),
          ]),
        ),
      ]),
    );
  }
}

// ─── Single Editor Tab ─────────────────────────────────────────────────────────

class _EditorTab extends StatefulWidget {
  final String icon;
  final String name;
  final bool active;
  final VoidCallback onTap;

  const _EditorTab({
    required this.icon,
    required this.name,
    required this.active,
    required this.onTap,
  });

  @override
  State<_EditorTab> createState() => _EditorTabState();
}

class _EditorTabState extends State<_EditorTab> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: widget.active ? kBg : (_hov ? kPanelAlt : kPanel),
            border: Border(
              right: const BorderSide(color: kBorder),
              bottom: BorderSide(
                color: widget.active ? kAccent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(children: [
            Text(widget.icon, style: const TextStyle(fontSize: 11)),
            const SizedBox(width: 6),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: widget.active ? kText : kTextDim,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.close,
              size: 12,
              color: widget.active ? kTextDim : kLineNum,
            ),
          ]),
        ),
      ),
    );
  }
}

// ─── Editor Body (line numbers + code field) ───────────────────────────────────

class _EditorBody extends StatefulWidget {
  final TextEditingController controller;
  const _EditorBody({required this.controller});

  @override
  State<_EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends State<_EditorBody> {
  final _scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final lines = widget.controller.text.split('\n');

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ── Line numbers ────────────────────────────────────────────────────
      Container(
        width: 52,
        color: kBg,
        padding: const EdgeInsets.only(top: 12, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            lines.length,
            (i) => SizedBox(
              height: 20,
              child: Text(
                '${i + 1}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: kLineNum,
                ),
              ),
            ),
          ),
        ),
      ),
      // ── Thin gutter border ──────────────────────────────────────────────
      Container(width: 1, color: kBorder),
      // ── Code text field ─────────────────────────────────────────────────
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: TextField(
            controller: widget.controller,
            maxLines: null,
            expands: true,
            scrollController: _scrollCtrl,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: kText,
              height: 1.54,
            ),
            cursorColor: kAccent,
            cursorWidth: 2,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ),
      const SizedBox(width: 12),
    ]);
  }
}
