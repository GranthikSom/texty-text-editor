import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../services/editor_state.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorState>(
      builder: (context, state, _) {
        return Container(
          height: 24,
          color: kAccent.withOpacity(0.12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _StatusItem(
                '⎇ ${state.fileName}${state.isDirty ? " (modified)" : ""}',
              ),
              const _StatusItem('✓ 0 errors'),
              const _StatusItem('⚠ 2 warnings'),
              const Spacer(),
              const _StatusItem('Dart'),
              const _StatusItem('UTF-8'),
              _StatusItem('Ln ${state.cursorLine}, Col ${state.cursorColumn}'),
              const _StatusItem('Flutter 3.x'),
            ],
          ),
        );
      },
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  const _StatusItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontFamily: 'monospace',
          color: kAccentDim,
        ),
      ),
    );
  }
}
