import 'package:flutter/material.dart';
import '../theme/colors.dart';

// ─── Title Bar ─────────────────────────────────────────────────────────────────

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: kPanel,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        // Logo mark
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: kAccent.withOpacity(0.6), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'ZEPHYR',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: kAccent,
          ),
        ),
        const SizedBox(width: 24),
        // Menu items
        ..._kMenus.map((m) => _MenuBtn(label: m)),
        const Spacer(),
        // Decorative traffic lights
        _dot(const Color(0xFFFF5F57)),
        const SizedBox(width: 6),
        _dot(const Color(0xFFFFBD2E)),
        const SizedBox(width: 6),
        _dot(const Color(0xFF28CA42)),
      ]),
    );
  }

  Widget _dot(Color c) => Container(
    width: 12, height: 12,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );
}

const _kMenus = ['File', 'Edit', 'View', 'Run', 'Terminal'];

// ─── Menu Button ───────────────────────────────────────────────────────────────

class _MenuBtn extends StatefulWidget {
  final String label;
  const _MenuBtn({required this.label});

  @override
  State<_MenuBtn> createState() => _MenuBtnState();
}

class _MenuBtnState extends State<_MenuBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit:  (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _h ? kBorder : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: _h ? kText : kTextDim,
          ),
        ),
      ),
    );
  }
}
