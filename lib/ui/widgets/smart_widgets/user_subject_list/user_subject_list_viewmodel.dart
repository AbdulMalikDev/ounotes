import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserSubjectListViewModel extends BaseViewModel {
  Logger log = getLogger("UserSubjectListViewModel");
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  ValueNotifier<List<Subject>> get userSubjects =>
      _subjectsService.userSubjects;
  ValueNotifier<List<Subject>> get userSelectedSubjects =>
      _subjectsService.selectedSubjects;

  void onTap(subjectName) {
    _navigationService.navigateTo(Routes.allDocumentsViewRoute,
        arguments: AllDocumentsViewArguments(subjectName: subjectName));
  }

  void updateMyItems(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Subject sub =
        await _subjectsService.removeUserSubjectAtIntex(oldIndex);
    await _subjectsService.insertUserSubject(newIndex, sub);
  }

  updateUserSelectedSubjects(Subject subject) {
    _subjectsService.updateSelectedSubject(subject);
  }

  

  void removeSubject(Subject subject) {
    log.i("Subject added to User Subject List from Dialog");
    _subjectsService.removeUserSubject(subject);
    //* while adding subject itself i have removed the subject
    //* from all subject list in subjectsService
    notifyListeners();
  }
}
