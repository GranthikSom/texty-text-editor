import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/title_bar.dart';
import '../widgets/status_bar.dart';
import '../pages/side_panel_page.dart';
import '../pages/main_editor_page.dart';
import '../pages/terminal_page.dart';

// ─── Editor Shell ──────────────────────────────────────────────────────────────
///
/// Top-level layout that composes all three panels:
///   • [SidePanel]      — file explorer / git / search (left, resizable)
///   • [MainEditorPage] — code editor with tabs & line numbers (centre)
///   • [TerminalPage]   — interactive terminal (bottom, resizable)
///
/// It owns the resize state so dividers can update panel dimensions.

class EditorShell extends StatefulWidget {
  const EditorShell({super.key});

  @override
  State<EditorShell> createState() => _EditorShellState();
}

class _EditorShellState extends State<EditorShell> {
  double _sideWidth  = 220;
  double _termHeight = 180;

  @override
  Widget build(BuildContext context) {
    final size    = MediaQuery.of(context).size;
    final maxSide = size.width * 0.45;
    final maxTerm = size.height * 0.55;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        // ── Title bar ──────────────────────────────────────────────────────
        const TitleBar(),

        // ── Three-panel body ───────────────────────────────────────────────
        Expanded(child: Row(children: [

          // ── Side panel ──────────────────────────────────────────────────
          SizedBox(
            width: _sideWidth.clamp(kMinSide, maxSide),
            child: const SidePanel(),
          ),

          // ── Vertical resize divider ──────────────────────────────────────
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              onHorizontalDragUpdate: (d) => setState(() {
                _sideWidth = (_sideWidth + d.delta.dx).clamp(kMinSide, maxSide);
              }),
              child: const ResizableDivider(vertical: true),
            ),
          ),

          // ── Editor + Terminal column ─────────────────────────────────────
          Expanded(
            child: Column(children: [

              // Main editor
              const Expanded(child: MainEditorPage()),

              // Horizontal resize divider
              MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: GestureDetector(
                  onVerticalDragUpdate: (d) => setState(() {
                    _termHeight = (_termHeight - d.delta.dy)
                        .clamp(kMinTerm, maxTerm);
                  }),
                  child: const ResizableDivider(vertical: false),
                ),
              ),

              // Terminal
              SizedBox(
                height: _termHeight,
                child: const TerminalPage(),
              ),
            ]),
          ),
        ])),

        // ── Status bar ─────────────────────────────────────────────────────
        const StatusBar(),
      ]),
    );
  }
}
