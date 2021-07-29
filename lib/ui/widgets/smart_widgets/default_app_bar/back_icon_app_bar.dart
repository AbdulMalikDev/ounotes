import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';

class BackIconAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool showTitle;
  @override
  final Size preferredSize;
  BackIconAppBar(
      {Key key, this.title,this.showTitle})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    BoxShadow defaultAppBarShadow = BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      // blurRadius: 0.5,
      offset: Offset(0, 2),
    );
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        maintainBottomViewPadding: false,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white, boxShadow: [defaultAppBarShadow]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
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
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: App(context).appHeight(0.05),
                      child: Image.asset(
                        Constants.appIcon,
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
