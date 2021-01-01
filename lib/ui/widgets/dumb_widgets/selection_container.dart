import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectionContainer extends StatelessWidget {
  final String title;
  final Function onTap;
  final Widget leading;

  const SelectionContainer({Key key, this.title, this.onTap, this.leading,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: App(context).appHeight(0.08),
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: primary,
          width: 1.5,
        ),
      ),
      child: Center(
        child: ListTile(
          leading:leading ,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 16),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ],
          ),
          onTap: onTap
        ),
      ),
    );
  }
}
