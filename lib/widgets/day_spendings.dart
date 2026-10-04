import 'package:flutter/material.dart';
import 'package:holo_budgeter/classes/transaction.dart';
import 'package:holo_budgeter/service/themes.dart';

class DaySpendings extends StatelessWidget {
  final Transaction transaction;
  final bool showCategory;
  final String currencyType;
  final VoidCallback? onLongPress;

  const DaySpendings({
    super.key,
    required this.transaction,
    this.showCategory = false,
    required this.currencyType,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final textColor = isIncome
        ? const Color.fromARGB(255, 5, 169, 5)
        : const Color.fromARGB(255, 200, 5, 5);
    final formattedAmount =
        "${isIncome ? '+$currencyType' : '-$currencyType'}${transaction.amount.toStringAsFixed(2)}";

    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 6.0,
      ),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                showCategory ? "[${transaction.category}] ${transaction.name}" : transaction.name,
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
              formattedAmount,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
              softWrap: false,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
