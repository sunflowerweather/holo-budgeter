import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../classes/transaction.dart';
import '../service/themes.dart';

void openEntryDialog(
  BuildContext context, {
  Function(Transaction transaction)? onSave,
}) {
  showDialog<Transaction>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _TransactionEditorDialog(onSave: onSave);
    },
  );
}

class _TransactionEditorDialog extends StatefulWidget {
  final Function(Transaction transaction)? onSave;

  const _TransactionEditorDialog({this.onSave});

  @override
  State<_TransactionEditorDialog> createState() =>
      __TransactionEditorDialogState();
}

class __TransactionEditorDialogState extends State<_TransactionEditorDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedCategory = "Groceries";
  final List<String> _categories = [
    "Groceries",
    "Dining",
    "Transport",
    "Entertainment",
    "Utilities",
    "Shopping",
    "Other",
  ];

  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;

  @override
  void initState() {
    super.initState();
    _updateDateText();
  }

  void _updateDateText() {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;

    final dateFormatted = DateFormat("dd.MM.yy").format(_selectedDate);
    if (isToday) {
      _dateController.text = "Today ($dateFormatted)";
    } else {
      _dateController.text = dateFormatted;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: background1Color,
              onSurface: foregroundColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateDateText();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: accentColor,
        width: 1.5,
      ),
    );

    final focusedBorderStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.5,
      ),
    );

    return AlertDialog(
      title: Text(
        "Add Transaction",
        style: TextStyle(color: foregroundColor),
      ),
      backgroundColor: background1Color,
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ENTRY NAME FIELD
              TextField(
                controller: _nameController,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: "Entry name (e.g. Metro, Salary, Steam, Spotify)",
                  labelStyle: TextStyle(color: foregroundColor, fontSize: 13),
                  counterStyle: TextStyle(color: foregroundColor),
                  enabledBorder: borderStyle,
                  focusedBorder: focusedBorderStyle,
                ),
                style: TextStyle(color: foregroundColor),
              ),

              const SizedBox(height: 12),

              // 2. CATEGORY DROPDOWN
              _isIncome == false ?
              DropdownButtonFormField<String>(

                initialValue: _selectedCategory,
                dropdownColor: background1Color,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: TextStyle(color: foregroundColor),
                  enabledBorder: borderStyle,
                  focusedBorder: focusedBorderStyle,
                ),
                style: TextStyle(color: foregroundColor, fontSize: 16),
                items: _categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat, style: TextStyle(color: foregroundColor)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ) : const SizedBox.shrink(),

              const SizedBox(height: 16),

              // 3. AMOUNT OF MONEY FIELD
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: "amount of money",
                  labelStyle: TextStyle(color: foregroundColor),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "€",
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  enabledBorder: borderStyle,
                  focusedBorder: focusedBorderStyle,
                ),
                style: TextStyle(color: foregroundColor),
              ),

              const SizedBox(height: 16),

              // 4. DATE PICKER FIELD
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(color: foregroundColor),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: foregroundColor,
                  ),
                  enabledBorder: borderStyle,
                  focusedBorder: focusedBorderStyle,
                ),
                style: TextStyle(color: foregroundColor),
              ),

              const SizedBox(height: 20),

              // 5. EXPENSE / INCOME TOGGLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isIncome,
                    activeThumbColor: const Color.fromARGB(255, 5, 169, 5),
                    activeTrackColor:
                        const Color.fromARGB(255, 5, 169, 5).withValues(alpha: 0.4),
                    inactiveThumbColor: const Color.fromARGB(255, 200, 5, 5),
                    inactiveTrackColor:
                        const Color.fromARGB(255, 200, 5, 5).withValues(alpha: 0.4),
                    thumbColor: WidgetStatePropertyAll(
                      _isIncome
                          ? const Color.fromARGB(255, 5, 169, 5)
                          : const Color.fromARGB(255, 200, 5, 5),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isIncome = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Income",
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      actions: [
        // CANCEL BUTTON
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: accentColor),
          ),
        ),

        // SAVE BUTTON
        TextButton(
          onPressed: () {
            final nameText = _nameController.text.trim();
            final name = nameText.isEmpty ? "Untitled" : nameText;
            final amount =
                double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

            final transaction = Transaction(
              amount: amount,
              category: _isIncome ? "Salary" : _selectedCategory,
              name: name,
              isIncome: _isIncome,
              timestamp: _selectedDate.millisecondsSinceEpoch,
            );

            if (widget.onSave != null) {
              widget.onSave!(transaction);
            }

            Navigator.pop(context, transaction);
          },
          child: Text(
            "Save",
            style: TextStyle(color: accentColor),
          ),
        ),
      ],
    );
  }
}
