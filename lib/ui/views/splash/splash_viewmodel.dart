import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:logger/logger.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("SplashViewModel");

class SplashViewModel extends FutureViewModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DialogService _dialogService = locator<DialogService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  AppInfoService _appInfoService = locator<AppInfoService>();

  handleStartUpLogic() async {
    var hasLoggedInUser = await _sharedPreferencesService.isUserLoggedIn();

    //Check if user has outdated version
    await _checkForUpdatedVersionAndShowDialog();

    if (hasLoggedInUser) {
      await _subjectsService.loadSubjects();
      _navigationService.replaceWith(Routes.homeViewRoute);
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
    log.i("Current Version :" + "$version $buildNumber");
    log.i("Are Both Equal ?");
    log.i(currentVersion == updatedVersion);
    // if update needed show a prompt
    if (_isCurrentVersionOudated(currentVersion, updatedVersion)) {
      DialogResponse response = await _dialogService.showConfirmationDialog(
          title: "Update App?",
          description:
              "A new version of OU Notes is available. Please update the app to avoid crashes and access new features");
      if (response.confirmed) {
        OpenAppstore.launch(
            androidAppId: 'com.notes.ounotes', iOSAppId: 'com.notes.ounotes');
      }
    }
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
