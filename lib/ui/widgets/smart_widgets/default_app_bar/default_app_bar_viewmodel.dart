import 'dart:convert';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DefaultAppBarViewModel extends BaseViewModel {
  String _selectedSemester = "";
  String _selectedBranch = "";
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  NavigationService _navigationService = locator<NavigationService>();
  String get sem => _selectedSemester;
  String get br => _selectedBranch;

  void init() async {
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));
    _selectedSemester = user.semester;
    _selectedBranch = user.branch;
  }

  navigateToUserUploadScreen() {
    _navigationService.navigateTo(
      Routes.uploadSelectionView,
      arguments: UploadSelectionViewArguments(),
    );
  }
}
