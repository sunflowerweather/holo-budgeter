import 'package:flutter/material.dart';

import '../service/themes.dart';

void showDeleteConfirmation(
    BuildContext context,
    VoidCallback onDelete,
    ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: background1Color,

        title: Text(
          'Delete this transaction?',
          style: TextStyle(color: foregroundColor),
        ),

        content: Text(
          'If you delete this transaction, you wouldn`t be able to restore it',
          style: TextStyle(color: foregroundColor),
        ),

        actions: <Widget>[

          // CANCEL
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            child: Text(
              'Cancel',
              style: TextStyle(
                color: accentColor,
              ),
            ),
          ),

          // DELETE
          TextButton(
            onPressed: () {

              onDelete();

              Navigator.of(context).pop();
            },

            child: Text(
              'OK',
              style: TextStyle(
                color: accentColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}