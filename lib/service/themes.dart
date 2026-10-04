import 'package:flutter/material.dart';

class AppTheme {
  Color accentColor;
  Color background1Color;
  Color background2Color;
  Color foregroundColor;
  Color titleTextColor;
  Color backgroundNoteColor;
  Color progressBarBGColor;
  String themeName;
  int id;
  bool isDark;

  AppTheme({
    required this.accentColor,
    required this.background1Color,
    required this.background2Color,
    required this.foregroundColor,
    required this.titleTextColor,
    required this.backgroundNoteColor,
    required this.progressBarBGColor,
    required this.themeName,
    required this.id,
    required this.isDark,
  });
}

//Dark Themes

AppTheme themeHoloDefault = AppTheme(
    accentColor: const Color(0xFFB033E5),
    background1Color: const Color(0xFF272C32),
    background2Color: const Color(0xFF000000),
    foregroundColor: const Color(0xFFFFFFFF),
    titleTextColor: const Color(0xFFADADAD),
    backgroundNoteColor: const Color(0xFF1A1F24),
    progressBarBGColor: const Color(0xFF424242),
    themeName: "Holo Budgeter (Default)",
    id: 0,
    isDark: true);

AppTheme themeForest = AppTheme(
    accentColor: const Color(0xFF4CAF50),
    background1Color: const Color(0xFF1E2A24),
    background2Color: const Color(0xFF0B120E),
    foregroundColor: const Color(0xFFE8F5E9),
    titleTextColor: const Color(0xFFB0C4B1),
    backgroundNoteColor: const Color(0xFF1C2721),
    progressBarBGColor: const Color(0xFF33483E),
    themeName: "Forest",
    id: 1,
    isDark: true);

AppTheme themeGraphite = AppTheme(
    accentColor: const Color(0xFF90A4AE),
    background1Color: const Color(0xFF202225),
    background2Color: const Color(0xFF0E0F10),
    foregroundColor: const Color(0xFFECEFF1),
    titleTextColor: const Color(0xFFB0BEC5),
    backgroundNoteColor: const Color(0xFF1B1E21),
    progressBarBGColor: const Color(0xFF3A3E45),
    themeName: "Graphite",
    id: 2,
    isDark: true);

AppTheme themeEmber = AppTheme(
    accentColor: const Color(0xFFFF7043),
    background1Color: const Color(0xFF261A18),
    background2Color: const Color(0xFF0F0A09),
    foregroundColor: const Color(0xFFFFF3E0),
    titleTextColor: const Color(0xFFD7B8AA),
    backgroundNoteColor: const Color(0xFF211714),
    progressBarBGColor: const Color(0xFF442D2A),
    themeName: "Ember",
    id: 3,
    isDark: true);

AppTheme themeCrimsonNight = AppTheme(
    accentColor: const Color(0xFFE53935),
    background1Color: const Color(0xFF2B1717),
    background2Color: const Color(0xFF120909),
    foregroundColor: const Color(0xFFFFEBEE),
    titleTextColor: const Color(0xFFD7A8A8),
    backgroundNoteColor: const Color(0xFF231414),
    progressBarBGColor: const Color(0xFF482626),
    themeName: "Crimson Night",
    id: 4,
    isDark: true);

AppTheme themeTerminal = AppTheme(
    accentColor: const Color(0xFF00E676),
    background1Color: const Color(0xFF141A14),
    background2Color: const Color(0xFF050705),
    foregroundColor: const Color(0xFFE8F5E9),
    titleTextColor: const Color(0xFF9FB79F),
    backgroundNoteColor: const Color(0xFF151915),
    progressBarBGColor: const Color(0xFF283628),
    themeName: "Terminal",
    id: 5,
    isDark: true);

AppTheme themeGoldenHour = AppTheme(
    accentColor: const Color(0xFFFFC107),
    background1Color: const Color(0xFF2B2416),
    background2Color: const Color(0xFF120E06),
    foregroundColor: const Color(0xFFFFF8E1),
    titleTextColor: const Color(0xFFD3BE8A),
    backgroundNoteColor: const Color(0xFF221C10),
    progressBarBGColor: const Color(0xFF4A3E26),
    themeName: "Golden Hour",
    id: 6,
    isDark: true);

AppTheme themeAurora = AppTheme(
    accentColor: const Color(0xFF26C6DA),
    background1Color: const Color(0xFF17272A),
    background2Color: const Color(0xFF071012),
    foregroundColor: const Color(0xFFE0F7FA),
    titleTextColor: const Color(0xFFA8C3C7),
    backgroundNoteColor: const Color(0xFF132024),
    progressBarBGColor: const Color(0xFF284348),
    themeName: "Aurora",
    id: 7,
    isDark: true);

AppTheme themeMilitary = AppTheme(
    accentColor: const Color(0xFF8BC34A),
    background1Color: const Color(0xFF22281B),
    background2Color: const Color(0xFF0C0F09),
    foregroundColor: const Color(0xFFF1F8E9),
    titleTextColor: const Color(0xFFB6C2A3),
    backgroundNoteColor: const Color(0xFF1C2217),
    progressBarBGColor: const Color(0xFF38432C),
    themeName: "Military",
    id: 8,
    isDark: true);

