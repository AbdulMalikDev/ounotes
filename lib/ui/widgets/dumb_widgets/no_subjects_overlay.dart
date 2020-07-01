import 'package:FSOUNotes/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class NoSubjectsOverlay extends StatelessWidget {
  const NoSubjectsOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UIhelper ui = UIhelper.mediaQuery(context:context);
    return Container(
      height: ui.screenHeightWithoutSafeArea*0.7,
          child: Center(
            child: Text(
              "Your Subjects will appear here",
              style: theme.textTheme.subtitle1.copyWith(fontSize: 17),
            ),
          ),
        );
  }
}