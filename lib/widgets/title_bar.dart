import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: kPanel,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: kAccent,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: kAccent.withValues(alpha: 0.6), blurRadius: 8),
              ],
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
          const Spacer(),
          _WindowControls(),
        ],
      ),
    );
  }
}

class _WindowControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WindowButton(
          icon: Icons.remove,
          hoverColor: const Color(0xFFFF5F57).withValues(alpha: 0.2),
        ),
        const SizedBox(width: 8),
        _WindowButton(
          icon: Icons.crop_square,
          hoverColor: const Color(0xFFFFBD2E).withValues(alpha: 0.2),
        ),
        const SizedBox(width: 8),
        _WindowButton(
          icon: Icons.close,
          hoverColor: const Color(0xFFFF5F57).withValues(alpha: 0.2),
        ),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final Color hoverColor;

  const _WindowButton({required this.icon, required this.hoverColor});

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _hovered ? widget.hoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(widget.icon, size: 14, color: _hovered ? kText : kTextDim),
      ),
    );
  }
}
