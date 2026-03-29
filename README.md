# Texty - Vim-like Code Editor

A modern, lightweight code editor with vim-style keybindings built with Flutter.

## Features

- **Vim-style Editing** - Normal, Insert, and Command modes
- **File Explorer** - Browse and navigate your project files
- **Search** - Find files quickly in the sidebar
- **Integrated Terminal** - Run commands directly in the editor
- **Syntax Highlighting** - Basic code highlighting with line numbers

## Getting Started

### Prerequisites

- Flutter SDK 3.11.1 or higher
- macOS 10.15 or higher

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd texty

# Get dependencies
flutter pub get

# Run the app
flutter run -d macos
```

### Building for macOS

```bash
flutter build macos
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `i` | Enter Insert mode |
| `Esc` | Return to Normal mode |
| `:` | Enter Command mode |
| `j` | Navigate down (in explorer) |
| `k` | Navigate up (in explorer) |
| `l` | Open file/folder (in explorer) |
| `h` | Go to parent directory |
| `b` | Toggle sidebar |
| `q` | Quit application |
| `:q` | Quit (Command mode) |
| `:e <path>` | Open path |
| `:r` | Refresh files |

## Terminal Commands

- `ls [path]` - List directory contents
- `cd <path>` - Change directory
- `pwd` - Print working directory
- `cat <file>` - Display file contents
- `mkdir <name>` - Create directory
- `touch <name>` - Create file
- `rm <name>` - Remove file/directory
- `clear` - Clear terminal
- `help` - Show available commands
- `exit` - Exit application

## Screenshots

<!-- Add your screenshots below -->

![Screenshot 1](screenshots/screenshot1.png)

## Project Structure

```
lib/
├── main.dart              # App entry point
├── theme/
│   └── colors.dart        # Color theme
├── pages/
│   ├── vim_shell.dart     # Main vim shell
│   ├── editor_page.dart   # Code editor
│   └── terminal_page.dart # Terminal
└── widgets/
    └── shared_widgets.dart
```

## License

MIT License
