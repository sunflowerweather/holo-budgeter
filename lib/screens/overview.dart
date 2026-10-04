import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holo_budgeter/dialogs/settingsdialog.dart';
import 'package:holo_budgeter/service/data_prefs.dart';
import 'package:holo_budgeter/service/themes.dart';
import 'package:holo_budgeter/widgets/bottom_nav_bar.dart';
import 'package:holo_budgeter/widgets/overview_widgets.dart';

import 'package:intl/intl.dart';

import '../classes/transaction.dart';
import '../dialogs/new_entry_dialog.dart';
import 'history.dart';
import 'insights.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key, required this.title});

  final String title;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

DateTime now = DateTime.now();
String dateString = DateFormat("dd.MM.yyyy").format(DateTime.now());

class _OverviewPageState extends State<OverviewPage> {
  double availableMoney = 0.0;
  double monthIncome = 0.0;
  double monthExpenses = 0.0;
  String currencyType = "€";

  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    loadMoney();
  }

  Future<void> loadMoney() async {
    final jsonString = await DataPrefs.loadKeyString("transactions");

    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        transactions = decoded
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    currencyType = await DataPrefs.loadKeyString("currency") ?? "€";

    _recalculateMoney();
  }

  void _recalculateMoney() {
    double available = 0.0;
    double income = 0.0;
    double expenses = 0.0;

    bool isThisMonth(int timestamp) {
      final ms = timestamp > 999999999999 ? timestamp : timestamp * 1000;
      final date = DateTime.fromMillisecondsSinceEpoch(ms);
      final now = DateTime.now();
      return date.year == now.year && date.month == now.month;
    }

    for (Transaction t in transactions) {
      if (t.isIncome) {
        available += t.amount;
        if (isThisMonth(t.timestamp)) {
          income += t.amount;
        }
      } else {
        available -= t.amount;
        if (isThisMonth(t.timestamp)) {
          expenses += t.amount;
        }
      }
    }

    setState(() {
      availableMoney = available;
      monthIncome = income;
      monthExpenses = expenses;
    });
  }

  Future<void> _addTransaction(Transaction tx) async {
    setState(() {
      transactions.add(tx);
    });

    final jsonList = transactions.map((t) => t.toJson()).toList();
    await DataPrefs.saveKeyString(jsonEncode(jsonList), "transactions");

    _recalculateMoney();
  }

  void showSettings() {
    showSettingsDialog(
      context,
      onCurrencyChanged: () {
        setState(() {
          loadMoney();
        });
      },
    );
  }

  void showNewEntryDialog() {
    openEntryDialog(
      context,
      onSave: (transaction) {
        _addTransaction(transaction);
      },
    );
  }

  void moveToHistoryScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const HistoryPage(
            title: 'History Page',
          );
        },
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void moveToInsightsScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const InsightsPage(
            title: 'Insights Page',
          );
        },
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: curThemeID,
      builder: (context, value, _) {
        final theme = themesList[value];

        final backgroundGradient = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.background2Color,
              theme.background1Color,
            ],
          ),
        );

        final groupedTransactions =
            groupOverviewTransactionsByDate(transactions);
        final topCategories = getTopExpenseCategories(transactions);
        final borderColor = theme.isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.15);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: backgroundGradient,
            child: SafeArea(
              child: Column(
                children: [
                  OverviewHeader(dateString: dateString),
                  AvailableBalanceCard(
                    availableMoney: availableMoney,
                    currencyType: currencyType,
                  ),
                  const SizedBox(height: 10),
                  ThisMonthCard(
                    monthIncome: monthIncome,
                    monthExpenses: monthExpenses,
                    currencyType: currencyType,
                    borderColor: borderColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Divider(
                      color: accentColor,
                      thickness: 2,
                      height: 1,
                    ),
                  ),
                  RecentHistoryCard(
                    groupedTransactions: groupedTransactions,
                    currencyType: currencyType,
                    borderColor: borderColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Divider(
                      color: accentColor,
                      thickness: 2,
                      height: 1,
                    ),
                  ),
                  TopCategoriesCard(
                    topCategories: topCategories,
                    currencyType: currencyType,
                    borderColor: borderColor,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ScreenBottomNavBar(
                    activeIndex: 0,
                    onOverviewPressed: () {},
                    onHistoryPressed: moveToHistoryScreen,
                    onAddPressed: showNewEntryDialog,
                    onInsightsPressed: moveToInsightsScreen,
                    onSettingsPressed: showSettings,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
