import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AdminViewModel extends BaseViewModel{


  NavigationService _navigationService = locator<NavigationService>();


  navigateToAddVerifierView(){
    _navigationService.navigateTo(Routes.addVerifierView);
  }
  
}