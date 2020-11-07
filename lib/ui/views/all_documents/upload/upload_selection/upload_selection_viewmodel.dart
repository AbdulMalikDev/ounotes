import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UploadSelectionViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  String _subjectName;
  Document _path;

  set subjectName(String name) {
    _subjectName = name;
  }

  set path(Document path) {
    _path = path;
  }

  navigateToNotes() {
    _navigationService.navigateTo(Routes.uploadViewRoute,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Notes,
          path: Document.Notes,
          subjectName: _subjectName,
          path2: _path,
        ));
  }

  navigateToQuestionPapers() {
    _navigationService.navigateTo(Routes.uploadViewRoute,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.QuestionPaper,
          path: Document.QuestionPapers,
          subjectName: _subjectName,
          path2: _path,
        ));
  }

  navigateToSyllabus() {
    _navigationService.navigateTo(Routes.uploadViewRoute,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Syllabus,
          path: Document.Syllabus,
          subjectName: _subjectName,
          path2: _path,
        ));
  }

  navigateToLinks() {
    _navigationService.navigateTo(Routes.uploadViewRoute,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Links,
          path: Document.Links,
          subjectName: _subjectName,
          path2: _path,
        ));
  }
}
