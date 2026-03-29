import 'package:flutter/material.dart';

class EditorState extends ChangeNotifier {
  String _content = '';
  String? _currentFilePath;
  String _fileName = 'untitled.dart';
  bool _isDirty = false;
  int _cursorLine = 1;
  int _cursorColumn = 1;

  String get content => _content;
  String? get currentFilePath => _currentFilePath;
  String get fileName => _fileName;
  bool get isDirty => _isDirty;
  int get cursorLine => _cursorLine;
  int get cursorColumn => _cursorColumn;

  void setContent(String content) {
    _content = content;
    _isDirty = true;
    notifyListeners();
  }

  void setFilePath(String? path, String name) {
    _currentFilePath = path;
    _fileName = name;
    _isDirty = false;
    notifyListeners();
  }

  void markSaved() {
    _isDirty = false;
    notifyListeners();
  }

  void newFile() {
    _content = '';
    _currentFilePath = null;
    _fileName = 'untitled.dart';
    _isDirty = false;
    _cursorLine = 1;
    _cursorColumn = 1;
    notifyListeners();
  }

  void updateCursorPosition(int line, int column) {
    _cursorLine = line;
    _cursorColumn = column;
    notifyListeners();
  }
}
