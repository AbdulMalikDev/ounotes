import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends FutureViewModel{


  AuthenticationService _authenticationService = locator<AuthenticationService>();
  
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

    handleStartUpLogic() async 
    {

    var hasLoggedInUser = await _sharedPreferencesService.isUserLoggedIn();

    
    if(hasLoggedInUser)
    {

       await _subjectsService.loadSubjects();
       _navigationService.replaceWith(Routes.homeViewRoute);

    }else{

      _navigationService.replaceWith(Routes.introViewRoute);

    }

    
    }

  @override
  Future futureToRun() => handleStartUpLogic();





  
}