import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';

class SubjectsDialogViewModel extends BaseViewModel {
  Logger log = getLogger("SubjectsDialogViewModel");
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  ValueNotifier<List<Subject>> get allSubjects => _subjectsService.allSubjects;

  onSubjectSelected(Subject subject) async {
    log.i("Subject added to User Subject List from Dialog");
    var result = await _subjectsService.addUserSubject(subject);
    //* while adding subject itself i have removed the subject
    //* from all subject list in subjectsService
    print(result);
    if (result is String) {
      Fluttertoast.showToast(msg: "Subject Already added");
    } else {
      Fluttertoast.showToast(
          msg: "${subject.name} added to your list of subjects...");
    }
    notifyListeners();
    // _navigationService.back();
  }

   alter() {
    User user = _authenticationService.user;
    String semester = user.semester;
    String branch = user.branch;
    log.e("user semester : $semester ${_authenticationService.user.semester}");
    log.e("user branch : $branch");

    List<Subject> filteredSubjects = [];
    //allSubjects
    //     .where((sub) =>
    //         sub.branchToSem.keys.contains(branch) &&
    //         sub.branchToSem.values.contains(semester[semester.length - 1]))
    //     .toList();
    allSubjects.value.forEach((sub) {
      if (sub.branchToSem.keys.contains(branch)) {
        if (sub.branchToSem[branch].contains(semester[semester.length - 1])) {
          filteredSubjects.add(sub);
        }
      }
    });

    for (int i = 0; i < filteredSubjects.length; i++) {
      allSubjects.value.remove(filteredSubjects[i]);
      filteredSubjects[i].userSubject = true;
      allSubjects..value.insert(i, filteredSubjects[i]);
    }

    notifyListeners();
  }
}
