import 'dart:convert';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';

class SettingsViewModel extends BaseViewModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  User _user= User();
  User get user => _user;
  String _userOption;

  String get userOption => _userOption;

  List<DropdownMenuItem<String>> _dropDownOfOpenPDF;
  List<DropdownMenuItem<String>> get dropDownOfOpenPDF => _dropDownOfOpenPDF;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = [];
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Text(item)));
    });
    return i;
  }

  void changedDropDownItemOfOpenPdfChoice(String newChoice) async {
    _userOption = newChoice;
    SharedPreferences prefs = await _sharedPreferencesService.store();
    if (newChoice == "Ask me before opening pdf") {
      if (prefs.containsKey("openDocChoice")) {
        prefs.remove("openDocChoice");
      }
    } else {
      prefs.setString("openDocChoice", newChoice);
    }
    Fluttertoast.showToast(msg: "Settings Saved !");
    notifyListeners();
  }

  Future setUser() async {
    SharedPreferences prefs = await _sharedPreferencesService.store();
    if (prefs.containsKey("openDocChoice")) {
      _userOption = prefs.getString("openDocChoice");
    } else {
      _userOption = "Ask me before opening pdf";
    }
    List<String> items = [
      "Open In App",
      "Open In Browser",
      "Ask me before opening pdf"
    ];
    _dropDownOfOpenPDF = buildAndGetDropDownMenuItems(items);
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));
    _user = user;
    notifyListeners();
  }

  void recordTelegramVisit() {
    _analyticsService.addTagInNotificationService(
        key: "TELEGRAM", value: "VISITED");
    _analyticsService.logEvent(name: "TELEGRAM_VISIT");
  }

  handleSignOut() async {
    DialogResponse dialogResult = await _dialogService.showConfirmationDialog(
      title: "Change Profile Data",
      description:
          "In Order to change your data,you just need to sign-in again using your Gmail id",
      cancelTitle: "GO BACK",
      confirmationTitle: "PROCEED",
    );
    if (dialogResult.confirmed) {
      setBusy(true);
      await _authenticationService.handleSignOut().then((value) {
        if (value) {
          _navigationService.navigateTo(Routes.introView);
        } else
          Fluttertoast.showToast(
              msg: "Sign Out failed ,please try again later");
      });
      setBusy(false);
      notifyListeners();
    }
  }

}
