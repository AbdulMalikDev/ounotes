import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
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

class SplashViewModel extends FutureViewModel{


  AuthenticationService _authenticationService = locator<AuthenticationService>();
  DialogService _dialogService = locator<DialogService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

    handleStartUpLogic() async 
    {

    var hasLoggedInUser = await _sharedPreferencesService.isUserLoggedIn();

    //Check if user has outdated version
    await _checkForUpdatedVersionAndShowDialog();
    
    
    if(hasLoggedInUser)
    {

       await _subjectsService.loadSubjects();
       _navigationService.replaceWith(Routes.homeViewRoute);

    }else{

      _navigationService.replaceWith(Routes.introViewRoute);

    }


    
    }

    _checkForUpdatedVersionAndShowDialog() async {
      String updatedVersion = _remoteConfigService.remoteConfig.getString('APP_VERSION');
      log.e(updatedVersion);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      String currentVersion = "$version $buildNumber" ;
      log.e("$version $buildNumber");
      log.e(currentVersion == updatedVersion);
      if(currentVersion != updatedVersion)
      {
        DialogResponse response = await _dialogService.showConfirmationDialog(title: "Update App?" , description: "A new version of OU Notes is available. Please update the app to avoid crashes and access new features");
        if(response.confirmed)
        {
          OpenAppstore.launch(
              androidAppId: 'com.notes.ounotes',
              iOSAppId: 'com.notes.ounotes');
        }
      }
    }

  @override
  Future futureToRun() => handleStartUpLogic();





  
}