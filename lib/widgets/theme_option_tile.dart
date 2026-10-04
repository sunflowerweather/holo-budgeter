import 'package:flutter/material.dart';

import '../service/themes.dart';

class ThemeOptionTile extends StatelessWidget {
  final Color accentColor;
  final Color foregroundColor;
  final Color backgroundColor;
  final String title;
  final int id;
  final VoidCallback? onPressed;

  const ThemeOptionTile({
    super.key,
    required this.accentColor,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.title,
    required this.id,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                border: Border.all(
                  color: accentColor,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(right: 5),
          ),

          Text(
            title,
            style: TextStyle(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}