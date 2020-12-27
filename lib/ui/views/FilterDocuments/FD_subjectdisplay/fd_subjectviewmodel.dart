import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';

class FDSubjectViewModel extends BaseViewModel {
  SubjectsService _subjectsService = locator<SubjectsService>();
  List<Subject> subjectBySemAndBr = [];

  setListOfSubBySemAndBr(String semester, String branch) {
    List<Subject> allsubs = _subjectsService.userSubjects.value +
        _subjectsService.allSubjects.value;

    for (int i = 0; i < allsubs.length; i++) {
      if (allsubs[i].branchToSem.keys.contains(branch)) {
        if (allsubs[i]
            .branchToSem[branch]
            .contains(CourseInfo.semesterToNumber[semester])) {
          subjectBySemAndBr.add(allsubs[i]);
        }
      }
    }
    notifyListeners();
  }
}
