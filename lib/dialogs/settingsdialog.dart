
import 'package:flutter/material.dart';

import '../service/backup_service.dart';
import '../service/data_prefs.dart';
import '../service/restorebackup_service.dart';
import '../service/theme_prefs.dart';
import '../service/themes.dart';
import '../widgets/theme_option_tile.dart';

void showSettingsDialog(BuildContext context, {VoidCallback? onCurrencyChanged}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _SettingsDialogContent(onCurrencyChanged: onCurrencyChanged);
    },
  );
}

class _SettingsDialogContent extends StatefulWidget {
  final VoidCallback? onCurrencyChanged;

  const _SettingsDialogContent({this.onCurrencyChanged});

  @override
  State<_SettingsDialogContent> createState() => _SettingsDialogContentState();
}

class _SettingsDialogContentState extends State<_SettingsDialogContent> {
  String _selectedCurrency = "€";

  final List<String> _currencies = [
    "€",
    "\$",
    "£",
    "₴",
    "¥",
    "₹",
    "Fr",
    "zł",
    "Kč",
    "kr",
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final saved = await DataPrefs.loadKeyString("currency");
    if (saved != null && _currencies.contains(saved)) {
      setState(() {
        _selectedCurrency = saved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: curThemeID,
      builder: (context, value, _) {
        final theme = themesList[value];

        return AlertDialog(
          backgroundColor: theme.background1Color,
          title: Text(
            'Settings',
            style: TextStyle(color: theme.foregroundColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Themes', style: TextStyle(color: theme.foregroundColor)),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: themesList.length,
                    itemBuilder: (context, index) {
                      final itemTheme = themesList[index];

                      return ThemeOptionTile(
                        id: itemTheme.id,
                        title: itemTheme.themeName,
                        accentColor: itemTheme.accentColor,
                        foregroundColor:
                            theme.isDark ? Colors.white : Colors.black,
                        backgroundColor: itemTheme.background1Color,
                        onPressed: () {
                          curThemeID.value = itemTheme.id;
                          ThemePrefs.saveThemeId(curThemeID.value);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Text('Backup', style: TextStyle(color: theme.foregroundColor)),

                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await exportBackup();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Backup exported")),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Backup failed: $e")),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(theme.background1Color),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                          side: BorderSide(
                            color: theme.accentColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      "Backup Data",
                      style: TextStyle(
                        color: theme.accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        final restored = await importBackup();
                        if (restored) {
                          if (widget.onCurrencyChanged != null) {
                            widget.onCurrencyChanged!();
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Restore successful")),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Restore failed: $e")),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(theme.background1Color),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                          side: BorderSide(
                            color: theme.accentColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      "Restore from Backup",
                      style: TextStyle(
                        color: theme.accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text('General', style: TextStyle(color: theme.foregroundColor)),
                const SizedBox(height: 8),

                Container(
                  width: double.maxFinite,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.background1Color,
                    borderRadius: BorderRadius.circular(1.0),
                    border: Border.all(
                      color: theme.accentColor,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCurrency,
                      dropdownColor: theme.background1Color,
                      icon: Icon(Icons.arrow_drop_down,
                          color: theme.accentColor),
                      isExpanded: true,
                      style: TextStyle(
                        color: theme.accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      items: _currencies.map((String curr) {
                        return DropdownMenuItem<String>(
                          value: curr,
                          child: Text(
                            curr,
                            style: TextStyle(
                              color: theme.accentColor,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        if (newValue != null) {
                          setState(() {
                            _selectedCurrency = newValue;
                          });
                          await DataPrefs.saveKeyString(newValue, "currency");
                          if (widget.onCurrencyChanged != null) {
                            widget.onCurrencyChanged!();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: theme.accentColor),
              ),
            ),
          ],
        );
      },
    );
  }
}