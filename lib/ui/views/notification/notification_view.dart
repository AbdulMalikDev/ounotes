import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'notification_viewmodel.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key key}) : super(key: key);
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.nonReactive(
      viewModelBuilder: () => NotificationViewModel(),
      builder: (
        BuildContext context,
        NotificationViewModel model,
        Widget child,
      ) {
        return Scaffold(
          body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: model.isBusy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : model.notifications.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/student_reading.jpg',
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 300,
                                ),
                                Text(
                                  "No New Notifications!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "You're all caught up!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          : Column(
                            //TODO wajid build proper UI List
                                  children: model.notifications.map((e) => Container(child: Text(e.body),)).toList(),
                                ),
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}