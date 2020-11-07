import 'dart:convert';

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';

class ProfileViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  User _user;
  User get user => _user;

  setUser() async {
    setBusy(true);
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(json.decode(prefs.getString("current_user")));
    _user = user;
    setBusy(false);
    notifyListeners();
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
          _navigationService.navigateTo(Routes.introViewRoute);
        } else
          Fluttertoast.showToast(
              msg: "Sign Out failed ,please try again later");
      });
      setBusy(false);
      notifyListeners();
    }
  }
}
