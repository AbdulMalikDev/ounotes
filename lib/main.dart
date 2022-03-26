import 'dart:async';

import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/AppTheme/AppTheme.dart';
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/crashlytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/bottom_sheet/bottom_sheet_ui_view.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
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
  log.e("Main Open");
  
  WidgetsFlutterBinding.ensureInitialized();
  //Dynamic Injection
  setupLocator();
  //Setting custom Bottom Sheet
  setUpBottomSheetUi();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  await _remoteConfigService.init();
  Logger.level = Level.verbose;
  PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();
  await _pushNotificationService.initialise();
  runApp(MyApp());

  log.e("Main Close");
  // await dothis();
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText;
  // This widget is the root of your application
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();

  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics());

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return ViewModelBuilder<AppStateNotifier>.reactive(
      builder: (context, model, child) => FeatureDiscovery(
        child: Wiredash(
          // projectId: _remoteConfigService.remoteConfig
          //     .getString("WIREDASH_PROJECT_ID"),
          // secret:
          //     _remoteConfigService.remoteConfig.getString("WIREDASH_SECRET"),
          projectId: "ffff",
          secret:"dddd",
          navigatorKey: StackedService.navigatorKey,
          child: ThemeProvider(
              initTheme: AppStateNotifier.isDarkModeOn
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme,
              builder: (context, myTheme) {
                return MaterialApp(
                  navigatorObservers: <NavigatorObserver>[observer],
                  title: 'OU Notes',
                  debugShowCheckedModeBanner: false,
                  theme: myTheme,
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
      viewModelBuilder: () => locator<AppStateNotifier>(),
    );
  }

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
          
        if (value.isEmpty){
          Fluttertoast.showToast(msg: "No Documents Shared");
          return;
        }
        log.e("For sharing images coming from outside the app while the app is in the memory");
        log.e(value);
        log.e(value[0].path);
        log.e(value[0].thumbnail);
        log.e(value[0].type);
        DocumentService _documentService = locator<DocumentService>();
        _documentService.shareFile(value);

    }, onError: (err) {
      log.e("getIntentDataStream error while sharing doc in main.dart: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      log.e("For sharing images coming from outside the app while the app is closed");
      setState(() {
        _sharedFiles = value;
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      log.e("For sharing or opening urls/text coming from outside the app while the app is closed");
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}
