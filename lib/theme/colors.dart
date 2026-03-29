import 'package:flutter/material.dart';

// ─── App Colours ───────────────────────────────────────────────────────────────

const kBg        = Color(0xFF0D0F14);
const kPanel     = Color(0xFF131720);
const kPanelAlt  = Color(0xFF161B26);
const kBorder    = Color(0xFF1E2533);
const kAccent    = Color(0xFF00E5C8);
const kAccentDim = Color(0xFF00B39E);
const kText      = Color(0xFFCDD6F4);
const kTextDim   = Color(0xFF6C7A96);
const kLineNum   = Color(0xFF3A4460);
const kKeyword   = Color(0xFF89B4FA);
const kString    = Color(0xFFA6E3A1);
const kComment   = Color(0xFF45475A);
const kTermGreen = Color(0xFF00E5C8);
const kTermRed   = Color(0xFFFF5370);
const kTermYellow= Color(0xFFFFCB6B);

// ─── Layout Constants ──────────────────────────────────────────────────────────

const double kMinSide = 160;
const double kMinTerm = 80;
const double kDivSize = 4;

// ─── App Theme ─────────────────────────────────────────────────────────────────

ThemeData buildAppTheme() => ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kBg,
  colorScheme: const ColorScheme.dark(
    primary: kAccent,
    surface: kPanel,
  ),
);
