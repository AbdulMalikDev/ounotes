import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/crashlytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:FSOUNotes/ui/views/Main/main_screen_view.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("SplashViewModel");

class SplashViewModel extends FutureViewModel {
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  NotificationService _notificationService = locator<NotificationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  AppInfoService _appInfoService = locator<AppInfoService>();
  
  GoogleInAppPaymentService _googleInAppPaymentService =
  locator<GoogleInAppPaymentService>();
  CrashlyticsService _crashlyticsService = locator<CrashlyticsService>();
  

  handleStartUpLogic() async {
    log.e("Splash Open");

    var LoggedInUser = await _sharedPreferencesService.isUserLoggedIn();
    if(LoggedInUser == null){_navigationService.replaceWith(Routes.introView);}

    bool isUserOnline = await ConnectionVerify.connectionStatus();

    //>> Initialization of services, isn't this why splash screens are used?
    // await _pushNotificationService.initialise();
    await _googleInAppPaymentService.initialize();
    await _remoteConfigService.init();
    await _crashlyticsService.init();
    await _notificationService.init();
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    Hive.registerAdapter<Download>(DownloadAdapter());
    Hive.registerAdapter<RecentlyOpenedNotes>(RecentlyOpenedNotesAdapter());
    await Hive.openBox(Constants.ouNotes);
    
    //Check if user has outdated version if they're is online
    Map<String, dynamic> result;
    if(isUserOnline) result = await _checkForUpdatedVersionAndShowDialog();

    
    if (LoggedInUser != null) {
      
      //>> 1.1 Check if User is Premium
      if (LoggedInUser.isPremiumUser ?? false){
        _checkPremiumPurchaseDate(LoggedInUser.id);
      }

      //>> 1.2 Load all subjects
      await _subjectsService.loadSubjects(checkIfUpdate: true);

      //>> 1.3 Check for app update if User is online
      if(isUserOnline){

        _navigationService.replaceWith(
          Routes.mainScreenView,
          arguments:MainScreenViewArguments(
            shouldShowUpdateDialog: result["doesUserNeedUpdate"],
            versionDetails: result
            )
          );

      }else{ 
        _navigationService.replaceWith(Routes.mainScreenView);
      }
      
    }

    log.e("Splash Close");
  }

  _checkForUpdatedVersionAndShowDialog() async {
    PackageInfo packageInfo = await _appInfoService.getPackageInfo();
    String updatedVersion =
        _remoteConfigService.remoteConfig.getString('APP_VERSION');
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String currentVersion = "$version $buildNumber";
    _authenticationService.appVersion = currentVersion;
    log.i("Updated Version :" + updatedVersion);
    log.i("Current Version :" + currentVersion);
    log.i("Are Both Equal ?");
    log.i(currentVersion == updatedVersion);
    bool doesUserNeedUpdate =
        _isCurrentVersionOudated(currentVersion, updatedVersion);
    return {
      "doesUserNeedUpdate": doesUserNeedUpdate,
      "currentVersion": currentVersion,
      "updatedVersion": updatedVersion,
    };
  }

  bool _isCurrentVersionOudated(
      String currentCompleteVersion, String updatedCompleteVersion) {
    String currentVersion = currentCompleteVersion.split(" ")[0];
    String updatedVersion = updatedCompleteVersion.split(" ")[0];

    int sumOfCurrentVersion = currentVersion
        .split(".")
        .map((a) => int.parse(a))
        .toList()
        .reduce((a, b) => a + b);
    int sumOfUpdatedVersion = updatedVersion
        .split(".")
        .map((a) => int.parse(a))
        .toList()
        .reduce((a, b) => a + b);

    if (sumOfCurrentVersion < sumOfUpdatedVersion) {
      return true;
    } else if (sumOfCurrentVersion == sumOfUpdatedVersion) {
      int currentBuild = int.parse(currentCompleteVersion.split(" ")[1]);
      int updatedBuild = int.parse(updatedCompleteVersion.split(" ")[1]);

      if (currentBuild < updatedBuild) {
        return true;
      }
    }

    return false;
  }

  @override
  Future futureToRun() => handleStartUpLogic();

  void _checkPremiumPurchaseDate(id) async {
    // User user = await _firestoreService.getUserById(id);
    // DateTime expiryDate = user?.premiumPurchaseDate?.add(Duration(days: 365)) ?? DateTime.now().add(Duration(days:365));
    // if(expiryDate.isAfter(DateTime.now())){
    //   user.setPremiumUser = false;
    // }
    // await _firestoreService.updateUserInFirebase(user,updateLocally: true);
    // await _notificationService.dispatchLocalNotification(NotificationService.premium_purchase_notify,{
    //     "title":"Your Premium Package has expired",
    //     "body" : "Enjoy OU Notes Ad-free and download unlimited offline Notes and save Data by becoming a pro member !",
    //   }
    // );
  }
}
