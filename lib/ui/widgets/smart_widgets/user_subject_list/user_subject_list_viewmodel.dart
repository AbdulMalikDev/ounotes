import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserSubjectListViewModel extends BaseViewModel{
  Logger log = getLogger("UserSubjectListViewModel");
  DialogService _dialogService = locator<DialogService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  ValueNotifier<List<Subject>> get userSubjects => _subjectsService.userSubjects;

  void onTap(subjectName) {
    _navigationService.navigateTo(Routes.allDocumentsViewRoute,arguments: AllDocumentsViewArguments(subjectName: subjectName));
  }

  void removeSubject(Subject subject) {
        
              //TODO [sub already added] logic to be added
              log.i("Subject added to User Subject List from Dialog");
               _subjectsService.removeUserSubject(subject);
              //* while adding subject itself i have removed the subject
              //* from all subject list in subjectsService
              notifyListeners(); 
  }


  

}