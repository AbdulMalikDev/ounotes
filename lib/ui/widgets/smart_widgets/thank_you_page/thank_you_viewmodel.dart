import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ThankYouViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  void navigateToHome() {
    _navigationService.popUntil((route) => route.settings.name == Routes.homeViewRoute);
  }
}