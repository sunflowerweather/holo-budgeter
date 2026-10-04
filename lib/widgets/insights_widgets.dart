import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/transaction.dart';
import '../service/themes.dart';

class MonthlyData {
  final String label;
  final double income;
  final double expenses;

  MonthlyData({
    required this.label,
    required this.income,
    required this.expenses,
  });
}

class BalancePoint {
  final DateTime dateTime;
  final double balance;

  BalancePoint({
    required this.dateTime,
    required this.balance,
  });
}

class StockChartPainter extends CustomPainter {
  final List<BalancePoint> points;
  final DateTime startDate;
  final DateTime endDate;
  final double minY;
  final double maxY;

  StockChartPainter({
    required this.points,
    required this.startDate,
    required this.endDate,
    required this.minY,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final totalMs =
        (endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch)
            .toDouble();
    if (totalMs <= 0) return;

    final yRange = (maxY - minY) <= 0 ? 1.0 : (maxY - minY);

    Offset getOffset(BalancePoint pt) {
      final ms =
          (pt.dateTime.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch)
              .toDouble();
      final xFraction = (ms / totalMs).clamp(0.0, 1.0);
      final x = xFraction * size.width;

      final yFraction = ((pt.balance - minY) / yRange).clamp(0.0, 1.0);
      final y = size.height - (yFraction * size.height);

      return Offset(x, y);
    }

    final greenPaint = Paint()
      ..color = const Color.fromARGB(255, 5, 169, 5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final redPaint = Paint()
      ..color = const Color.fromARGB(255, 200, 5, 5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i < points.length; i++) {
      final p1 = getOffset(points[i - 1]);
      final p2 = getOffset(points[i]);

      final paint =
          points[i].balance >= points[i - 1].balance ? greenPaint : redPaint;
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StockChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.minY != minY ||
        oldDelegate.maxY != maxY;
  }
}

class InsightsHeader extends StatelessWidget {
  final String dateString;

  const InsightsHeader({super.key, required this.dateString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children: [
          Text(
            "Insights",
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

class SpendingByCategoryCard extends StatelessWidget {
  final List<MapEntry<String, double>> topCategories;
  final double totalExpenses;
  final String currencyType;
  final Color borderColor;

  const SpendingByCategoryCard({
    super.key,
    required this.topCategories,
    required this.totalExpenses,
    required this.currencyType,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: currentTheme.backgroundNoteColor,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(1.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SPENDING BY CATEGORY",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
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
                        double progress = totalExpenses > 0
                            ? double.parse((entry.value / totalExpenses)
                                .toStringAsFixed(2))
                            : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 6.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${entry.key} - ${(progress * 100).toStringAsFixed(0)}% - ${entry.value.toStringAsFixed(2)}$currencyType",
                                style: TextStyle(
                                  color: foregroundColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 30,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor:
                                      currentTheme.progressBarBGColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      currentTheme.accentColor),
                                  borderRadius: BorderRadius.circular(2),
                                ),
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

class MonthlyIncomeExpensesListCard extends StatelessWidget {
  final List<MonthlyData> monthlyDataFull;
  final String currencyType;
  final Color borderColor;
  final DateTime now;

  const MonthlyIncomeExpensesListCard({
    super.key,
    required this.monthlyDataFull,
    required this.currencyType,
    required this.borderColor,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: currentTheme.backgroundNoteColor,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(1.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "INCOME & EXPENSES - ${DateFormat("yyyy").format(now)}",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  if (monthlyDataFull.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "No data recorded",
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
                      itemCount: monthlyDataFull.length,
                      itemBuilder: (context, index) {
                        final entry = monthlyDataFull[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.label,
                                style: TextStyle(
                                  color: foregroundColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
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
                                        "$currencyType${entry.income.abs().toStringAsFixed(2)}",
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
                                        "$currencyType${entry.expenses.abs().toStringAsFixed(2)}",
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

class IncomeVsExpensesChartCard extends StatelessWidget {
  final List<MonthlyData> monthlyData;
  final String currencyType;
  final Color borderColor;

  const IncomeVsExpensesChartCard({
    super.key,
    required this.monthlyData,
    required this.currencyType,
    required this.borderColor,
  });

  Widget _buildIncomeVsExpensesChart() {
    double maxVal = 0.0;
    for (final m in monthlyData) {
      if (m.income > maxVal) maxVal = m.income;
      if (m.expenses > maxVal) maxVal = m.expenses;
    }

    double topY;
    if (maxVal <= 0) {
      topY = 100.0;
    } else if (maxVal <= 10) {
      topY = 10.0;
    } else if (maxVal <= 50) {
      topY = ((maxVal / 10).ceil() * 10).toDouble();
    } else if (maxVal <= 100) {
      topY = ((maxVal / 10).ceil() * 10).toDouble();
    } else if (maxVal <= 500) {
      topY = ((maxVal / 50).ceil() * 50).toDouble();
    } else if (maxVal <= 1000) {
      topY = ((maxVal / 100).ceil() * 100).toDouble();
    } else {
      topY = ((maxVal / 500).ceil() * 500).toDouble();
    }

    const double chartHeight = 180.0;
    final yTextStyle = TextStyle(
      color: foregroundColor,
      fontSize: 11,
      fontWeight: FontWeight.w400,
    );

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: chartHeight,
              width: 42,
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatChartValue(topY, currencyType),
                        style: yTextStyle),
                    Text(formatChartValue(topY * 0.75, currencyType),
                        style: yTextStyle),
                    Text(formatChartValue(topY * 0.5, currencyType),
                        style: yTextStyle),
                    Text(formatChartValue(topY * 0.25, currencyType),
                        style: yTextStyle),
                    Text("0$currencyType", style: yTextStyle),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: chartHeight,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.white, width: 2),
                    bottom: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final m in monthlyData)
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final incRatio = (m.income / topY).clamp(0.0, 1.0);
                            final expRatio =
                                (m.expenses / topY).clamp(0.0, 1.0);

                            final incH = incRatio * constraints.maxHeight;
                            final expH = expRatio * constraints.maxHeight;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 10,
                                  height: incH > 0 ? incH : 0,
                                  color: const Color.fromARGB(255, 5, 169, 5),
                                ),
                                const SizedBox(width: 2),
                                Container(
                                  width: 10,
                                  height: expH > 0 ? expH : 0,
                                  color: const Color.fromARGB(255, 200, 5, 5),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(width: 42),
            Expanded(
              child: Row(
                children: [
                  for (final m in monthlyData)
                    Expanded(
                      child: Text(
                        m.label,
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: currentTheme.backgroundNoteColor,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(1.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "INCOME VS EXPENSES",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 12),
                  _buildIncomeVsExpensesChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceStockChartCard extends StatelessWidget {
  final List<Transaction> transactions;
  final String currencyType;
  final Color borderColor;

  const BalanceStockChartCard({
    super.key,
    required this.transactions,
    required this.currencyType,
    required this.borderColor,
  });

  Widget _buildBalanceChart() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 6, 1);
    final endDate = now;

    double initialBalance = 0.0;
    for (final tx in transactions) {
      final ms =
          tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp;
      final txDate = DateTime.fromMillisecondsSinceEpoch(ms);
      if (txDate.isBefore(startDate)) {
        if (tx.isIncome) {
          initialBalance += tx.amount;
        } else {
          initialBalance -= tx.amount;
        }
      }
    }

    final rangeTransactions = transactions.where((tx) {
      final ms =
          tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp;
      final txDate = DateTime.fromMillisecondsSinceEpoch(ms);
      return !txDate.isBefore(startDate);
    }).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    double currentBal = initialBalance;
    final List<BalancePoint> points = [];
    points.add(BalancePoint(dateTime: startDate, balance: currentBal));

    double maxBal = currentBal;
    double minBal = currentBal;

    for (final tx in rangeTransactions) {
      final ms =
          tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp;
      final txDate = DateTime.fromMillisecondsSinceEpoch(ms);
      if (tx.isIncome) {
        currentBal += tx.amount;
      } else {
        currentBal -= tx.amount;
      }
      points.add(BalancePoint(dateTime: txDate, balance: currentBal));

      if (currentBal > maxBal) maxBal = currentBal;
      if (currentBal < minBal) minBal = currentBal;
    }

    if (points.last.dateTime.isBefore(endDate)) {
      points.add(BalancePoint(dateTime: endDate, balance: currentBal));
    }

    double minY = minBal < 0 ? (minBal / 100).floor() * 100.0 : 0.0;
    double maxY;
    if (maxBal <= 0) {
      maxY = 100.0;
    } else if (maxBal <= 500) {
      maxY = ((maxBal / 50).ceil() * 50).toDouble();
    } else if (maxBal <= 1000) {
      maxY = ((maxBal / 100).ceil() * 100).toDouble();
    } else if (maxBal <= 5000) {
      maxY = ((maxBal / 500).ceil() * 500).toDouble();
    } else {
      maxY = ((maxBal / 1000).ceil() * 1000).toDouble();
    }

    if (maxY <= minY) maxY = minY + 100.0;

    const double chartHeight = 180.0;
    final yTextStyle = TextStyle(
      color: foregroundColor,
      fontSize: 11,
      fontWeight: FontWeight.w400,
    );

    final List<String> monthLabels = [];
    for (int i = 6; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      monthLabels.add(DateFormat("MMM").format(d));
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: chartHeight,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatChartValue(maxY, currencyType),
                      style: yTextStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      formatChartValue(
                        minY + (maxY - minY) * 0.75,
                        currencyType,
                      ),
                      style: yTextStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      formatChartValue(
                        minY + (maxY - minY) * 0.5,
                        currencyType,
                      ),
                      style: yTextStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      formatChartValue(
                        minY + (maxY - minY) * 0.25,
                        currencyType,
                      ),
                      style: yTextStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      formatChartValue(minY, currencyType),
                      style: yTextStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: chartHeight,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: ClipRect(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: StockChartPainter(
                      points: points,
                      startDate: startDate,
                      endDate: endDate,
                      minY: minY,
                      maxY: maxY,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(width: 60),
            Expanded(
              child: Row(
                children: [
                  for (final label in monthLabels)
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: currentTheme.backgroundNoteColor,
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.circular(1.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BALANCE",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 12),
                  _buildBalanceChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatChartValue(double value, String currencyType) {
  final absValue = value.abs();

  if (absValue >= 1000000) {
    return "${(value / 1000000).toStringAsFixed(1)}M$currencyType";
  }

  if (absValue >= 1000) {
    return "${(value / 1000).toStringAsFixed(1)}K$currencyType";
  }

  return "${value.toInt()}$currencyType";
}

List<MapEntry<String, double>> getExpenseCategories(
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

  return sortedCategories.toList();
}

List<MonthlyData> getMonthlyIncomeAndExpenses(
    List<Transaction> transactions) {
  final now = DateTime.now();
  final List<MonthlyData> result = [];

  for (int i = 6; i >= 0; i--) {
    final date = DateTime(now.year, now.month - i, 1);
    final monthLabel = DateFormat("MMM").format(date);

    double inc = 0.0;
    double exp = 0.0;

    for (final tx in transactions) {
      final ms = tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp;
      final txDate = DateTime.fromMillisecondsSinceEpoch(ms);
      if (txDate.year == date.year && txDate.month == date.month) {
        if (tx.isIncome) {
          inc += tx.amount;
        } else {
          exp += tx.amount;
        }
      }
    }

    result.add(MonthlyData(
      label: monthLabel,
      income: inc,
      expenses: exp,
    ));
  }

  return result;
}

List<MonthlyData> getMonthlyIncomeAndExpensesFULL(
    List<Transaction> transactions) {
  final now = DateTime.now();
  final List<MonthlyData> result = [];

  for (int i = 11; i >= 0; i--) {
    final date = DateTime(now.year, now.month - i, 1);
    final monthLabel = DateFormat("MMMM").format(date);

    double inc = 0.0;
    double exp = 0.0;

    for (final tx in transactions) {
      final ms = tx.timestamp < 10000000000 ? tx.timestamp * 1000 : tx.timestamp;
      final txDate = DateTime.fromMillisecondsSinceEpoch(ms);
      if (txDate.year == date.year && txDate.month == date.month) {
        if (tx.isIncome) {
          inc += tx.amount;
        } else {
          exp += tx.amount;
        }
      }
    }

    result.add(MonthlyData(
      label: monthLabel,
      income: inc,
      expenses: exp,
    ));
  }

  return result;
}
