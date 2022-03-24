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
          uploadType: Document.Notes,
          subjectName: _subjectName,
        ));
  }

  navigateToQuestionPapers() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.QuestionPaper,
          uploadType: Document.QuestionPapers,
          subjectName: _subjectName,
        ));
  }

  navigateToSyllabus() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Syllabus,
          uploadType: Document.Syllabus,
          subjectName: _subjectName,
        ));
  }

  navigateToLinks() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.Links,
          uploadType: Document.Links,
          subjectName: _subjectName,
        ));
  }

  navigateToGDRIVELinks() {
    _navigationService.navigateTo(Routes.uploadView,
        arguments: UploadViewArguments(
          textFieldsMap: Constants.GDRIVELink,
          uploadType: Document.GDRIVE,
          subjectName: _subjectName,
        ));
  }
}
