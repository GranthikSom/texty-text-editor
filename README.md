# Zephyr Editor

A modern, cross-platform text editor built with Flutter.

## Features

- **File Explorer** - Browse and manage project files
- **Code Editor** - Syntax highlighting with line numbers
- **Integrated Terminal** - Run commands directly in the editor
- **Git Integration** - View staged and unstaged changes
- **Search** - Find files and content across your project
- **Resizable Panels** - Drag to resize sidebar and terminal
- **Native Window Controls** - Close, minimize, and maximize windows

## Getting Started

### Prerequisites

- Flutter SDK 3.11.1 or higher
- macOS 10.15 or higher (for macOS development)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd texty

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Building for macOS

```bash
flutter build macos
```

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| New File | ⌘N |
| Open File | ⌘O |
| Save | ⌘S |
| Undo | ⌘Z |
| Redo | ⇧⌘Z |
| Cut | ⌘X |
| Copy | ⌘C |
| Paste | ⌘V |
| Select All | ⌘A |
| Toggle Sidebar | ⌘B |
| Toggle Terminal | ⌘` |
| Run | ⌘R |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── colors.dart           # Color theme
├── models/
│   └── models.dart           # Data models
├── pages/
│   ├── editor_shell.dart     # Main layout
│   ├── main_editor_page.dart # Editor view
│   ├── side_panel_page.dart  # File explorer
│   └── terminal_page.dart    # Terminal
├── widgets/
│   ├── title_bar.dart        # Custom title bar
│   ├── status_bar.dart       # Status bar
│   └── shared_widgets.dart   # Reusable widgets
└── services/
    └── window_controller.dart # Window controls
```

## License

MIT License
