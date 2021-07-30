import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ThankYouViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  void navigateToHome() {
    _navigationService.replaceWith(Routes.mainView);
  }
}
