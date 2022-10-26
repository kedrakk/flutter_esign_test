import 'package:flutter/material.dart';

errorDialog(
  String message,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
            ),
          ),
        ],
      );
    },
  );
}
