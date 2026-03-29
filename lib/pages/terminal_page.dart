import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TerminalPage extends StatefulWidget {
  final String workingDirectory;
  final ValueChanged<String>? onDirectoryChanged;

  const TerminalPage({
    super.key,
    required this.workingDirectory,
    this.onDirectoryChanged,
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
  Process? _shell;

  @override
  void initState() {
    super.initState();
    _currentDir = widget.workingDirectory;
    _output.add('Texty Terminal v1.0');
    _output.add('Type "help" for available commands.');
    _output.add('');
    _startShell();
  }

  Future<void> _startShell() async {
    try {
      _shell = await Process.start(
        Platform.environment['SHELL'] ?? '/bin/zsh',
        [],
        workingDirectory: _currentDir,
        environment: Platform.environment,
      );

      _shell!.stdout.listen((data) {
        final output = String.fromCharCodes(data);
        setState(() {
          _output.addAll(output.split('\n'));
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        });
      });

      _shell!.stderr.listen((data) {
        final output = String.fromCharCodes(data);
        setState(() {
          _output.add(output);
        });
      });
    } catch (e) {
      _output.add('Failed to start shell: $e');
    }
  }

  @override
  void didUpdateWidget(TerminalPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workingDirectory != oldWidget.workingDirectory) {
      _currentDir = widget.workingDirectory;
      _shell?.kill();
      _startShell();
    }
  }

  void _submit(String cmd) async {
    if (cmd.trim().isEmpty) {
      _output.add('$_currentDir \$ ');
      setState(() {});
      return;
    }

    _output.add('$_currentDir \$ $cmd');

    if (_shell != null) {
      _shell!.stdin.writeln(cmd);
    } else {
      final result = await _executeDart(cmd);
      if (result.isNotEmpty) {
        _output.addAll(result);
      }
    }

    _input.clear();
    _focus.requestFocus();
    setState(() {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  Future<List<String>> _executeDart(String cmd) async {
    final parts = cmd.trim().split(' ');

    switch (parts[0].toLowerCase()) {
      case 'help':
        return [
          'Available commands:',
          '  ls [path]     - List directory contents',
          '  cd <path>     - Change directory',
          '  pwd           - Print working directory',
          '  cat <file>    - Display file contents',
          '  clear         - Clear terminal',
          '  mkdir <name>  - Create directory',
          '  touch <name>  - Create file',
          '  rm <name>     - Remove file/directory',
          '  echo <text>  - Print text',
          '  date          - Show current date/time',
          '  whoami        - Show current user',
          '  flutter       - Run Flutter commands',
          '  dart          - Run Dart commands',
          '  exit          - Exit application',
        ];

      case 'clear':
        _output.clear();
        return [];

      case 'cd':
        if (parts.length == 1 || parts[1] == '~') {
          _currentDir = Platform.environment['HOME'] ?? '/';
        } else {
          String newPath = parts[1];
          if (!newPath.startsWith('/')) {
            newPath = '$_currentDir/$newPath';
          }
          final normalized = _normalizePath(newPath);
          if (Directory(normalized).existsSync()) {
            _currentDir = normalized;
            widget.onDirectoryChanged?.call(_currentDir);
          } else {
            return ['cd: $normalized: No such directory'];
          }
        }
        return [];

      case 'pwd':
        return [_currentDir];

      case 'ls':
        String path = parts.length > 1 ? parts[1] : _currentDir;
        if (!path.startsWith('/')) {
          path = '$_currentDir/$path';
        }
        path = _normalizePath(path);

        try {
          final dir = Directory(path);
          if (!dir.existsSync()) {
            return ['ls: $path: No such directory'];
          }
          final items = dir.listSync();
          items.sort((a, b) {
            if (a is Directory && b is! Directory) return -1;
            if (a is! Directory && b is Directory) return 1;
            return a.path.split('/').last.compareTo(b.path.split('/').last);
          });
          return items.map((e) {
            final name = e.path.split('/').last;
            if (e is Directory) {
              return '$name/';
            }
            return name;
          }).toList();
        } catch (e) {
          return ['ls: $path: Cannot access'];
        }

      case 'cat':
        if (parts.length < 2) {
          return ['cat: missing file operand'];
        }
        String path = parts[1];
        if (!path.startsWith('/')) {
          path = '$_currentDir/$path';
        }
        path = _normalizePath(path);

        try {
          final file = File(path);
          if (!file.existsSync()) {
            return ['cat: $path: No such file'];
          }
          return file.readAsStringSync().split('\n');
        } catch (e) {
          return ['cat: $path: Cannot read'];
        }

      case 'mkdir':
        if (parts.length < 2) {
          return ['mkdir: missing operand'];
        }
        String path = parts[1];
        if (!path.startsWith('/')) {
          path = '$_currentDir/$path';
        }
        path = _normalizePath(path);

        try {
          Directory(path).createSync();
          return [];
        } catch (e) {
          return ['mkdir: cannot create directory'];
        }

      case 'touch':
        if (parts.length < 2) {
          return ['touch: missing file operand'];
        }
        String path = parts[1];
        if (!path.startsWith('/')) {
          path = '$_currentDir/$path';
        }
        path = _normalizePath(path);

        try {
          File(path).createSync();
          return [];
        } catch (e) {
          return ['touch: cannot create file'];
        }

      case 'rm':
        if (parts.length < 2) {
          return ['rm: missing operand'];
        }
        String path = parts[1];
        if (!path.startsWith('/')) {
          path = '$_currentDir/$path';
        }
        path = _normalizePath(path);

        try {
          final type = FileSystemEntity.typeSync(path);
          if (type == FileSystemEntityType.directory) {
            Directory(path).deleteSync();
          } else if (type == FileSystemEntityType.file) {
            File(path).deleteSync();
          } else {
            return ['rm: $path: No such file or directory'];
          }
          return [];
        } catch (e) {
          return ['rm: cannot remove $path'];
        }

      case 'echo':
        return [parts.sublist(1).join(' ')];

      case 'date':
        return [DateTime.now().toString()];

      case 'whoami':
        return [Platform.environment['USER'] ?? 'unknown'];

      case 'exit':
        _shell?.kill();
        exit(0);

      case 'flutter':
      case 'dart':
        return _runCommand(cmd);

      default:
        return _runCommand(cmd);
    }
  }

  Future<List<String>> _runCommand(String cmd) async {
    try {
      final result = await Process.run(
        cmd.split(' ')[0],
        cmd.split(' ').length > 1 ? cmd.split(' ').sublist(1) : [],
        workingDirectory: _currentDir,
        environment: Platform.environment,
      );

      final output = String.fromCharCodes(result.stdout);
      final error = String.fromCharCodes(result.stderr);

      if (output.isNotEmpty) {
        return output.split('\n');
      }
      if (error.isNotEmpty) {
        return error.split('\n');
      }
      return [];
    } catch (e) {
      return ['$cmd: command not found'];
    }
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
    _shell?.kill();
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const Text(
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
                  child: const Icon(Icons.close, size: 14, color: kTextDim),
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
                        style: const TextStyle(
                          color: kTermGreen,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _input,
                          focusNode: _focus,
                          style: const TextStyle(
                            color: kText,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                          cursorColor: kAccent,
                          cursorWidth: 2,
                          decoration: const InputDecoration(
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
                  style: const TextStyle(
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
