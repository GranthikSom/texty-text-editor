import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/colors.dart';
import 'editor_page.dart';
import 'terminal_page.dart';

class VimShell extends StatefulWidget {
  const VimShell({super.key});

  @override
  State<VimShell> createState() => _VimShellState();
}

class _VimShellState extends State<VimShell> {
  int _mode = 0;
  final _commandCtrl = TextEditingController();
  final _commandFocus = FocusNode();
  final _searchCtrl = TextEditingController();
  String _currentPath = '';
  String _projectPath = '';
  bool _isProjectOpen = false;
  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> _filteredFiles = [];
  int _selectedIndex = 0;
  double _sidebarWidth = 220;
  bool _showSidebar = true;
  String? _currentFile;

  @override
  void initState() {
    super.initState();
    _openFolderDialog();
  }

  Future<void> _openFolderDialog() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        _projectPath = result;
        _currentPath = result;
        _isProjectOpen = true;
        _loadFiles();
      });
    }
  }

  void _loadFiles() {
    try {
      final dir = Directory(_currentPath);
      _files = dir.listSync()
        ..sort((a, b) {
          if (a is Directory && b is! Directory) return -1;
          if (a is! Directory && b is Directory) return 1;
          return a.path.split('/').last.compareTo(b.path.split('/').last);
        });
      _filteredFiles = List.from(_files);
      _filterFiles();
    } catch (e) {
      _files = [];
      _filteredFiles = [];
    }
  }

  void _filterFiles() {
    final query = _searchCtrl.text.toLowerCase();
    if (query.isEmpty) {
      _filteredFiles = List.from(_files);
    } else {
      _filteredFiles = _files
          .where((f) => f.path.split('/').last.toLowerCase().contains(query))
          .toList();
    }
    setState(() {});
  }

  void _navigateUp() {
    if (_currentPath != '/') {
      final parts = _currentPath.split('/');
      parts.removeLast();
      setState(() {
        _currentPath = parts.isEmpty ? '/' : parts.join('/');
        _loadFiles();
        _selectedIndex = 0;
      });
    }
  }

  void _openFile(String path) {
    setState(() {
      _currentFile = path;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _showSidebar = !_showSidebar;
    });
  }

  void _changeTheme() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kPanel,
        title: Text('Select Theme', style: TextStyle(color: kText)),
        content: SizedBox(
          width: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: themes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(themes[index].name, style: TextStyle(color: kText)),
                selected: currentThemeIndex == index,
                selectedTileColor: kAccent.withValues(alpha: 0.2),
                onTap: () {
                  setState(() {
                    currentThemeIndex = index;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: kTextDim)),
          ),
        ],
      ),
    );
  }

  Future<void> _openFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        _projectPath = result;
        _currentPath = result;
        _isProjectOpen = true;
        _loadFiles();
        _selectedIndex = 0;
        _currentFile = null;
      });
    }
  }

  void _closeFolder() {
    setState(() {
      _isProjectOpen = false;
      _projectPath = '';
      _currentPath = '';
      _files = [];
      _filteredFiles = [];
      _selectedIndex = 0;
      _currentFile = null;
      _searchCtrl.clear();
    });
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (_mode == 0) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyI:
          setState(() => _mode = 1);
          break;
        case LogicalKeyboardKey.keyJ:
          if (_selectedIndex < _filteredFiles.length - 1) {
            setState(() => _selectedIndex++);
          }
          break;
        case LogicalKeyboardKey.keyK:
          if (_selectedIndex > 0) {
            setState(() => _selectedIndex--);
          }
          break;
        case LogicalKeyboardKey.keyL:
          if (_filteredFiles.isNotEmpty) {
            final item = _filteredFiles[_selectedIndex];
            if (item is Directory) {
              setState(() {
                _currentPath = item.path;
                _loadFiles();
                _selectedIndex = 0;
              });
            } else {
              _openFile(item.path);
            }
          }
          break;
        case LogicalKeyboardKey.keyH:
          _navigateUp();
          break;
        case LogicalKeyboardKey.keyB:
          _toggleSidebar();
          break;
        case LogicalKeyboardKey.keyQ:
          exit(0);
        case LogicalKeyboardKey.semicolon:
          if (HardwareKeyboard.instance.isShiftPressed) {
            setState(() => _mode = 2);
            _commandFocus.requestFocus();
          }
          break;
      }
    } else if (_mode == 2) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() => _mode = 0);
        _commandCtrl.clear();
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _executeCommand(_commandCtrl.text);
        setState(() => _mode = 0);
        _commandCtrl.clear();
      }
    }
  }

  void _executeCommand(String cmd) {
    final parts = cmd.trim().split(' ');
    switch (parts[0]) {
      case 'q':
        exit(0);
      case 'w':
        break;
      case 'wq':
        exit(0);
      case 'e':
        if (parts.length > 1) {
          setState(() {
            _currentPath = parts[1];
            _loadFiles();
            _selectedIndex = 0;
          });
        }
        break;
      case 'r':
        _loadFiles();
        break;
      case 'b':
        _toggleSidebar();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKey,
      autofocus: true,
      child: Scaffold(
        backgroundColor: kBg,
        body: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: Row(
                children: [
                  if (_showSidebar) _buildSidebar(),
                  if (_showSidebar) _buildDivider(),
                  Expanded(child: _buildEditor()),
                ],
              ),
            ),
            _buildTerminal(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 28,
      color: kAccent,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            'TEXTY${_currentFile != null ? ' - ${_currentFile!.split('/').last}' : ''}',
            style: TextStyle(
              color: kBg,
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _changeTheme,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.palette, size: 12, color: kAccent),
                  const SizedBox(width: 4),
                  Text(
                    currentTheme.name,
                    style: TextStyle(
                      color: kAccent,
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    if (!_isProjectOpen) {
      return Container(
        width: _sidebarWidth,
        color: kPanel,
        child: Column(
          children: [
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  Text(
                    'EXPLORER',
                    style: TextStyle(
                      color: kTextDim,
                      fontFamily: 'monospace',
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _openFolderDialog,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: kBorder,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.folder_open,
                          size: 40,
                          color: kAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Open a folder to\nget started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kTextDim,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: _sidebarWidth,
      color: kPanel,
      child: Column(
        children: [
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: kBorder)),
            ),
            child: Row(
              children: [
                Text(
                  'EXPLORER',
                  style: TextStyle(
                    color: kTextDim,
                    fontFamily: 'monospace',
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _openFolder,
                  child: Icon(Icons.folder_open, size: 14, color: kTextDim),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _navigateUp,
                  child: Icon(Icons.arrow_upward, size: 14, color: kTextDim),
                ),
              ],
            ),
          ),
          Container(
            height: 28,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: kBorder),
            ),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(
                color: kText,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
              cursorColor: kAccent,
              cursorWidth: 1,
              decoration: InputDecoration(
                hintText: 'Search files...',
                hintStyle: TextStyle(color: kLineNum, fontSize: 11),
                prefixIcon: Icon(Icons.search, size: 14, color: kTextDim),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6),
              ),
              onChanged: (_) => _filterFiles(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: kBorder.withValues(alpha: 0.3),
            child: Row(
              children: [
                Icon(Icons.folder, size: 12, color: kAccent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _currentPath,
                    style: TextStyle(
                      color: kTextDim,
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFiles.length,
              itemBuilder: (context, index) {
                final item = _filteredFiles[index];
                final isDir = item is Directory;
                final name = item.path.split('/').last;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  onDoubleTap: () {
                    if (isDir) {
                      setState(() {
                        _currentPath = item.path;
                        _loadFiles();
                        _selectedIndex = 0;
                        _searchCtrl.clear();
                        _filterFiles();
                      });
                    } else {
                      _openFile(item.path);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    color: _selectedIndex == index
                        ? kAccent.withValues(alpha: 0.2)
                        : Colors.transparent,
                    child: Row(
                      children: [
                        Text(
                          isDir ? '📁' : '📄',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: _selectedIndex == index ? kAccent : kText,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: kBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _openFolder,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open, size: 12, color: kText),
                          const SizedBox(width: 4),
                          Text(
                            'Open Folder',
                            style: TextStyle(
                              color: kText,
                              fontFamily: 'monospace',
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _closeFolder,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.close, size: 14, color: kTextDim),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (d) => setState(() {
          _sidebarWidth = (_sidebarWidth + d.delta.dx).clamp(150.0, 400.0);
        }),
        child: Container(width: 4, color: kBorder),
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      color: kBg,
      child: EditorPage(key: ValueKey(_currentFile), filePath: _currentFile),
    );
  }

  Widget _buildTerminal() {
    return SizedBox(
      height: 180,
      child: TerminalPage(
        workingDirectory: _currentPath.isEmpty ? '/' : _currentPath,
        onDirectoryChanged: (path) {
          setState(() {
            _currentPath = path;
            _loadFiles();
          });
        },
      ),
    );
  }
}
