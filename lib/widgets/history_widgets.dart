import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/transaction.dart';
import '../service/themes.dart';
import 'day_spendings.dart';

class HistoryHeader extends StatelessWidget {
  final String dateString;

  const HistoryHeader({super.key, required this.dateString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children: [
          Text(
            "History",
            style: TextStyle(
              color: foregroundColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Expanded(
            child: SizedBox(width: 60),
          ),
          Text(
            dateString,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class HistorySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSearchPressed;
  final OutlineInputBorder borderStyle;
  final OutlineInputBorder focusedBorderStyle;
  final bool isDark;

  const HistorySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSearchPressed,
    required this.borderStyle,
    required this.focusedBorderStyle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: "Search by name, category, or date...",
          labelStyle: TextStyle(
            color: foregroundColor.withValues(alpha: 0.8),
            fontSize: 13,
          ),
          enabledBorder: borderStyle,
          focusedBorder: focusedBorderStyle,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: onSearchPressed,
          ),
        ),
        style: TextStyle(color: foregroundColor, fontSize: 15),
      ),
    );
  }
}

class HistoryFilterButtons extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String> onFilterSelected;
  final AppTheme theme;

  const HistoryFilterButtons({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
    required this.theme,
  });

  Widget _buildFilterButton(String label) {
    final isSelected = currentFilter == label;
    final activeColor = theme.isDark ? Colors.white : Colors.black;
    final buttonColor = isSelected ? activeColor : theme.accentColor;

    return SizedBox(
      height: 38,
      child: TextButton(
        onPressed: () {
          if (currentFilter != label) {
            onFilterSelected(label);
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(theme.background1Color),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1.0),
              side: BorderSide(
                color: buttonColor,
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: buttonColor,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(child: _buildFilterButton("Expenses")),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterButton("All")),
          const SizedBox(width: 8),
          Expanded(child: _buildFilterButton("Income")),
        ],
      ),
    );
  }
}

class HistoryTransactionsList extends StatelessWidget {
  final Map<DateTime, List<Transaction>> groupedTransactions;
  final String typeFilter;
  final String currencyType;
  final AppTheme theme;
  final void Function(Transaction) onTransactionLongPress;

  const HistoryTransactionsList({
    super.key,
    required this.groupedTransactions,
    required this.typeFilter,
    required this.currencyType,
    required this.theme,
    required this.onTransactionLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = theme.isDark
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.15);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 180),
                decoration: BoxDecoration(
                  color: theme.backgroundNoteColor,
                  border: Border.all(color: borderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(1.0),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            if (groupedTransactions.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Text(
                                  "No transactions found",
                                  style: TextStyle(
                                    color: foregroundColor.withValues(alpha: 0.6),
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              for (final entry in groupedTransactions.entries) ...[
                                Row(
                                  children: [
                                    Text(
                                      DateFormat("MMM d").format(entry.key),
                                      style: TextStyle(
                                        color: foregroundColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      "Total${typeFilter == "All" ? "" : (typeFilter == "Expenses" ? " Expenses" : " Income")}: ${calculateTotalOfDay(entry.value).toStringAsFixed(2)}$currencyType",
                                      style: TextStyle(
                                        color: titleTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                for (final tx in entry.value)
                                  DaySpendings(
                                    transaction: tx,
                                    showCategory: true,
                                    currencyType: currencyType,
                                    onLongPress: () => onTransactionLongPress(tx),
                                  ),
                                const SizedBox(height: 12),
                              ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Transaction> filterHistoryTransactions(
    List<Transaction> txList, String searchQuery, String typeFilter) {
  final query = searchQuery.trim().toLowerCase();

  return txList.where((tx) {
    if (typeFilter == "Income" && !tx.isIncome) {
      return false;
    }
    if (typeFilter == "Expenses" && tx.isIncome) {
      return false;
    }

    if (query.isNotEmpty) {
      final nameMatch = tx.name.toLowerCase().contains(query);
      final categoryMatch = tx.category.toLowerCase().contains(query);

      final dt = DateTime.fromMillisecondsSinceEpoch(
        tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp,
      );
      final date1 = DateFormat("MMM d").format(dt).toLowerCase();
      final date2 = DateFormat("MMMM d").format(dt).toLowerCase();
      final date3 = DateFormat("dd.MM.yy").format(dt).toLowerCase();
      final date4 = DateFormat("yyyy-MM-dd").format(dt).toLowerCase();

      final dateMatch = date1.contains(query) ||
          date2.contains(query) ||
          date3.contains(query) ||
          date4.contains(query);

      if (!nameMatch && !categoryMatch && !dateMatch) {
        return false;
      }
    }

    return true;
  }).toList();
}

Map<DateTime, List<Transaction>> groupHistoryTransactionsByDate(
    List<Transaction> transactions) {
  final Map<DateTime, List<Transaction>> grouped = {};

  for (final tx in transactions) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp,
    );
    final dateKey = DateTime(dt.year, dt.month, dt.day);

    grouped.putIfAbsent(dateKey, () => []).add(tx);
  }

  final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

  final Map<DateTime, List<Transaction>> sortedGrouped = {};
  for (final key in sortedKeys) {
    sortedGrouped[key] = grouped[key]!;
  }

  return sortedGrouped;
}

double calculateTotalOfDay(List<Transaction> transactions) {
  double totalAmount = 0.0;

  for (final tx in transactions) {
    if (tx.isIncome) {
      totalAmount += tx.amount;
    } else {
      totalAmount -= tx.amount;
    }
  }

  return totalAmount;
}
