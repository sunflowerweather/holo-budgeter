import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holo_budgeter/dialogs/settingsdialog.dart';
import 'package:holo_budgeter/screens/overview.dart';
import 'package:holo_budgeter/service/data_prefs.dart';
import 'package:holo_budgeter/service/themes.dart';
import 'package:holo_budgeter/widgets/bottom_nav_bar.dart';
import 'package:holo_budgeter/widgets/history_widgets.dart';

import 'package:intl/intl.dart';

import '../classes/transaction.dart';
import '../dialogs/deletedialog.dart';
import '../dialogs/new_entry_dialog.dart';
import 'insights.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

DateTime now = DateTime.now();
String dateString = DateFormat("dd.MM.yyyy").format(DateTime.now());

class _HistoryPageState extends State<HistoryPage> {
  String currencyType = "€";

  List<Transaction> transactions = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _typeFilter = "All"; // "Expenses", "All", "Income"

  @override
  void initState() {
    super.initState();
    loadMoney();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    setState(() {});
  }

  Future<void> _addTransaction(Transaction tx) async {
    setState(() {
      transactions.add(tx);
    });

    final jsonList = transactions.map((t) => t.toJson()).toList();
    await DataPrefs.saveKeyString(jsonEncode(jsonList), "transactions");
  }

  Future<void> _removeTransaction(Transaction transaction) async {
    setState(() {
      transactions.remove(transaction);
    });

    final jsonList = transactions.map((t) => t.toJson()).toList();
    await DataPrefs.saveKeyString(jsonEncode(jsonList), "transactions");
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

  void removeTransactionDialog(Transaction transaction) {
    showDeleteConfirmation(context, () {
      _removeTransaction(transaction);
    });
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

        final filteredTransactions =
            filterHistoryTransactions(transactions, _searchQuery, _typeFilter);
        final groupedTransactions =
            groupHistoryTransactionsByDate(filteredTransactions);

        final borderStyle = OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.accentColor,
            width: 1.5,
          ),
        );

        final focusedBorderStyle = const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        );

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: backgroundGradient,
            child: SafeArea(
              child: Column(
                children: [
                  HistoryHeader(dateString: dateString),
                  const SizedBox(height: 10),
                  HistorySearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSearchPressed: () {
                      setState(() {
                        _searchQuery = _searchController.text;
                      });
                    },
                    borderStyle: borderStyle,
                    focusedBorderStyle: focusedBorderStyle,
                    isDark: theme.isDark,
                  ),
                  const SizedBox(height: 10),
                  HistoryFilterButtons(
                    currentFilter: _typeFilter,
                    onFilterSelected: (label) {
                      setState(() {
                        _typeFilter = label;
                      });
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 10),
                  HistoryTransactionsList(
                    groupedTransactions: groupedTransactions,
                    typeFilter: _typeFilter,
                    currencyType: currencyType,
                    theme: theme,
                    onTransactionLongPress: removeTransactionDialog,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ScreenBottomNavBar(
                    activeIndex: 1,
                    onOverviewPressed: moveToOverviewScreen,
                    onHistoryPressed: () {},
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
