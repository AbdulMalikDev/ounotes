import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';

class FDSubjectViewModel extends BaseViewModel {
  SubjectsService _subjectsService = locator<SubjectsService>();
  List<Subject> subjectBySemAndBr = [];

  setListOfSubBySemAndBr(String semester, String branch) {
    List<Subject> allsubs = _subjectsService.userSubjects.value +
        _subjectsService.allSubjects.value;
    var sem = 0;
    Constants.semlist.forEach((key, value) {
      if (semester == value) {
        sem = key;
      }
    });
    for (int i = 0; i < allsubs.length; i++) {
      if (allsubs[i].semester.contains(sem) &&
          allsubs[i].branch.contains(branch)) {
        subjectBySemAndBr.add(allsubs[i]);
      }
    }
    notifyListeners();
  }
}
