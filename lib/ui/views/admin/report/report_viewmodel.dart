import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("UploadLogViewModel");

class ReportViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

  List<Report> _reports;

  List<Report> get reports => _reports;

  fetchReports() async {
    _reports = await _firestoreService.loadReportsFromFirebase();
  }

  @override
  Future futureToRun() => fetchReports();

  deleteReport(Report report) async {
    var dialogResult = await _dialogService.showConfirmationDialog(
        title: "Are you sure?",
        description:
            "Report will be deleted. As an admin please make sure the issue is resolved",
        cancelTitle: "WAIT",
        confirmationTitle: "OK");
    // if(dialogResult.confirmed)await _firestoreService.deleteReport(report);
  }

  void accept(Report report) async {
    String title = "Thank you for reporting";
    String message =
        "We have reviewed the document you have reported \" ${report.title} \" in the \" ${report.subjectName} \" subject and we have removed it ! Thank you again for making OU Notes a better place !";
    DialogResponse result = await _dialogService.showConfirmationDialog(
        title: "Sure?", description: "");
    if (result.confirmed) {
      _analyticsService.sendNotification(
          id: report.reporter_id, message: message, title: title);
      report.setNotificationSent = true;
      //   _firestoreService.updateDocument(report, Document.Report);
    }
  }

  void deny(Report report) async {
    String title = "Thank you for reporting";
    String message =
        "We have reviewed the document you have reported \" ${report.title} \" in the \" ${report.subjectName} \" subject and we have found NO ISSUE with it. Feel free to contact us using the feedback feature !";
    DialogResponse result = await _dialogService.showConfirmationDialog(
        title: "Sure?", description: "");
    if (result.confirmed) {
      _analyticsService.sendNotification(
          id: report.reporter_id, message: message, title: title);
      report.setNotificationSent = true;
      //  _firestoreService.updateDocument(report, Document.Report);
    }
  }

  void ban(Report report) async {
    String title = "We're Sorry !";
    String message =
        "We're sad to say that you won't be allowed to report or upload any documents. Feel free to contact us using the feedback feature !";
    DialogResponse result = await _dialogService.showConfirmationDialog(
        title: "Sure?", description: "");
    if (result.confirmed) {
      _analyticsService.sendNotification(
          id: report.reporter_id, message: message, title: title);
      report.setNotificationSent = true;
      // _firestoreService.updateDocument(report, Document.Report);
      //  User user = await _firestoreService.getUserById(report.reporter_id);
      // user.banUser = true;
      // _firestoreService.updateUserInFirebase(user,updateLocally: false);
    }
  }

  void viewDocument(Report report) async {
    setBusy(true);

    if (report.type == Constants.links) {
      _showLink(report);
    } else {
      //  var document = await _firestoreService.getDocumentById(report.subjectName,report.id, Constants.getDocFromConstant(report.type));
      //    _navigationService.navigateTo(Routes.webViewWidgetRoute,arguments: WebViewWidgetArguments(url: document.GDriveLink));

    }
    setBusy(false);
  }

  void deleteDocument(Report report) async {
    DialogResponse result = await _dialogService.showConfirmationDialog(
        title: "Sure?", description: "pakka?");
    if (result.confirmed) {
      setBusy(true);
      log.e(report);
      log.e(report.type);

      if (report.type == Constants.links) {
        log.e("document to be deleted is link type");
        _deleteDocument(report);
        setBusy(false);
        return;
      }
      GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
      dynamic doc = await _firestoreService.getDocumentById(report.subjectName,report.id,Constants.getDocFromConstant(report.type));
      String result = await _googleDriveService.deleteFile(doc:doc);
      setBusy(false);
    }
  }

  void _deleteDocument(Report report) async {
    Subject sub = _subjectsService.getSubjectByName(report.subjectName);
    NotesTileViewModel notesTileViewModel = NotesTileViewModel();
    log.e(report.type);
    if (report.type == Constants.questionPapers) {
      //   QuestionPaper questionPaper = await _firestoreService.getQuestionPaperById(sub.id,report.id);
      //    notesTileViewModel.delete(questionPaper);
    } else if (report.type == Constants.syllabus) {
      //   Syllabus syllabus = await _firestoreService.getSyllabusById(sub.id,report.id);
      //   notesTileViewModel.delete(syllabus);
    } else if (report.type == Constants.links) {
      //  Link link = await _firestoreService.deleteLinkById(sub.id,report.id);
    }
  }

  void _showLink(Report report) async {
    Subject sub = _subjectsService.getSubjectByName(report.subjectName);
      Link link = await _firestoreService.getLinkById(sub.id,report.id);
     _dialogService.showDialog(title: "Link Content" , description: link.linkUrl);
  }

  getNotificationStatus(Report report) {
    return report.notificationSent ?? false
        ? Future.value("SENT")
        : Future.value("NOT SENT");
  }
}
