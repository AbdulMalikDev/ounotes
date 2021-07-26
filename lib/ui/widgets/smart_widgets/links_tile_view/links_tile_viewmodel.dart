import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';

final log = getLogger("LinksTileViewModel");

class LinksTileViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  ReportsService _reportsService = locator<ReportsService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  //bool get isAdmin => _authenticationService.user.isAdmin;

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
      return;
    }
    log.i("Report BottomSheetResponse " + reportResponse.responseData);

    //Generate report with appropriate data
    // Report report = Report(doc.id, doc.subjectName, doc.type, doc.title, _authenticationService.user.email,reportReason: reportResponse.responseData);

    //Check whether user is banned
    //TODO deprecated
    // User user = await _firestoreService.refreshUser();
    // if(!user.isUserAllowedToUpload){_userIsNotAllowedNotToReport();return;}

    //If user is reporting the same document 2nd time the result will be a String
    // var result = await _reportsService.addReport(report);
    // if (result is String) {
    //   _dialogService.showDialog(
    //       title: "Thank you for reporting", description: result);
    // } else {
    //   // await _firestoreService.reportNote(report: report, doc: doc);
    //   Fluttertoast.showToast(
    //       msg: "Your report has been recorded. The admins will look into this.",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.teal,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
  }

  openLink(String url) async {
    var dialogResult = await _dialogService.showConfirmationDialog(
        title: "Confirmation",
        description: "Are you sure you want to open this link? $url",
        cancelTitle: "NO",
        confirmationTitle: "YES");
    if (!dialogResult.confirmed) {
      return;
    } else {
      launchURL(url);
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
    // var response = await _firestoreService.deleteDocument(doc);
    setBusy(false);
    // if (response is String) {
    //   _dialogService.showDialog(title: "Error", description: response);
    // }
    Fluttertoast.showToast(
        msg: "Delete hogaya , khush? baigan...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  navigateToEditView(Link note) {
    _navigationService.navigateTo(Routes.editView,
        arguments: EditViewArguments(
            path: Document.Links,
            subjectName: note.subjectName,
            textFieldsMap: Constants.Links,
            note: note,
            title: note.title));
  }

  void _userIsNotAllowedNotToReport() async {
    await _bottomSheetService.showBottomSheet(
      title: "Oops !",
      description:
          "You have been banned by admins for uploading irrelevant content or reporting documents with no issue again and again. Use the feedback option in the drawer to contact the admins if you think this is a mistake",
    );
  }
}
