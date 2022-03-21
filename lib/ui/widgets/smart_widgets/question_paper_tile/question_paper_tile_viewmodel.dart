import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';

final log = getLogger("QuestionPaperTileViewModel");

class QuestionPaperTileViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  ReportsService _reportsService = locator<ReportsService>();
  DialogService _dialogService = locator<DialogService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DocumentService _documentService = locator<DocumentService>();

  bool get isAdmin => _authenticationService.user.isAdmin;
  bool _isQPdownloaded = false;
  bool get isQPdownloaded => _isQPdownloaded;
  bool isloading = false;
  ValueNotifier<double> get downloadProgress =>
      _googleDriveService.downloadProgress;

  setLoading(bool val) {
    isloading = val;
    setBusy(val);
    notifyListeners();
  }

  void reportNote({@required AbstractDocument doc}) async {
    //Collect reason of reporting from user
    SheetResponse reportResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.floating,
      title: 'What\'s wrong with this ?',
      description: 'Reason for reporting...',
      mainButtonTitle: 'Report',
      secondaryButtonTitle: 'Go Back',
    );
    if (!reportResponse.confirmed) {
      setBusy(false);
      return;
    }
    log.i("Report BottomSheetResponse " + reportResponse.responseData);

    // Generate report with appropriate data
     Report report = Report(doc.id, doc.subjectName, doc.type, doc.title, _authenticationService.user.email,reportReason: reportResponse.responseData);

    // Check whether user is banned
    User user = await _firestoreService.refreshUser();
    if(!user.isUserAllowedToUpload){_userIsNotAllowedNotToReport(); setBusy(false);return;}

    // If user is reporting the same document 2nd time the result will be a String
    var result = await _reportsService.addReport(report);
    if (result is String) {
      _dialogService.showDialog(
          title: "Thank you for reporting", description: result);
    } else {
      // await _firestoreService.reportNote(report: report, doc: doc);
      Fluttertoast.showToast(
          msg: "Your report has been recorded. The admins will look into this.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setBusy(false);
  }

  Future delete(AbstractDocument doc) async {
    var result = await _dialogService.showConfirmationDialog(
        title: "Are you sure?",
        description: "You sure you want to delete this?",
        cancelTitle: "NO",
        confirmationTitle: "YES");
    if (!result.confirmed) {
      setBusy(false);
      return;
    }
    setBusy(true);
    var response = await _googleDriveService.deleteFile(doc: doc);
    setBusy(false);
    if (response is String) {
      _dialogService.showDialog(title: "Error", description: response);
    }
    Fluttertoast.showToast(
        msg: "Delete hogaya , khush? baigan...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  navigateToEditView(QuestionPaper note) {
    _navigationService.navigateTo(Routes.editView,
        arguments: EditViewArguments(
            path: Document.QuestionPapers,
            subjectName: note.subjectName,
            textFieldsMap: Constants.QuestionPaper,
            note: note,
            title: note.title));
  }

  download(AbstractDocument doc) async {
    setLoading(true);
    await _documentService.downloadDocument(note:doc);
    setLoading(false);
  }

  void _userIsNotAllowedNotToReport() async {
    await _bottomSheetService.showBottomSheet(
      title: "Oops !",
      description:
          "You have been banned by admins for uploading irrelevant content or reporting documents with no issue again and again. Use the feedback option in the drawer to contact the admins if you think this is a mistake",
    );
  }
}
