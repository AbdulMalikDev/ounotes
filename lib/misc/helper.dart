import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
          'Do you really want to exit?',
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

  //Function to show custom dialog which is used to confim user before deleting any item
  static showDeleteConfirmDialog({
    BuildContext context,
    Function onDeletePressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Color.fromRGBO(255, 184, 0, 0.47),
                radius: 30,
                child: CircleAvatar(
                  backgroundColor: Color(0xffFFB800),
                  radius: 25,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        MdiIcons.exclamation,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Are you sure you want to delete this subject?'),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffFFB800),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xffFFB800),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onDeletePressed,
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffFFB800),
                          ),
                          color: Color(0xffFFB800),
                        ),
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
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
