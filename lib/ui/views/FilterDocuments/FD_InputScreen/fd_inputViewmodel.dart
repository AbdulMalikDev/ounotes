import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/course_info.dart';
import 'package:flutter/material.dart';
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

  initialise() {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semesters);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = List();
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
    initialise();
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
      Routes.fdSubjectView,
      arguments: FDSubjectViewArguments(
          sem: _selectedSemester, br: _selectedBranch, path: path),
    );
  }
}
