import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../classes/transaction.dart';
import 'data_prefs.dart';

Future<bool> importBackup() async {
  try {
    // 1. Pick JSON file from storage
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      print("No file selected");
      return false;
    }

    final file = File(result.files.single.path!);

    // 2. Read file
    final jsonString = await file.readAsString();

    // 3. Decode JSON
    final decoded = jsonDecode(jsonString);

    List<dynamic> rawList = [];
    if (decoded is Map<String, dynamic> && decoded.containsKey('transactions')) {
      rawList = decoded['transactions'] as List<dynamic>;
    } else if (decoded is List) {
      rawList = decoded;
    } else {
      throw const FormatException("Invalid backup format: expected transaction list or object");
    }

    // 4. Convert and validate transactions
    final List<Transaction> loadedTransactions = rawList
        .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
        .toList();

    // 5. Save to DataPrefs
    final jsonToSave =
        jsonEncode(loadedTransactions.map((t) => t.toJson()).toList());
    await DataPrefs.saveKeyString(jsonToSave, "transactions");

    print("Backup restored successfully");
    return true;
  } catch (e, stack) {
    print("Import failed: $e");
    print(stack);
    rethrow;
  }
}