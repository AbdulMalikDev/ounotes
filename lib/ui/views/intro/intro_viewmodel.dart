import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/models/course_info.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class IntroViewModel extends BaseViewModel {
  Logger log = getLogger("IntroViewModel");
  DialogService _dialogService = locator<DialogService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofCollege;
  String _selectedSemester;
  String _selectedBranch;
  String _selectedCollege;

  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  String get clg => _selectedCollege;

  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> get dropdownofclg =>
      _dropDownMenuItemsofCollege;

  initialise() {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofCollege =
        buildAndGetDropDownMenuItems(CourseInfo.colleges);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semesters);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
    _selectedCollege = _dropDownMenuItemsofCollege[0].value;
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

  void changedDropDownItemOfCollege(String selectedCollege) {
    _selectedCollege = selectedCollege;
    notifyListeners();
  }

  handleSignUp() async {
    DialogResponse dialogResult = await _dialogService.showConfirmationDialog(
      title: "Are You Sure?",
      description:
          "Semester,Branch and College Name will be used to personalise this app",
      cancelTitle: "GO BACK",
      confirmationTitle: "PROCEED",
    );

    if (dialogResult.confirmed) {
      setBusy(true);
      await _authenticationService.handleSignIn(
        college: _selectedCollege??"",
        branch: _selectedBranch??"",
        semeseter: _selectedSemester??"",
      );
      notifyListeners();
      setBusy(false);
      _navigationService.replaceWith(Routes.splashViewRoute);
    }
  }
}
