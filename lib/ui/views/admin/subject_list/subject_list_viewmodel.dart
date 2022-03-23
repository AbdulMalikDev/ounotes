import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AdminSubjectListViewModel extends BaseViewModel {

  SubjectsService _subjectsService = locator<SubjectsService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();

  List<Subject> get allSubjects => _subjectsService.allSubjects.value;

  deleteSubject(Subject subject) async {
    //Double check user intent
    SheetResponse response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.filledStacks,
        title: "Sure you want to delete ${subject.name}?",
        description:
            "Warning this will delete all Notes,QPapers and syllabi having subject name that was entered",
        mainButtonTitle: "ok",
        secondaryButtonTitle: "no");
    if (response == null || !response.confirmed) {
      return false;
    }
    
    //Initiate deletion
    bool result = await _subjectsService.removeSubject(subject);
    await _bottomSheetService.showBottomSheet(title: "Subject Delete Output : ${result.toString()}");
  }

  void refreshSubjects() async {
    await _subjectsService.loadSubjects(updateSubjects: true);
    await _bottomSheetService.showBottomSheet(title: "Subjects Refreshed. Go back and load this page again");
    _navigationService.popRepeated(1);
  }
}
