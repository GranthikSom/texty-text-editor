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
  final _focusNode = FocusNode();
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
              SizedBox(
                width: 48,
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  child: Padding(
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
                ),
              ),
              Container(width: 1, color: kBorder),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.all(8),
                      child: _buildHighlightedText(),
                    ),
                    GestureDetector(
                      onTap: () => _focusNode.requestFocus(),
                      child: TextField(
                        controller: _ctrl,
                        focusNode: _focusNode,
                        maxLines: null,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          color: Colors.transparent,
                          height: 1.43,
                        ),
                        cursorColor: kAccent,
                        cursorWidth: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(8),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightedText() {
    return RichText(
      text: TextSpan(
        children: _highlightCode(_ctrl.text),
        style: TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.43),
      ),
    );
  }

  List<TextSpan> _highlightCode(String code) {
    final List<TextSpan> spans = [];
    final lines = code.split('\n');

    final keywords = [
      'abstract',
      'as',
      'assert',
      'async',
      'await',
      'break',
      'case',
      'catch',
      'class',
      'const',
      'continue',
      'covariant',
      'default',
      'deferred',
      'do',
      'dynamic',
      'else',
      'enum',
      'export',
      'extends',
      'extension',
      'external',
      'factory',
      'false',
      'final',
      'finally',
      'for',
      'Function',
      'get',
      'hide',
      'if',
      'implements',
      'import',
      'in',
      'interface',
      'is',
      'late',
      'library',
      'mixin',
      'new',
      'null',
      'on',
      'operator',
      'part',
      'required',
      'rethrow',
      'return',
      'sealed',
      'set',
      'show',
      'static',
      'super',
      'switch',
      'sync',
      'this',
      'throw',
      'true',
      'try',
      'typedef',
      'var',
      'void',
      'while',
      'with',
      'yield',
      'int',
      'double',
      'String',
      'bool',
      'List',
      'Map',
      'Set',
      'Future',
      'Stream',
      'void',
      'print',
      'main',
      'runApp',
      'Widget',
      'State',
      'BuildContext',
    ];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final tokens = _tokenize(line);

      for (final token in tokens) {
        Color color = kText;

        if (token.startsWith('//')) {
          color = kComment;
        } else if (token.startsWith('"') || token.startsWith("'")) {
          color = kString;
        } else if (keywords.contains(token)) {
          color = kKeyword;
        } else if (token == 'true' || token == 'false') {
          color = kKeyword;
        } else if (token == 'null') {
          color = kKeyword;
        } else if (RegExp(r'^[0-9]+\.?[0-9]*$').hasMatch(token)) {
          color = kTermYellow;
        } else if (RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(token) &&
            token.length > 1) {
          color = kTermYellow;
        } else if (token.endsWith('(') && token.length > 1) {
          color = kAccent;
        }

        spans.add(
          TextSpan(
            text: token,
            style: TextStyle(color: color),
          ),
        );
      }

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }

  List<String> _tokenize(String line) {
    final List<String> tokens = [];
    String current = '';
    bool inString = false;
    String stringChar = '';

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (inString) {
        current += char;
        if (char == stringChar && (i == 0 || line[i - 1] != '\\')) {
          tokens.add(current);
          current = '';
          inString = false;
        }
        continue;
      }

      if (char == '"' || char == "'") {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        inString = true;
        stringChar = char;
        current = char;
        continue;
      }

      if (char == '/' && i + 1 < line.length && line[i + 1] == '/') {
        if (current.isNotEmpty) {
          tokens.add(current);
        }
        tokens.add(line.substring(i));
        break;
      }

      if (char == ' ' ||
          char == '\t' ||
          char == '(' ||
          char == ')' ||
          char == '{' ||
          char == '}' ||
          char == '[' ||
          char == ']' ||
          char == ';' ||
          char == ',' ||
          char == '.' ||
          char == '+' ||
          char == '-' ||
          char == '*' ||
          char == '/' ||
          char == '=' ||
          char == '<' ||
          char == '>' ||
          char == '!' ||
          char == '&' ||
          char == '|' ||
          char == '?' ||
          char == ':') {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        tokens.add(char);
        continue;
      }

      current += char;
    }

    if (current.isNotEmpty) {
      tokens.add(current);
    }

    return tokens;
  }
}
