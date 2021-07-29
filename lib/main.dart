import 'dart:async';

import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/AppTheme/AppTheme.dart';
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/crashlytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/bottom_sheet/bottom_sheet_ui_view.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:wiredash/wiredash.dart';

import 'app/app.locator.dart';
import 'app/app.logger.dart';
import 'app/app.router.dart';
import 'enums/constants.dart';
import 'models/download.dart';

Logger log = getLogger("main");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Dynamic Injection
  setupLocator();
  //Setting custom Bottom Sheet
  setUpBottomSheetUi();
  //Setting up Hive DB
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter<Download>(DownloadAdapter());
  Hive.registerAdapter<RecentlyOpenedNotes>(RecentlyOpenedNotesAdapter());
  await Hive.openBox(Constants.ouNotes);
  await Hive.openBox<Download>(Constants.downloads);
  await Hive.openBox<RecentlyOpenedNotes>(Constants.recentlyOpenedNotes);
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  // CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();
  // AdmobService _admobService = locator<AdmobService>();
  // InAppPaymentService _inAppPaymentService= locator<InAppPaymentService>();
  // NotificationService _notificationService = locator<NotificationService>();
  // GoogleInAppPaymentService _googleInAppPaymentService =
  // locator<GoogleInAppPaymentService>();
  // await _inAppPaymentService.fetchData();
  await _remoteConfigService.init();
  // await _admobService.init();
  //Sentry provides crash reporting
  // _crashlyticsService.sentryClient = SentryClient(
  //     dsn: _remoteConfigService.remoteConfig.getString('SentryKey'));
  // OneSignal.shared
  //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
  // OneSignal.shared
  //     .init(_remoteConfigService.remoteConfig.getString('ONESIGNAL_KEY'));
  // OneSignal.shared
  //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
  Logger.level = Level.verbose;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // AppStateNotifier.isDarkModeOn = prefs.getBool('isdarkmodeon') ?? false;
  // await _notificationService.init();
  // InAppPurchaseConnection.enablePendingPurchases();
  // await _googleInAppPaymentService.initialize();
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
  //     // await _crashlyticsService.sentryClient.captureException(
  //     //   exception: error,
  //     //   stackTrace: stackTrace,
  //     // );
  //   },
  // );
  await dothis();
}

dothis() async {
  // try {
  //   PurchaserInfo purchaserInfo;
  //   Purchases.getPurchaserInfo().asStream().listen((event) async {
  //     purchaserInfo = event;
  //     log.e(event?.toString());
  //     final isPro = purchaserInfo.entitlements.active.containsKey("pdf_downloader");
  //     log.e(purchaserInfo.toString());
  //     Offerings offerings = await Purchases.getOfferings();
  //     if (offerings.current != null) {
  //       // Display current offering with offerings.current
  //       log.e(offerings.current);
  //       log.e(offerings.current.availablePackages);
  //     }
  //   });
  // } catch (e) {
  //     // optional error handling
  //     log.e(e.toString());
  // }
  // // try {
  //   PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
  //   var isPro = purchaserInfo.entitlements.all["my_entitlement_identifier"].isActive;
  //   if (isPro) {
  //     // Unlock that great "pro" content
  //   }
  // } on PlatformException catch (e) {
  //   var errorCode = PurchasesErrorHelper.getErrorCode(e);
  //   if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
  //     showError(e);
  //   }
  // }
  // QuerySnapshot users = await Firestore.instance.collection("users").orderBy("id").getDocuments();
  // log.e(users.documents.length);
  // for (int i=0 ; i<users.documents.length ; i++){
  //   try {
  //     DocumentSnapshot doc = users.documents[i];
  //     userModel.User user = userModel.User.fromData(doc.data);
  //     if(user.college == "Swathi Institute of Technology & Science."){
  //       user.college = "Swathi Institute of Technology & Science";
  //     }
  //     if(user.college==null || user.semester == null || user.branch==null){continue;}
  //     await Firestore.instance.collection("users").document(Constants.userStats).updateData({
  //       "total_users": FieldValue.increment(1),
  //       user.college : FieldValue.increment(1),
  //       user.semester: FieldValue.increment(1),
  //       user.branch  : FieldValue.increment(1),
  //     });
  //     log.e(i);
  //     log.e(user.college);
  //     log.e(user.semester);
  //     log.e(user.branch);
  //     await Future.delayed(Duration(microseconds: 10));
  //   }catch (e) {
  //     log.e(e.toString());
  //   }
  // }
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
          projectId: "Sometid",
          secret: "sdsdsd",
          // projectId: _remoteConfigService.remoteConfig
          //     .getString("WIREDASH_PROJECT_ID"),
          // secret:
          //     _remoteConfigService.remoteConfig.getString("WIREDASH_SECRET"),
          navigatorKey: StackedService.navigatorKey,
          child: ThemeProvider(
            initTheme: AppStateNotifier.isDarkModeOn
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            child: Builder(builder: (context) {
              return MaterialApp(
                navigatorObservers: <NavigatorObserver>[observer],
                title: 'OU Notes',
                debugShowCheckedModeBanner: false,
                theme: ThemeProvider.of(context),
                // theme: AppTheme.lightTheme,
                // darkTheme: ThemeProvider.of(context),
                // themeMode: AppStateNotifier.isDarkModeOn
                //     ? ThemeMode.dark
                //     : ThemeMode.light,
                onGenerateRoute: StackedRouter().onGenerateRoute,
                navigatorKey: StackedService.navigatorKey,
              );
            }),
          ),
        ),
      ),
      viewModelBuilder: () => locator<AppStateNotifier>(),
    );
  }
}
