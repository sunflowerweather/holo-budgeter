import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/transaction.dart';
import '../service/themes.dart';
import 'day_spendings.dart';

class OverviewHeader extends StatelessWidget {
  final String dateString;

  const OverviewHeader({super.key, required this.dateString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children: [
          Text(
            "Overview",
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

class AvailableBalanceCard extends StatelessWidget {
  final double availableMoney;
  final String currencyType;

  const AvailableBalanceCard({
    super.key,
    required this.availableMoney,
    required this.currencyType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "AVAILABLE:",
          style: TextStyle(
            color: foregroundColor,
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          availableMoney < 0
              ? '-$currencyType${availableMoney.abs().toStringAsFixed(2)}'
              : '$currencyType${availableMoney.toStringAsFixed(2)}',
          style: TextStyle(
            color: foregroundColor,
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ThisMonthCard extends StatelessWidget {
  final double monthIncome;
  final double monthExpenses;
  final String currencyType;
  final Color borderColor;

  const ThisMonthCard({
    super.key,
    required this.monthIncome,
    required this.monthExpenses,
    required this.currencyType,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: backgroundNoteColor,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(1.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "THIS MONTH",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 12.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "$currencyType${monthIncome.abs().toStringAsFixed(2)}",
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expenses",
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "$currencyType${monthExpenses.abs().toStringAsFixed(2)}",
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentHistoryCard extends StatelessWidget {
  final Map<DateTime, List<Transaction>> groupedTransactions;
  final String currencyType;
  final Color borderColor;

  const RecentHistoryCard({
    super.key,
    required this.groupedTransactions,
    required this.currencyType,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 180),
                decoration: BoxDecoration(
                  color: backgroundNoteColor,
                  border: Border.all(color: borderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(1.0),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RECENT HISTORY",
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            for (final entry in groupedTransactions.entries) ...[
                              Text(
                                DateFormat("MMM d").format(entry.key),
                                style: TextStyle(
                                  color: foregroundColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 4),
                              for (final tx in entry.value)
                                DaySpendings(
                                  transaction: tx,
                                  currencyType: currencyType,
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

class TopCategoriesCard extends StatelessWidget {
  final List<MapEntry<String, double>> topCategories;
  final String currencyType;
  final Color borderColor;

  const TopCategoriesCard({
    super.key,
    required this.topCategories,
    required this.currencyType,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: backgroundNoteColor,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(1.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOP CATEGORIES",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (topCategories.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "No expenses recorded",
                        style: TextStyle(
                          color: foregroundColor.withValues(alpha: 0.6),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: topCategories.length,
                      itemBuilder: (context, index) {
                        final entry = topCategories[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 6.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    color: foregroundColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${entry.value.toStringAsFixed(2)}$currencyType",
                                style: TextStyle(
                                  color: foregroundColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.end,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<MapEntry<String, double>> getTopExpenseCategories(
  List<Transaction> transactions,
) {
  final categoryTotals = <String, double>{};

  for (final transaction in transactions) {
    if (transaction.isIncome) {
      continue;
    }

    categoryTotals.update(
      transaction.category,
      (currentTotal) => currentTotal + transaction.amount,
      ifAbsent: () => transaction.amount,
    );
  }

  final sortedCategories = categoryTotals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sortedCategories.take(4).toList();
}

Map<DateTime, List<Transaction>> groupOverviewTransactionsByDate(
    List<Transaction> transactions) {
  final Map<DateTime, List<Transaction>> grouped = {};
  final now = DateTime.now();

  for (final tx in transactions) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp,
    );
    final dateKey = DateTime(dt.year, dt.month, dt.day);
    if (dt.month >= now.month) {
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }
  }

  final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

  final Map<DateTime, List<Transaction>> sortedGrouped = {};
  for (final key in sortedKeys) {
    sortedGrouped[key] = grouped[key]!;
  }

  return sortedGrouped;
}
