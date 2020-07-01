import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AboutUsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();

  navigateToPrivacyPolicyView() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  navigateToTermsAndConditionView() {
     _navigationService.navigateTo(Routes.termsAndConditionView);
  }
}
