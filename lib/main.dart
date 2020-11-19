import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/AppTheme/AppTheme.dart';
import 'package:FSOUNotes/app/config_reader.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import './app/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/router.gr.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  OneSignal.shared.init("88245c37-d424-4163-a9c3-2a9eb978a01f",);
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  Logger.level = Level.verbose;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppStateNotifier.isDarkModeOn = prefs.getBool('isdarkmodeon') ?? false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppStateNotifier>.reactive(
      builder: (context, model, child) => MaterialApp(
        title: 'OU Notes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            AppStateNotifier.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        onGenerateRoute: router.Router().onGenerateRoute,
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
      viewModelBuilder: () => locator<AppStateNotifier>(),
    );
  }
}
