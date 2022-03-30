import 'package:flutter/material.dart';

class BackIconTitleAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  @override
  final Size preferredSize;
  BackIconTitleAppBar({Key key, this.title})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 17,
              ),
        ));
  }
}
