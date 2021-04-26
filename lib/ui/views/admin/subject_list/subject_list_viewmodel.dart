import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';

class AdminSubjectListViewModel extends BaseViewModel {
  SubjectsService _subjectsService = locator<SubjectsService>();
  List<Subject> get allSubjects => _subjectsService.allSubjects.value;
  FirestoreService _firestoreService = locator<FirestoreService>();

  deleteSubject(int id) {
  //  _firestoreService.deleteSubjectById(id);
  }
}
