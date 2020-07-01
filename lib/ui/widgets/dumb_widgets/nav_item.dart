import 'package:FSOUNotes/enums/enums.dart';
import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String navItemTitle;
  final TextStyle subtitle1;
  final Function(Document) routeChangeCallback;
  final Document document;
  NavItem(this.icon,this.navItemTitle, this.subtitle1,this.routeChangeCallback,this.document);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          navItemTitle,
          style: subtitle1,
        ),
        onTap: () {
          routeChangeCallback(document);
        },
      );
  }
}