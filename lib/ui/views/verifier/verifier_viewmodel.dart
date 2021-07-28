import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VerifierPanelViewModel extends BaseViewModel {


  NavigationService _navigationService = locator<NavigationService>();


  navigateToVerifyDocumentsScreen() {
    _navigationService.navigateTo(Routes.verifyDocumentsView);
  }

  navigateToReportedDocumentsScreen() {
    _navigationService.navigateTo(Routes.reportedDocumentsView);
  }
}