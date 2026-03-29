import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/window_controller.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    _checkMaximized();
  }

  Future<void> _checkMaximized() async {
    final isMax = await WindowController.isMaximized();
    if (mounted) {
      setState(() => _isMaximized = isMax);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => WindowController.startDragging(),
      child: Container(
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
                  BoxShadow(color: kAccent.withOpacity(0.6), blurRadius: 8),
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
            _WindowControls(
              isMaximized: _isMaximized,
              onMaximize: _checkMaximized,
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowControls extends StatelessWidget {
  final bool isMaximized;
  final VoidCallback onMaximize;

  const _WindowControls({required this.isMaximized, required this.onMaximize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _WindowButton(
          icon: Icons.remove,
          onPressed: () => WindowController.minimize(),
          hoverColor: const Color(0xFFFF5F57).withOpacity(0.2),
        ),
        const SizedBox(width: 8),
        _WindowButton(
          icon: isMaximized ? Icons.filter_none : Icons.crop_square,
          onPressed: () async {
            await WindowController.maximize();
            onMaximize();
          },
          hoverColor: const Color(0xFFFFBD2E).withOpacity(0.2),
        ),
        const SizedBox(width: 8),
        _WindowButton(
          icon: Icons.close,
          onPressed: () => WindowController.close(),
          hoverColor: const Color(0xFFFF5F57).withOpacity(0.2),
        ),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.hoverColor,
  });

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
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _hovered ? widget.hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 14,
            color: _hovered ? kText : kTextDim,
          ),
        ),
      ),
    );
  }
}
