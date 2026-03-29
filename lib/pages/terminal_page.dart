import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TerminalPage extends StatefulWidget {
  final String workingDirectory;
  final ValueChanged<String>? onDirectoryChanged;
  final VoidCallback? onClose;

  const TerminalPage({
    super.key,
    required this.workingDirectory,
    this.onDirectoryChanged,
    this.onClose,
  });

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final List<String> _output = [];
  String _currentDir = '';

  @override
  void initState() {
    super.initState();
    _currentDir = widget.workingDirectory;
    _output.add('Texty Terminal');
    _output.add('Working directory: $_currentDir');
    _output.add('');
  }

  @override
  void didUpdateWidget(TerminalPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workingDirectory != oldWidget.workingDirectory) {
      setState(() {
        _currentDir = widget.workingDirectory;
        _output.add('');
        _output.add('cd $_currentDir');
      });
    }
  }

  void _submit(String cmd) async {
    if (cmd.trim().isEmpty) {
      _output.add('$_currentDir \$ ');
      setState(() {});
      return;
    }

    _output.add('$_currentDir \$ $cmd');

    if (cmd.trim() == 'clear') {
      _output.clear();
      _input.clear();
      setState(() {});
      return;
    }

    if (cmd.trim().startsWith('cd ')) {
      final parts = cmd.trim().split(RegExp(r'\s+'));
      String newPath = parts.length > 1 ? parts[1] : '~';

      if (newPath == '~') {
        newPath = Platform.environment['HOME'] ?? '/';
      } else if (!newPath.startsWith('/')) {
        newPath = '$_currentDir/$newPath';
      }

      final normalized = _normalizePath(newPath);
      if (Directory(normalized).existsSync()) {
        _currentDir = normalized;
        widget.onDirectoryChanged?.call(_currentDir);
      } else {
        _output.add('cd: $normalized: No such directory');
      }
      _input.clear();
      _focus.requestFocus();
      setState(() {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
      return;
    }

    try {
      final shell = Platform.environment['SHELL'] ?? '/bin/zsh';
      final result = await Process.run(
        shell,
        ['-c', cmd],
        workingDirectory: _currentDir,
        environment: Platform.environment,
      );

      final output = String.fromCharCodes(result.stdout);
      final error = String.fromCharCodes(result.stderr);

      if (output.isNotEmpty) {
        _output.addAll(output.split('\n').where((l) => l.isNotEmpty));
      }
      if (error.isNotEmpty) {
        _output.addAll(error.split('\n').where((l) => l.isNotEmpty));
      }
    } catch (e) {
      _output.add('$cmd: command not found');
    }

    _input.clear();
    _focus.requestFocus();
    setState(() {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  String _normalizePath(String path) {
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    final result = <String>[];
    for (final part in parts) {
      if (part == '..') {
        if (result.isNotEmpty) result.removeLast();
      } else if (part != '.') {
        result.add(part);
      }
    }
    return '/${result.join('/')}';
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });

    return Container(
      color: kPanelAlt,
      child: Column(
        children: [
          Container(
            height: 28,
            color: kPanel,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  '~ terminal',
                  style: TextStyle(
                    color: kTextDim,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _output.clear();
                    setState(() {});
                  },
                  child: Icon(Icons.clear_all, size: 14, color: kTextDim),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Icon(Icons.close, size: 14, color: kTextDim),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(8),
              itemCount: _output.length + 1,
              itemBuilder: (context, index) {
                if (index == _output.length) {
                  return Row(
                    children: [
                      Text(
                        '$_currentDir \$ ',
                        style: TextStyle(
                          color: kTermGreen,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _input,
                          focusNode: _focus,
                          style: TextStyle(
                            color: kText,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                          cursorColor: kAccent,
                          cursorWidth: 2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          onSubmitted: _submit,
                        ),
                      ),
                    ],
                  );
                }
                return Text(
                  _output[index],
                  style: TextStyle(
                    color: kText,
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.5,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
