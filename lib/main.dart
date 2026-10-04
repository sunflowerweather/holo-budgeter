

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:holo_budgeter/service/theme_prefs.dart';
import 'package:holo_budgeter/service/themes.dart';




import 'screens/overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedId = await ThemePrefs.loadThemeId();

  if (savedId != null && savedId < themesList.length) {
    curThemeID.value = savedId;
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );


  runApp(const ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holo Budgeter',
      theme: ThemeData(
        colorScheme: currentTheme.isDark ? ColorScheme.dark(
          surface: currentTheme.background1Color,
          primary: currentTheme.accentColor,
        ) :ColorScheme.light(
          surface: currentTheme.background1Color,
          primary: currentTheme.accentColor,
        ),
        useMaterial3: false,
      ),
      home: const OverviewPage(title: 'Holo Budgeter'),
    );
  }
}

