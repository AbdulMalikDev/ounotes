import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserSubjectListViewModel extends BaseViewModel {
  Logger log = getLogger("UserSubjectListViewModel");
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  AdmobService _admobService = locator<AdmobService>();
  
  ValueNotifier<List<Subject>> get userSubjects =>
      _subjectsService.userSubjects;
  ValueNotifier<List<Subject>> get userSelectedSubjects =>
      _subjectsService.selectedSubjects;

  void onTap(subjectName) async {
    log.i("Subject name pressed");
    try{
      await _admobService.showAd();
      // _admobService.incrementNumberOfTimeNotesOpened();
    }catch(e){}
    _navigationService.navigateTo(Routes.allDocumentsView,
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
