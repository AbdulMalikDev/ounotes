import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String error, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (error == "Format Error"){
        description += "\n\nTry opening it using the GDrive link. The GDrive link can be obtained by using the share icon on the notes.\n\nAlternatively you can try downloading it by pressing the download icon on the notes.";
      }
      return AlertDialog(
        title: Text(error),
        content: Text(description),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    },
  );
}