//Light Themes

AppTheme themeMint = AppTheme(
    accentColor: const Color(0xFF43A047),
    background1Color: const Color(0xFFF3FBF6),
    background2Color: const Color(0xFFE3EFE7),
    foregroundColor: const Color(0xFF263238),
    titleTextColor: const Color(0xFF546E7A),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFC8E6C9),
    themeName: "Mint",
    id: 9,
    isDark: false);

AppTheme themeSandyBeach = AppTheme(
    accentColor: const Color(0xFFFFB300),
    background1Color: const Color(0xFFFFF8E1),
    background2Color: const Color(0xFFFFECB3),
    foregroundColor: const Color(0xFF3E2723),
    titleTextColor: const Color(0xFF6D4C41),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFFFE0B2),
    themeName: "Sandy Beach",
    id: 10,
    isDark: false);

AppTheme themeSky = AppTheme(
    accentColor: const Color(0xFF0288D1),
    background1Color: const Color(0xFFEAF6FF),
    background2Color: const Color(0xFFD6ECFF),
    foregroundColor: const Color(0xFF263238),
    titleTextColor: const Color(0xFF455A64),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFB3E5FC),
    themeName: "Sky",
    id: 11,
    isDark: false);

AppTheme themeLavender = AppTheme(
    accentColor: const Color(0xFF7E57C2),
    background1Color: const Color(0xFFF7F4FD),
    background2Color: const Color(0xFFE9E4F5),
    foregroundColor: const Color(0xFF2E2A36),
    titleTextColor: const Color(0xFF5E5470),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFD1C4E9),
    themeName: "Lavender",
    id: 12,
    isDark: false);

AppTheme themePaper = AppTheme(
    accentColor: const Color(0xFF546E7A),
    background1Color: const Color(0xFFF7F7F5),
    background2Color: const Color(0xFFECECE8),
    foregroundColor: const Color(0xFF263238),
    titleTextColor: const Color(0xFF607D8B),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFCFD8DC),
    themeName: "Paper",
    id: 13,
    isDark: false);

AppTheme themeCherryBlossom = AppTheme(
    accentColor: const Color(0xFFEC407A),
    background1Color: const Color(0xFFFFF1F5),
    background2Color: const Color(0xFFFDE0E7),
    foregroundColor: const Color(0xFF3E2723),
    titleTextColor: const Color(0xFF8D6E63),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFF8BBD0),
    themeName: "Cherry Blossom",
    id: 14,
    isDark: false);

AppTheme themePeach = AppTheme(
    accentColor: const Color(0xFFFF8A65),
    background1Color: const Color(0xFFFFF3EE),
    background2Color: const Color(0xFFFFE0D6),
    foregroundColor: const Color(0xFF4E342E),
    titleTextColor: const Color(0xFF795548),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFFFCCBC),
    themeName: "Peach",
    id: 15,
    isDark: false);

AppTheme themeSeafoam = AppTheme(
    accentColor: const Color(0xFF26A69A),
    background1Color: const Color(0xFFF1FCFA),
    background2Color: const Color(0xFFD8F3EE),
    foregroundColor: const Color(0xFF263238),
    titleTextColor: const Color(0xFF546E7A),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFB2DFDB),
    themeName: "Seafoam",
    id: 16,
    isDark: false);

AppTheme themeRetroMint = AppTheme(
    accentColor: const Color(0xFF26C6DA),
    background1Color: const Color(0xFFF2FFFD),
    background2Color: const Color(0xFFDDF7F4),
    foregroundColor: const Color(0xFF263238),
    titleTextColor: const Color(0xFF546E7A),
    backgroundNoteColor: const Color(0xFFFFFFFF),
    progressBarBGColor: const Color(0xFFB2EBF2),
    themeName: "Retro Mint",
    id: 17,
    isDark: false);

final List<AppTheme> themesList = [
  //Dark Themes
  themeHoloDefault,
  themeForest,
  themeGraphite,
  themeEmber,
  themeCrimsonNight,
  themeTerminal,
  themeGoldenHour,
  themeAurora,
  themeMilitary,
  //Light Themes
  themeMint,
  themeSandyBeach,
  themeSky,
  themeLavender,
  themePaper,
  themeCherryBlossom,
  themePeach,
  themeSeafoam,
  themeRetroMint
];

ValueNotifier<int> curThemeID = ValueNotifier<int>(0);

AppTheme get currentTheme => themesList[curThemeID.value];

Color get accentColor => currentTheme.accentColor;
Color get background1Color => currentTheme.background1Color;
Color get background2Color => currentTheme.background2Color;
Color get foregroundColor => currentTheme.foregroundColor;
Color get titleTextColor => currentTheme.titleTextColor;
Color get backgroundNoteColor => currentTheme.backgroundNoteColor;
Color get progressBarBGColor => currentTheme.progressBarBGColor;
