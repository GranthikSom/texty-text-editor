import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SyntaxHighlighter {
  static final List<String> keywords = [
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
  ];

  static final List<String> builtins = [
    'print',
    'main',
    'runApp',
    'build',
    'initState',
    'dispose',
    'setState',
    'buildContext',
    'Widget',
    ' StatelessWidget',
    'StatefulWidget',
    'State',
  ];

  static List<TextSpan> highlight(String code) {
    final List<TextSpan> spans = [];
    final List<String> tokens = _tokenize(code);

    for (final token in tokens) {
      spans.add(_createSpan(token));
    }

    return spans;
  }

  static List<String> _tokenize(String code) {
    final List<String> tokens = [];
    String current = '';
    bool inString = false;
    bool inComment = false;
    bool isMultilineComment = false;
    String stringChar = '';

    for (int i = 0; i < code.length; i++) {
      final char = code[i];
      final nextChar = i + 1 < code.length ? code[i + 1] : '';

      if (inComment) {
        if (isMultilineComment) {
          current += char;
          if (char == '*' && nextChar == '/') {
            current += nextChar;
            tokens.add(current);
            current = '';
            inComment = false;
            isMultilineComment = false;
            i++;
          }
        } else {
          if (char == '\n') {
            tokens.add(current);
            current = '';
            inComment = false;
          } else {
            current += char;
          }
        }
        continue;
      }

      if (inString) {
        current += char;
        if (char == stringChar && (i == 0 || code[i - 1] != '\\')) {
          tokens.add(current);
          current = '';
          inString = false;
        }
        continue;
      }

      if (char == '/' && nextChar == '/') {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        inComment = true;
        isMultilineComment = false;
        current = '//';
        i++;
        continue;
      }

      if (char == '/' && nextChar == '*') {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        inComment = true;
        isMultilineComment = true;
        current = '/*';
        i++;
        continue;
      }

      if (char == '"' || char == "'" || char == '`') {
        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }
        inString = true;
        stringChar = char;
        current = char;
        continue;
      }

      if (char == ' ' ||
          char == '\n' ||
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

  static TextSpan _createSpan(String token) {
    Color color = kText;

    if (token.startsWith('//') || token.startsWith('/*')) {
      color = kComment;
    } else if (token.startsWith('"') ||
        token.startsWith("'") ||
        token.startsWith('`')) {
      color = kString;
    } else if (keywords.contains(token)) {
      color = kKeyword;
    } else if (token == 'true' || token == 'false') {
      color = kKeyword;
    } else if (token == 'null') {
      color = kKeyword;
    } else if (RegExp(r'^[0-9]+\.?[0-9]*$').hasMatch(token)) {
      color = kTermYellow;
    } else if (RegExp(r'^[A-Z][a-zA-Z0-9]*').hasMatch(token) &&
        token.length > 1) {
      color = kTermYellow;
    } else if (token.endsWith('(') && token.length > 1) {
      color = kAccent;
    } else if (RegExp(r'^[a-z][a-zA-Z0-9]*$').hasMatch(token) &&
        token.length > 2) {
      if (!keywords.contains(token)) {
        color = kText;
      }
    }

    return TextSpan(
      text: token,
      style: TextStyle(color: color),
    );
  }
}
