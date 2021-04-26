import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
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
  AppInfoService _appInfoService = locator<AppInfoService>();
  PushNotificationService _pushNotificationService = locator<PushNotificationService>();

  handleStartUpLogic() async {
    bool isUserOnline = await ConnectivityWrapper.instance.isConnected;

    await _pushNotificationService.initialise();
    var LoggedInUser = await _sharedPreferencesService.isUserLoggedIn();
    //Check if user has outdated version if he/she is online
    Map<String,dynamic> result;
    if(isUserOnline) result = await _checkForUpdatedVersionAndShowDialog();

    if (LoggedInUser != null) {
      if(LoggedInUser.isPremiumUser ?? false)
      _checkPremiumPurchaseDate(LoggedInUser.id);
      await _subjectsService.loadSubjects();
      if(isUserOnline)_navigationService.replaceWith(Routes.homeView,arguments:HomeViewArguments(shouldShowUpdateDialog: result["doesUserNeedUpdate"],versionDetails: result));
      else _navigationService.replaceWith(Routes.homeView);
    } else {
      log.e("user is null");
      _navigationService.replaceWith(Routes.introView);
    }
  }

  _checkForUpdatedVersionAndShowDialog() async {
    PackageInfo packageInfo = await _appInfoService.getPackageInfo();
    String updatedVersion =
        _remoteConfigService.remoteConfig.getString('APP_VERSION');
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String currentVersion = "$version $buildNumber";
    log.i("Updated Version :" + updatedVersion);
    log.i("Current Version :" + currentVersion);
    log.i("Are Both Equal ?");
    log.i(currentVersion == updatedVersion);
    bool doesUserNeedUpdate = _isCurrentVersionOudated(currentVersion, updatedVersion); 
    return {
      "doesUserNeedUpdate" : doesUserNeedUpdate,
      "currentVersion" : currentVersion,
      "updatedVersion" : updatedVersion,
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
