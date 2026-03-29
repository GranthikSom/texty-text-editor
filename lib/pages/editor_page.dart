import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class EditorPage extends StatefulWidget {
  final String? filePath;

  const EditorPage({super.key, this.filePath});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  String? _currentFile;
  String _fileName = '[No Name]';

  @override
  void initState() {
    super.initState();
    _loadFile(widget.filePath);
  }

  @override
  void didUpdateWidget(EditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filePath != oldWidget.filePath) {
      _loadFile(widget.filePath);
    }
  }

  void _loadFile(String? path) {
    if (path == null) {
      setState(() {
        _currentFile = null;
        _fileName = '[No Name]';
        _ctrl.text = '';
      });
      return;
    }
    try {
      final file = File(path);
      if (file.existsSync()) {
        _ctrl.text = file.readAsStringSync();
        _currentFile = path;
        _fileName = path.split('/').last;
      } else {
        _ctrl.text = '';
        _fileName = path.split('/').last;
      }
    } catch (e) {
      _ctrl.text = '';
    }
    setState(() {});
  }

  void newFile() {
    setState(() {
      _currentFile = null;
      _fileName = '[No Name]';
      _ctrl.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lines = _ctrl.text.isEmpty ? [''] : _ctrl.text.split('\n');

    return Column(
      children: [
        Container(
          height: 28,
          color: kPanel,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                _fileName,
                style: TextStyle(
                  color: kText,
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: newFile,
                child: Icon(Icons.add, size: 14, color: kTextDim),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                color: kPanel,
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    lines.length,
                    (i) => SizedBox(
                      height: 20,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
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
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _ctrl,
                    maxLines: null,
                    expands: true,
                    scrollController: _scrollCtrl,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: kText,
                      height: 1.43,
                    ),
                    cursorColor: kAccent,
                    cursorWidth: 2,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
