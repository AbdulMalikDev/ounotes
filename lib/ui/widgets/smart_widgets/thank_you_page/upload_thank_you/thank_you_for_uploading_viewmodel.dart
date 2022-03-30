import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ThankYouForUploadingViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  void navigateToHome() {
    // _navigationService.popUntil(
    //   (route) =>
    //       route.settings.name == Routes.allDocumentsView ||
    //       route.settings.name == Routes.mainView,
    // );
    _navigationService.replaceWith(Routes.mainScreenView);
  }
}
