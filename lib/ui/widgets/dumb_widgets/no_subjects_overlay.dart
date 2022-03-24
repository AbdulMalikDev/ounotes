import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoSubjectsOverlay extends StatelessWidget {
  const NoSubjectsOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UIhelper ui = UIhelper.mediaQuery(context: context);
    return Container(
      height: ui.screenHeightWithoutSafeArea * 0.35,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -50,
            left: ui.screenWidthWithoutSafeArea * 0.1,
            right: ui.screenWidthWithoutSafeArea * 0.1,
            child: Lottie.asset('assets/lottie/learn.json',
                fit: BoxFit.fill, height: ui.screenHeightWithoutSafeArea * 0.4),
          ),
          Positioned(
            top: App(context).appHeight(0.25),
            left: 60,
            right: 50,
            child: Text(
              "Your Subjects will appear here",
              style: theme.textTheme.subtitle1.copyWith(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
