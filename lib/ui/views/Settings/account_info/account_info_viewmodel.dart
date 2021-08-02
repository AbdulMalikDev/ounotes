import 'dart:convert';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AccountInfoViewModel extends BaseViewModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  User _user = User();
  User get user => _user;

  Future setUser() async {
    setBusy(true);
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));
    print(user);
    _user = user;
    setBusy(false);
    notifyListeners();
  }

  changeProfileData() async {
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
