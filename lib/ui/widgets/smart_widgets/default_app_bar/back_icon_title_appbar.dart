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
    BoxShadow defaultAppBarShadow = BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      // blurRadius: 0.5,
      offset: Offset(0, 2),
    );
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        maintainBottomViewPadding: false,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [defaultAppBarShadow],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: 17,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
