import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holo_budgeter/dialogs/settingsdialog.dart';
import 'package:holo_budgeter/screens/overview.dart';
import 'package:holo_budgeter/service/data_prefs.dart';
import 'package:holo_budgeter/service/themes.dart';
import 'package:holo_budgeter/widgets/bottom_nav_bar.dart';
import 'package:holo_budgeter/widgets/insights_widgets.dart';

import 'package:intl/intl.dart';

import '../classes/transaction.dart';
import '../dialogs/new_entry_dialog.dart';
import 'history.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key, required this.title});

  final String title;

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

DateTime now = DateTime.now();
String dateString = DateFormat("dd.MM.yyyy").format(DateTime.now());

class _InsightsPageState extends State<InsightsPage> {
  double availableMoney = 0.0;
  double monthIncome = 0.0;
  double monthExpenses = 0.0;
  String currencyType = "€";
  double totalExpenses = 0.0;

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
    double totExpenses = 0.0;

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
        totExpenses += t.amount;
      }
    }

    setState(() {
      availableMoney = available;
      monthIncome = income;
      monthExpenses = expenses;
      totalExpenses = totExpenses;
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

  void moveToOverviewScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const OverviewPage(
            title: 'Overview Page',
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

        final topCategories = getExpenseCategories(transactions);
        final monthlyData = getMonthlyIncomeAndExpenses(transactions);
        final monthlyDataFull = getMonthlyIncomeAndExpensesFULL(transactions);
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
                  InsightsHeader(dateString: dateString),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SpendingByCategoryCard(
                            topCategories: topCategories,
                            totalExpenses: totalExpenses,
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
                          MonthlyIncomeExpensesListCard(
                            monthlyDataFull: monthlyDataFull,
                            currencyType: currencyType,
                            borderColor: borderColor,
                            now: now,
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
                          IncomeVsExpensesChartCard(
                            monthlyData: monthlyData,
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
                          BalanceStockChartCard(
                            transactions: transactions,
                            currencyType: currencyType,
                            borderColor: borderColor,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ScreenBottomNavBar(
                    activeIndex: 2,
                    onOverviewPressed: moveToOverviewScreen,
                    onHistoryPressed: moveToHistoryScreen,
                    onAddPressed: showNewEntryDialog,
                    onInsightsPressed: () {},
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
