import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UploadSelectionViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  String _subjectName;

  set subjectName(String name) {
    _subjectName = name;
  }

  navigateToNotes() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Notes,
          path: Document.Notes,
          subjectName: _subjectName,
        ));
  }

  navigateToQuestionPapers() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.QuestionPaper,
          path: Document.QuestionPapers,
          subjectName: _subjectName,
        ));
  }

  navigateToSyllabus() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Syllabus,
          path: Document.Syllabus,
          subjectName: _subjectName,
        ));
  }

  navigateToLinks() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Links,
          path: Document.Links,
          subjectName: _subjectName,
        ));
  }

  navigateToGDRIVELinks() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.GDRIVELink,
          path: Document.GDRIVE,
          subjectName: _subjectName,
        ));
  }
}
