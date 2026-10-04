import 'dart:convert';
import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'data_prefs.dart';

Future<void> exportBackup() async {
  try {
    final date = DateFormat('ddMMyyyy-hhmmss').format(DateTime.now());

    final jsonString = await DataPrefs.loadKeyString("transactions");
    final List<dynamic> transactionsJson =
        jsonString != null ? jsonDecode(jsonString) : [];

    final Map<String, dynamic> backupData = {
      'version': 1,
      'transactions': transactionsJson,
    };

    final jsonOutput = jsonEncode(backupData);

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/back-$date.json');
    await tempFile.writeAsString(jsonOutput);

    await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        sourceFilePath: tempFile.path,
        fileName: 'HoloBudgeter/back-$date.json',
      ),
    );

    print("Backup exported successfully");
  } catch (e, stack) {
    print("Backup failed: $e");
    print(stack);
    rethrow;
  }
}