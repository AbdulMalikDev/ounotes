import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';

class AdminSubjectListViewModel extends BaseViewModel {
  SubjectsService _subjectsService = locator<SubjectsService>();
  List<Subject> get allSubjects => _subjectsService.allSubjects.value;
}
