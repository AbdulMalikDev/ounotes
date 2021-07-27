import 'dart:convert';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class DefaultAppBarViewModel extends BaseViewModel {
  String _selectedSemester="";
  String _selectedBranch="";
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  String get sem => _selectedSemester;
  String get br => _selectedBranch;

  void init() async {
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));
    _selectedSemester = user.semester;
    _selectedBranch = user.branch;
  }
}