import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("SplashViewModel");

class SplashViewModel extends FutureViewModel {
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  AppInfoService _appInfoService = locator<AppInfoService>();
  PushNotificationService _notificationService = locator<PushNotificationService>();

  handleStartUpLogic() async {
    await _notificationService.initialise();
    var hasLoggedInUser = await _sharedPreferencesService.isUserLoggedIn();
    //Check if user has outdated version
    Map<String,dynamic> result = await _checkForUpdatedVersionAndShowDialog();

    if (hasLoggedInUser) {
      await _subjectsService.loadSubjects();
      _navigationService.replaceWith(Routes.homeViewRoute,arguments:HomeViewArguments(shouldShowUpdateDialog: result["doesUserNeedUpdate"],versionDetails: result));
    } else {
      _navigationService.replaceWith(Routes.introViewRoute);
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
}
