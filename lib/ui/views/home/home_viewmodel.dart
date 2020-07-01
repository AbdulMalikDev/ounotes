import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

  ValueNotifier<List<Subject>> get userSubjects =>
      _subjectsService.userSubjects;

  showIntroDialog() async {
    if (_subjectsService.userSubjects.value.length == 0) {
      await Future.delayed(Duration(seconds: 1));
      await _dialogService.showDialog(
        title: "Welcome to OU Notes App",
        description:
            "Please use \"+\" button to add subjects and swipe left or right to delete them",
        buttonTitle: 'Ok'
        
      );
    }
  }
}
