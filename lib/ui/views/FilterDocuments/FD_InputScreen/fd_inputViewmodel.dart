import 'dart:convert';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FDInputViewModel extends BaseViewModel {
  String titleOfNotes =
      "We are committed to bring you the best Notes of each and every subject.\nGo explore!";
  String titleOfQuestions =
      "Are you confused with the syllabus?\ncheck out previous year question papers!";
  String titleOfSyllabus =
      "Are you confused with the chapters to study?check out Syllabus!";
  String titleOfLinks =
      "Are you confused with where to study from?check out links!";
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  String _title;
  String get title => _title;

  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  String _selectedSemester;
  String _selectedBranch;

  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;

  init() async {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semesters);
    setBusy(true);
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));
    _selectedSemester = user.semester;
    _selectedBranch = user.branch;
    setBusy(false);
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = [];
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Text(item)));
    });
    return i;
  }

  void changedDropDownItemOfSemester(String selectedSemester) {
    _selectedSemester = selectedSemester;
    notifyListeners();
  }

  void changedDropDownItemOfBranch(String selectedBranch) {
    _selectedBranch = selectedBranch;
    notifyListeners();
  }

  setTitleAccordingtoPath(Document path) {
    init();
    if (path == Document.Notes) {
      _title = titleOfNotes;
    } else if (path == Document.QuestionPapers) {
      _title = titleOfQuestions;
    } else if (path == Document.Syllabus) {
      _title = titleOfSyllabus;
    } else {
      _title = titleOfLinks;
    }
    notifyListeners();
  }

  onTap(Document path) {
    _navigationService.navigateTo(
      Routes.fDSubjectView,
      arguments: FDSubjectViewArguments(
          sem: _selectedSemester, br: _selectedBranch, path: path),
    );
  }
}
