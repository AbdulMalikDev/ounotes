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
          child: Text(
              'NotificationView',
            ),
          ),
        );
      },
    );
  }
}