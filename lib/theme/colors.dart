import 'package:flutter/material.dart';
import 'themes/dracula.dart';
import 'themes/night_owl.dart';
import 'themes/monokai.dart';
import 'themes/nord.dart';
import 'themes/gruvbox.dart';
import 'themes/light.dart';

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
    name: DraculaTheme.name,
    bg: DraculaTheme.bg,
    panel: DraculaTheme.panel,
    panelAlt: DraculaTheme.panelAlt,
    border: DraculaTheme.border,
    accent: DraculaTheme.accent,
    accentDim: DraculaTheme.accentDim,
    text: DraculaTheme.text,
    textDim: DraculaTheme.textDim,
    lineNum: DraculaTheme.lineNum,
    termGreen: DraculaTheme.termGreen,
    termRed: DraculaTheme.termRed,
    termYellow: DraculaTheme.termYellow,
  ),
  AppTheme(
    name: NightOwlTheme.name,
    bg: NightOwlTheme.bg,
    panel: NightOwlTheme.panel,
    panelAlt: NightOwlTheme.panelAlt,
    border: NightOwlTheme.border,
    accent: NightOwlTheme.accent,
    accentDim: NightOwlTheme.accentDim,
    text: NightOwlTheme.text,
    textDim: NightOwlTheme.textDim,
    lineNum: NightOwlTheme.lineNum,
    termGreen: NightOwlTheme.termGreen,
    termRed: NightOwlTheme.termRed,
    termYellow: NightOwlTheme.termYellow,
  ),
  AppTheme(
    name: MonokaiTheme.name,
    bg: MonokaiTheme.bg,
    panel: MonokaiTheme.panel,
    panelAlt: MonokaiTheme.panelAlt,
    border: MonokaiTheme.border,
    accent: MonokaiTheme.accent,
    accentDim: MonokaiTheme.accentDim,
    text: MonokaiTheme.text,
    textDim: MonokaiTheme.textDim,
    lineNum: MonokaiTheme.lineNum,
    termGreen: MonokaiTheme.termGreen,
    termRed: MonokaiTheme.termRed,
    termYellow: MonokaiTheme.termYellow,
  ),
  AppTheme(
    name: NordTheme.name,
    bg: NordTheme.bg,
    panel: NordTheme.panel,
    panelAlt: NordTheme.panelAlt,
    border: NordTheme.border,
    accent: NordTheme.accent,
    accentDim: NordTheme.accentDim,
    text: NordTheme.text,
    textDim: NordTheme.textDim,
    lineNum: NordTheme.lineNum,
    termGreen: NordTheme.termGreen,
    termRed: NordTheme.termRed,
    termYellow: NordTheme.termYellow,
  ),
  AppTheme(
    name: GruvboxTheme.name,
    bg: GruvboxTheme.bg,
    panel: GruvboxTheme.panel,
    panelAlt: GruvboxTheme.panelAlt,
    border: GruvboxTheme.border,
    accent: GruvboxTheme.accent,
    accentDim: GruvboxTheme.accentDim,
    text: GruvboxTheme.text,
    textDim: GruvboxTheme.textDim,
    lineNum: GruvboxTheme.lineNum,
    termGreen: GruvboxTheme.termGreen,
    termRed: GruvboxTheme.termRed,
    termYellow: GruvboxTheme.termYellow,
  ),
  AppTheme(
    name: LightTheme.name,
    bg: LightTheme.bg,
    panel: LightTheme.panel,
    panelAlt: LightTheme.panelAlt,
    border: LightTheme.border,
    accent: LightTheme.accent,
    accentDim: LightTheme.accentDim,
    text: LightTheme.text,
    textDim: LightTheme.textDim,
    lineNum: LightTheme.lineNum,
    termGreen: LightTheme.termGreen,
    termRed: LightTheme.termRed,
    termYellow: LightTheme.termYellow,
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
