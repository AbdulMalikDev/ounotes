import 'dart:math';

import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/email_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:upi_pay/upi_pay.dart';

class DrawerViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AppStateNotifier _appStateNotifier = locator<AppStateNotifier>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  bool get isAdmin => _authenticationService.user.isAdmin;


  dispatchEmail() async {
    await EmailService.emailFunc(
      subject: "OU Notes Feedback",
      body:
          "[if you are facing errors please attach Screen Shots or Screen Recordings]",
    );
  }

  


  updateAppTheme(BuildContext context) async {
    bool boolVal = !AppStateNotifier.isDarkModeOn;
    _appStateNotifier.updateTheme(boolVal);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isdarkmodeon', boolVal);
    notifyListeners();
  }

  navigateToAllDocumentsScreen(Document document) {
    _navigationService.navigateTo(Routes.allDocumentsViewRoute);
  }

  navigateToProfileScreen(Document p1) {
    _navigationService.navigateTo(Routes.profileView);
  }

  navigateToAboutUsScreen(Document p1) {
    _navigationService.navigateTo(Routes.aboutUsViewRoute);
  }

  navigateToUserUploadScreen(Document p1) {
    _navigationService.navigateTo(
      Routes.uploadSelectionViewRoute,
      arguments: UploadSelectionViewArguments(path: p1),
    );
  }

  navigateToDownloadScreen(Document p1) {
    _navigationService.navigateTo(Routes.downLoadView);
  }

  navigateToFDIntroScreen(Document path) {
    _navigationService.navigateTo(Routes.fdInputView,
        arguments: FDInputViewArguments(path: path));
  }

  navigateToAdminUploadScreen(Document path) {
    _navigationService.navigateTo(Routes.adminViewRoute,
        arguments: FDInputViewArguments(path: path));
  }

  void recordTelegramVisit() {
    _analyticsService.addTagInNotificationService(
        key: "TELEGRAM", value: "VISITED");
    _analyticsService.logEvent(name: "TELEGRAM_VISIT");
  }
}
