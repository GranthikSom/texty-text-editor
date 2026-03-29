import 'package:flutter/material.dart';
import '../theme/colors.dart';

// ─── Resizable Divider ─────────────────────────────────────────────────────────

class ResizableDivider extends StatefulWidget {
  final bool vertical;
  const ResizableDivider({super.key, required this.vertical});

  @override
  State<ResizableDivider> createState() => _ResizableDividerState();
}

class _ResizableDividerState extends State<ResizableDivider> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width:  widget.vertical ? kDivSize : double.infinity,
        height: widget.vertical ? double.infinity : kDivSize,
        color: _hovered ? kAccent.withOpacity(0.5) : kBorder,
      ),
    );
  }
}

// ─── Icon Button ───────────────────────────────────────────────────────────────

class EditorIconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const EditorIconBtn({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  @override
  State<EditorIconBtn> createState() => _EditorIconBtnState();
}

class _EditorIconBtnState extends State<EditorIconBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit:  (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 26, height: 26,
            decoration: BoxDecoration(
              color: _h ? kBorder : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(widget.icon, size: 14, color: _h ? kText : kTextDim),
          ),
        ),
      ),
    );
  }
}

// ─── Panel Tab (reused in SidePanel & Terminal) ────────────────────────────────

class PanelTab extends StatelessWidget {
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const PanelTab({
    super.key,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? kAccent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.2,
              fontFamily: 'monospace',
              color: active ? kAccent : kTextDim,
              fontWeight: active ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
