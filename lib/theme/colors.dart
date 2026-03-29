import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color bg;
  final Color panel;
  final Color panelAlt;
  final Color border;
  final Color accent;
  final Color accentDim;
  final Color text;
  final Color textDim;
  final Color lineNum;
  final Color termGreen;
  final Color termRed;
  final Color termYellow;

  const AppTheme({
    required this.name,
    required this.bg,
    required this.panel,
    required this.panelAlt,
    required this.border,
    required this.accent,
    required this.accentDim,
    required this.text,
    required this.textDim,
    required this.lineNum,
    required this.termGreen,
    required this.termRed,
    required this.termYellow,
  });
}

final List<AppTheme> themes = [
  AppTheme(
    name: 'Dracula',
    bg: const Color(0xFF0D0F14),
    panel: const Color(0xFF131720),
    panelAlt: const Color(0xFF161B26),
    border: const Color(0xFF1E2533),
    accent: const Color(0xFF00E5C8),
    accentDim: const Color(0xFF00B39E),
    text: const Color(0xFFCDD6F4),
    textDim: const Color(0xFF6C7A96),
    lineNum: const Color(0xFF3A4460),
    termGreen: const Color(0xFF00E5C8),
    termRed: const Color(0xFFFF5370),
    termYellow: const Color(0xFFFFCB6B),
  ),
  AppTheme(
    name: 'Night Owl',
    bg: const Color(0xFF011627),
    panel: const Color(0xFF0B2942),
    panelAlt: const Color(0xFF0D2B47),
    border: const Color(0xFF1E3A5F),
    accent: const Color(0xFF7FDBCA),
    accentDim: const Color(0xFF5FB8A8),
    text: const Color(0xFFD6DEEB),
    textDim: const Color(0xFF637777),
    lineNum: const Color(0xFF3B4B5F),
    termGreen: const Color(0xFF7FDBCA),
    termRed: const Color(0xFFFF7B72),
    termYellow: const Color(0xFFECC498),
  ),
  AppTheme(
    name: 'Monokai',
    bg: const Color(0xFF272822),
    panel: const Color(0xFF3E3D32),
    panelAlt: const Color(0xFF464741),
    border: const Color(0xFF49484E),
    accent: const Color(0xFFA6E22E),
    accentDim: const Color(0xFF8BC34A),
    text: const Color(0xFFF8F8F2),
    textDim: const Color(0xFF75715E),
    lineNum: const Color(0xFF5B5955),
    termGreen: const Color(0xFFA6E22E),
    termRed: const Color(0xFFF92672),
    termYellow: const Color(0xFFF4BF4F),
  ),
  AppTheme(
    name: 'Nord',
    bg: const Color(0xFF2E3440),
    panel: const Color(0xFF3B4252),
    panelAlt: const Color(0xFF434C5E),
    border: const Color(0xFF4C566A),
    accent: const Color(0xFF88C0D0),
    accentDim: const Color(0xFF81A1C1),
    text: const Color(0xFFECEFF4),
    textDim: const Color(0xFF4C566A),
    lineNum: const Color(0xFF4C566A),
    termGreen: const Color(0xFFA3BE8C),
    termRed: const Color(0xFFBF616A),
    termYellow: const Color(0xFFECCC8B),
  ),
  AppTheme(
    name: 'Gruvbox',
    bg: const Color(0xFF282828),
    panel: const Color(0xFF3C3836),
    panelAlt: const Color(0xFF504945),
    border: const Color(0xFF665C54),
    accent: const Color(0xFFFB4934),
    accentDim: const Color(0xFFCC241D),
    text: const Color(0xFFEBDBB2),
    textDim: const Color(0xFF928374),
    lineNum: const Color(0xFF665C54),
    termGreen: const Color(0xFFB8BB26),
    termRed: const Color(0xFFFB4934),
    termYellow: const Color(0xFFFABD2F),
  ),
  AppTheme(
    name: 'Light',
    bg: const Color(0xFFFAFAFA),
    panel: const Color(0xFFF5F5F5),
    panelAlt: const Color(0xFFEEEEEE),
    border: const Color(0xFFE0E0E0),
    accent: const Color(0xFF2196F3),
    accentDim: const Color(0xFF1976D2),
    text: const Color(0xFF212121),
    textDim: const Color(0xFF757575),
    lineNum: const Color(0xFFBDBDBD),
    termGreen: const Color(0xFF4CAF50),
    termRed: const Color(0xFFF44336),
    termYellow: const Color(0xFFFF9800),
  ),
];

int currentThemeIndex = 0;

AppTheme get currentTheme => themes[currentThemeIndex];

Color get kBg => currentTheme.bg;
Color get kPanel => currentTheme.panel;
Color get kPanelAlt => currentTheme.panelAlt;
Color get kBorder => currentTheme.border;
Color get kAccent => currentTheme.accent;
Color get kAccentDim => currentTheme.accentDim;
Color get kText => currentTheme.text;
Color get kTextDim => currentTheme.textDim;
Color get kLineNum => currentTheme.lineNum;
Color get kKeyword => currentTheme.accent;
Color get kString => currentTheme.termGreen;
Color get kComment => currentTheme.textDim;
Color get kTermGreen => currentTheme.termGreen;
Color get kTermRed => currentTheme.termRed;
Color get kTermYellow => currentTheme.termYellow;

const double kMinSide = 160;
const double kMinTerm = 80;
const double kDivSize = 4;

ThemeData buildAppTheme() => ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kBg,
  colorScheme: ColorScheme.dark(primary: kAccent, surface: kPanel),
);
