
import 'package:FSOUNotes/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';

class AboutUsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

  navigateToPrivacyPolicyView() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  navigateToTermsAndConditionView() {
     _navigationService.navigateTo(Routes.termsAndConditionView);
  }
}
