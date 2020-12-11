import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/app/logger.dart';


class SyllabusTileViewModel extends BaseViewModel{
  final log = getLogger("SyllabusTileViewModel");
  FirestoreService _firestoreService = locator<FirestoreService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
  ReportsService _reportsService = locator<ReportsService>();
  DialogService _dialogService = locator<DialogService>();
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  bool get isAdmin => _authenticationService.user.isAdmin;
    bool _isSyllabusdownloaded = false;
  bool get isSyllabusdownloaded => _isSyllabusdownloaded;
  
  checkIfSyllabusIsDownloaded(List<Download> downloadedSyllabusbySub,Syllabus syllabus){
     for (int j = 0; j < downloadedSyllabusbySub.length; j++) {
      if (downloadedSyllabusbySub[j].filename == syllabus.title) {
        _isSyllabusdownloaded = true;
        notifyListeners();
      }
    }  
  }

  void reportNote({@required AbstractDocument doc}) async{
    setBusy(true);
    
    //Collect reason of reporting from user
    SheetResponse reportResponse = await _bottomSheetService.showCustomSheet(
    variant: BottomSheetType.floating,
    title: 'What\'s wrong with this ?',
    description:
        'Reason for reporting...',
    mainButtonTitle: 'Report',
    secondaryButtonTitle: 'Go Back',
    );
    log.i("Report BottomSheetResponse " + reportResponse.responseData);
    if(!reportResponse.confirmed){return;}

    //Generate report with appropriate data
    Report report = Report(doc.id, doc.subjectName, doc.type, doc.title, _authenticationService.user.email,reportReason: reportResponse.responseData);

    //Check whether user is banned
    User user = await _firestoreService.refreshUser();
    if(!user.isUserAllowedToUpload){_userIsNotAllowedNotToReport(); return;}

    //If user is reporting the same document 2nd time the result will be a String
    var result = await _reportsService.addReport(report);
    if (result is String) {
      _dialogService.showDialog(
          title: "Thank you for reporting", description: result);
    } else {
      await _firestoreService.reportNote(report: report, doc: doc);
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
    if(!result.confirmed){setBusy(false);return;}
    setBusy(true);
    var response = await _googleDriveService.deleteFile(doc: doc);
    setBusy(false);
    if(response is String){_dialogService.showDialog(title:"Error",description: response);}
    Fluttertoast.showToast(
          msg: "Delete hogaya , khush? baigan...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
    );
  }

  navigateToEditView(Syllabus note) {
    _navigationService.navigateTo(Routes.editViewRoute,arguments:EditViewArguments(path: Document.Syllabus,subjectName: note.subjectName,textFieldsMap: Constants.Syllabus,note: note,title:note.title));
  }

  void _userIsNotAllowedNotToReport() async {
    await _bottomSheetService.showBottomSheet(
      title: "Oops !",
      description: "You have been banned by admins for uploading irrelevant content or reporting documents with no issue again and again. Use the feedback option in the drawer to contact the admins if you think this is a mistake",
    );
  }

}