import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/AppTheme/AppTheme.dart';
import 'package:FSOUNotes/app/config_reader.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import './app/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/router.gr.dart' as router;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await DotEnv().load('.env');
  OneSignal.shared.init(
    DotEnv().env['ONESIGNAL_KEY'],
  );
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  Logger.level = Level.verbose;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppStateNotifier.isDarkModeOn = prefs.getBool('isdarkmodeon') ?? false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics());
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppStateNotifier>.reactive(
      builder: (context, model, child) => MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
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
