import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked_services/stacked_services.dart';

class SubjectsDialogViewModel extends BaseViewModel {
  Logger log = getLogger("SubjectsDialogViewModel");
  DialogService _dialogService = locator<DialogService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  FirestoreService _firestoreService = locator<FirestoreService>();

  ValueNotifier<List<Subject>> get allSubjects => _subjectsService.allSubjects;

  onSubjectSelected(Subject subject) async {
    log.i("Subject added to User Subject List from Dialog");
    var result = await _subjectsService.addUserSubject(subject);
    //* while adding subject itself i have removed the subject
    //* from all subject list in subjectsService
    if (result is String) {
      Fluttertoast.showToast(msg: "Subject Already added");
    } else {
      // Fluttertoast.showToast(
      //     msg: "${subject.name} added to your list of subjects...");
    }
    notifyListeners();
    // _navigationService.back();
  }

  List<Subject> alter(List<Subject> allSubjects) {
    User user = _authenticationService.user;
    String semester = user.semester;
    String branch = user.branch;
    // log.e("user semester : $semester ${_authenticationService.user.semester}");
    // log.e("user branch : $branch");

    List<Subject> filteredSubjects = [];
    allSubjects.forEach((sub) {
      if (sub?.branchToSem?.keys?.contains(branch) ?? false) {
        if (sub.branchToSem[branch].contains(semester[semester.length - 1])) {
          filteredSubjects.add(sub);
        }
      }
    });

    for (int i = 0; i < filteredSubjects.length; i++) {
      allSubjects.remove(filteredSubjects[i]);
      filteredSubjects[i].userSubject = true;
      allSubjects.insert(i, filteredSubjects[i]);
    }

    // notifyListeners();
    return allSubjects;
  }
}