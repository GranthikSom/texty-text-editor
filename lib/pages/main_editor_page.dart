import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';
import '../services/editor_state.dart';
import '../services/file_service.dart';

class MainEditorPage extends StatefulWidget {
  const MainEditorPage({super.key});

  @override
  State<MainEditorPage> createState() => _MainEditorPageState();
}

class _MainEditorPageState extends State<MainEditorPage> {
  final _ctrl = TextEditingController(text: kDemoCode);
  final _focus = FocusNode();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditorState>().setContent(_ctrl.text);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    context.read<EditorState>().setContent(text);
  }

  Future<void> _newFile() async {
    final state = context.read<EditorState>();
    if (state.isDirty) {
      final shouldSave = await _showSaveDialog();
      if (shouldSave == null) return;
      if (shouldSave) await _saveFile();
    }
    state.newFile();
    _ctrl.text = '';
  }

  Future<void> _openFile() async {
    final content = await FileService.openFile();
    if (content != null) {
      _ctrl.text = content;
      context.read<EditorState>().setContent(content);
    }
  }

  Future<void> _saveFile() async {
    final state = context.read<EditorState>();
    final path = await FileService.saveFile(
      _ctrl.text,
      currentPath: state.currentFilePath,
    );
    if (path != null) {
      final name = path.split('/').last;
      state.setFilePath(path, name);
    }
  }

  Future<bool?> _showSaveDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kPanel,
        title: Text('Save Changes?', style: TextStyle(color: kText)),
        content: Text(
          'Do you want to save your changes?',
          style: TextStyle(color: kTextDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Don't Save", style: TextStyle(color: kTermRed)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel', style: TextStyle(color: kTextDim)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Save', style: TextStyle(color: kAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN):
            const _NewFileIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyO):
            const _OpenFileIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS):
            const _SaveFileIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _NewFileIntent: CallbackAction<_NewFileIntent>(
            onInvoke: (_) => _newFile(),
          ),
          _OpenFileIntent: CallbackAction<_OpenFileIntent>(
            onInvoke: (_) => _openFile(),
          ),
          _SaveFileIntent: CallbackAction<_SaveFileIntent>(
            onInvoke: (_) => _saveFile(),
          ),
        },
        child: Focus(
          focusNode: _focus,
          autofocus: true,
          child: Container(
            color: kBg,
            child: Column(
              children: [
                _EditorTabBar(onNewFile: _newFile, onSaveFile: _saveFile),
                Expanded(
                  child: _EditorBody(
                    controller: _ctrl,
                    scrollController: _scrollCtrl,
                    onChanged: _onTextChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewFileIntent extends Intent {
  const _NewFileIntent();
}

class _OpenFileIntent extends Intent {
  const _OpenFileIntent();
}

class _SaveFileIntent extends Intent {
  const _SaveFileIntent();
}

class _EditorTabBar extends StatefulWidget {
  final VoidCallback onNewFile;
  final VoidCallback onSaveFile;

  const _EditorTabBar({required this.onNewFile, required this.onSaveFile});

  @override
  State<_EditorTabBar> createState() => _EditorTabBarState();
}

class _EditorTabBarState extends State<_EditorTabBar> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorState>(
      builder: (context, state, _) {
        return Container(
          height: 36,
          color: kPanel,
          child: Row(
            children: [
              _EditorTab(
                icon: '🎯',
                name: state.fileName + (state.isDirty ? ' •' : ''),
                active: _active == 0,
                onTap: () => setState(() => _active = 0),
                onClose: widget.onNewFile,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    EditorIconBtn(
                      icon: Icons.add,
                      tooltip: 'New File',
                      onTap: widget.onNewFile,
                    ),
                    const SizedBox(width: 4),
                    EditorIconBtn(
                      icon: Icons.save,
                      tooltip: 'Save',
                      onTap: widget.onSaveFile,
                    ),
                    const SizedBox(width: 4),
                    EditorIconBtn(
                      icon: Icons.vertical_split_rounded,
                      tooltip: 'Split Editor',
                    ),
                    const SizedBox(width: 4),
                    EditorIconBtn(
                      icon: Icons.more_horiz,
                      tooltip: 'More Actions',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EditorTab extends StatefulWidget {
  final String icon;
  final String name;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _EditorTab({
    required this.icon,
    required this.name,
    required this.active,
    required this.onTap,
    required this.onClose,
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
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onClose,
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
          child: Row(
            children: [
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
              GestureDetector(
                onTap: widget.onClose,
                child: Icon(
                  Icons.close,
                  size: 12,
                  color: widget.active ? kTextDim : kLineNum,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorBody extends StatefulWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final ValueChanged<String> onChanged;

  const _EditorBody({
    required this.controller,
    required this.scrollController,
    required this.onChanged,
  });

  @override
  State<_EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends State<_EditorBody> {
  @override
  Widget build(BuildContext context) {
    final lines = widget.controller.text.split('\n');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(width: 1, color: kBorder),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: TextField(
              controller: widget.controller,
              maxLines: null,
              expands: true,
              scrollController: widget.scrollController,
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
              onChanged: widget.onChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
