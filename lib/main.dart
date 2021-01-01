import 'dart:async';

import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/AppTheme/AppTheme.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/crashlytics_service.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/bottom_sheet/bottom_sheet_ui_view.dart';
import 'package:adcolony/adcolony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:wiredash/wiredash.dart';

import './app/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/logger.dart';
import 'app/router.gr.dart' as router;
import 'package:sentry/sentry.dart';

Logger log = getLogger("main");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Dynamic Injection
  setupLocator();
  //Setting custom Bottom Sheet
  setUpBottomSheetUi();
  //Setting up Hive DB
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  await Hive.openBox("OUNOTES");
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();
  await _remoteConfigService.init();
  //Sentry provides crash reporting
  _crashlyticsService.sentryClient = SentryClient(
      dsn: _remoteConfigService.remoteConfig.getString('SentryKey'));
  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  OneSignal.shared
      .init(_remoteConfigService.remoteConfig.getString('ONESIGNAL_KEY'));
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  Logger.level = Level.verbose;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AppStateNotifier.isDarkModeOn = prefs.getBool('isdarkmodeon') ?? false;
  //TODO DevChecklist - Uncomment for error handling
  // FlutterError.onError = (details, {bool forceReport = false}) {
  //   _crashlyticsService.sentryClient.captureException(
  //     exception: details.exception,
  //     stackTrace: details.stack,
  //   );
  // };
    runApp(MyApp());
    // runZonedGuarded(
    //   () => runApp(MyApp()),
    //   (error, stackTrace) async {
    //     await _crashlyticsService.sentryClient.captureException(
    //       exception: error,
    //       stackTrace: stackTrace,
    //     );
    //   },
    // );
  }

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ViewModelBuilder<AppStateNotifier>.reactive(
      builder: (context, model, child) => FeatureDiscovery(
        child: Wiredash(
          projectId: _remoteConfigService.remoteConfig
              .getString("WIREDASH_PROJECT_ID"),
          secret:
              _remoteConfigService.remoteConfig.getString("WIREDASH_SECRET"),
          navigatorKey: locator<NavigationService>().navigatorKey,
          child: MaterialApp(
            navigatorObservers: <NavigatorObserver>[observer],
            title: 'OU Notes',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: AppStateNotifier.isDarkModeOn
                ? ThemeMode.dark
                : ThemeMode.light,
            onGenerateRoute: router.Router().onGenerateRoute,
            navigatorKey: locator<NavigationService>().navigatorKey,
          ),
        ),
      ),
      viewModelBuilder: () => locator<AppStateNotifier>(),
    );
  }
}

// OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//   // will be called whenever a notification is opened/button pressed.
// });
