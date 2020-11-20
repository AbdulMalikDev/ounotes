import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static showWillPopDialog({BuildContext context}) {
    var theme = Theme.of(context);
    showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Row(
          children: <Widget>[
            Icon(Icons.warning),
            Text(
              'Warning',
              style: theme.textTheme.headline6,
            ),
          ],
        ),
        content: Text(
          'Do you really want to exit',
          style: theme.textTheme.headline6.copyWith(fontSize: 18),
        ),
        actions: [
          FlatButton(
            child: Text(
              'No',
              style:
                  Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
            ),
            onPressed: () => Navigator.pop(c, false),
          ),
          FlatButton(
            child: Text(
              'Yes',
              style:
                  Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
            ),
            onPressed: () => exit(0),
          ),
        ],
      ),
    );
  }

   static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
