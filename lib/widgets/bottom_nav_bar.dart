import 'package:flutter/material.dart';
import 'package:holo_budgeter/service/themes.dart';

class ScreenBottomNavBar extends StatelessWidget {
  final int activeIndex; // 0: Overview, 1: History, 2: Insights
  final VoidCallback onOverviewPressed;
  final VoidCallback onHistoryPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onInsightsPressed;
  final VoidCallback onSettingsPressed;

  const ScreenBottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onOverviewPressed,
    required this.onHistoryPressed,
    required this.onAddPressed,
    required this.onInsightsPressed,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: curThemeID,
      builder: (context, value, _) {
        final theme = themesList[value];

        Widget buildNavButton({
          required int index,
          required VoidCallback onPressed,
          required Widget child,
          bool isExpanded = false,
        }) {
          final isSelected = activeIndex == index;
          final buttonStyle = ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(theme.background1Color),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0),
                side: BorderSide(
                  color: theme.accentColor,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
            ),
          );

          final button = SizedBox(
            width: isExpanded ? null : 53,
            height: 40,
            child: TextButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: child,
            ),
          );

          return isExpanded ? Expanded(child: button) : button;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              buildNavButton(
                index: 0,
                onPressed: onOverviewPressed,
                child: Icon(
                  Icons.dashboard_outlined,
                  color: theme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              buildNavButton(
                index: 1,
                onPressed: onHistoryPressed,
                child: Icon(
                  Icons.history,
                  color: theme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              buildNavButton(
                index: -1,
                onPressed: onAddPressed,
                isExpanded: true,
                child: Text(
                  "+",
                  style: TextStyle(
                    color: theme.accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              buildNavButton(
                index: 2,
                onPressed: onInsightsPressed,
                child: Icon(
                  Icons.insights_outlined,
                  color: theme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              buildNavButton(
                index: -1,
                onPressed: onSettingsPressed,
                child: Icon(
                  Icons.settings,
                  color: theme.accentColor,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
