import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';

Logger log = getLogger("UploadLogDetailViewModel");

class UploadLogDetailViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  List<UploadLog> _logs;

  List<UploadLog> get logs => _logs;

  fetchUploadLogs() async {
    // _logs = await _firestoreService.loadUploadLogFromFirebase();
  }

  @override
  Future futureToRun() => fetchUploadLogs();

  deleteLogItem(UploadLog report) async {
    var dialogResult = await _dialogService.showConfirmationDialog(
        title: "Are you sure?",
        description:
            "Upload Log will be deleted. As an admin please make sure to take necessary steps",
        cancelTitle: "WAIT",
        confirmationTitle: "Apne baap ku mat sikha");
    // if(dialogResult.confirmed)await _firestoreService.deleteUploadLog(report);
  }

  viewDocument(UploadLog logItem) async {
    setBusy(true);
    NotesViewModel notesViewModel = NotesViewModel();
    //  AbstractDocument doc = await _firestoreService.getDocumentById(logItem.subjectName, logItem.id, Constants.getDocFromConstant(logItem.type));
    //  log.e(doc?.path);
    //   if (logItem.type == Constants.links)
    //   {
    //     _showLink(logItem);
    //   }else{

    //   await notesViewModel.onTap(
    //     notesName: logItem.fileName,
    //     subName: logItem.subjectName,
    //     type: logItem.type,
    //     doc: doc,
    //   );

    //   }
    //   setBusy(false);
  }

  uploadDocument(UploadLog logItem) async {
    setBusy(true);
    try {
      List<String> docsToUploadIds;
      docsToUploadIds = OnboardingService.box.get("upload_docs") ?? [];
      if (!docsToUploadIds.contains(logItem.id))
        docsToUploadIds.add(logItem.id);
      OnboardingService.box.put("upload_docs", docsToUploadIds);
      log.e(docsToUploadIds);
      Fluttertoast.showToast(msg: "Added to upload list !");
      // GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
      // dynamic doc = await _firestoreService.getDocumentById(logItem.subjectName,logItem.id,Constants.getDocFromConstant(logItem.type));
      // if(doc == null){await _dialogService.showDialog(title:"Oops",description: "Can't find this document");setBusy(false);return;}

      // if (logItem.type == Constants.links){
      //   if(doc.uploaded == true){await _dialogService.showDialog(title: "ERROR" , description: "ALREADY UPLOADED");setBusy(false);return;}
      //   doc.uploaded = true;
      //   await _firestoreService.updateDocument(doc, Document.Links);
      // }else{

      //   if(doc.GDriveLink != null){await _dialogService.showDialog(title: "ERROR" , description: "ALREADY UPLOADED");setBusy(false);return;}
      //   String result = await _googleDriveService.processFile(doc: doc, document:Constants.getDocFromConstant(logItem.type) , addToGdrive: true);
      //   _dialogService.showDialog(title: "OUTPUT" , description: result);
      // }
      // deleteLogItem(logItem);

    } catch (e) {
      _bottomSheetService.showBottomSheet(
        title: "OOPS",
        description: e.toString(),
      );
    }
    setBusy(false);
  }

  void deleteDocument(UploadLog logItem) async {
    setBusy(true);
    log.e(logItem);
    log.e(logItem.type);

    if (logItem.type == Constants.links) {
      log.e("document to be deleted is a link");
      _deleteDocument(logItem);
      setBusy(false);
      return;
    }

    // GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
    // dynamic doc = await _firestoreService.getDocumentById(logItem.subjectName,logItem.id,Constants.getDocFromConstant(logItem.type));
    // if(doc!=null)
    // {
    //   String result = await _googleDriveService.processFile(doc: doc, document:Constants.getDocFromConstant(logItem.type) , addToGdrive: false);
    //   _dialogService.showDialog(title: "OUTPUT" , description: result);
    // }
    // deleteLogItem(logItem);
    // setBusy(false);
  }

  void _showLink(UploadLog logItem) async {
    // Subject sub = _subjectsService.getSubjectByName(logItem.subjectName);
    // log.e(sub);
    // Link link = await _firestoreService.getLinkById(sub.id,logItem.id);
    // log.e(link.linkUrl);
    // _dialogService.showDialog(title: "Link Content" , description: link.linkUrl);
  }

  void _deleteDocument(UploadLog logItem) async {
    // Subject sub = _subjectsService.getSubjectByName(logItem.subjectName);
    // await _firestoreService.deleteLinkById(sub.id,logItem.id);
  }

  Future<String> getUploadStatus(UploadLog logItem) async {
    // var document = await _firestoreService.getDocumentById(logItem.subjectName,logItem.id,Constants.getDocFromConstant(logItem.type));
    // if (logItem.type != Constants.links){
    //   return document.GDriveLink==null ? "NOT UPLOADED" : "UPLOADED";
    // }else{
    //   return document.uploaded == null||document.uploaded == false ? "NOT UPLOADED" : "UPLOADED";
    // }
  }

  getNotificationStatus(UploadLog logItem) {
    notifyListeners();
    return logItem.notificationSent ?? false
        ? Future.value("SENT")
        : Future.value("NOT SENT");
  }

  // Future<User> getUser(String id)async => await _firestoreService.getUserById(id);

  // void sendNotification(UploadLog uploadLog,String title,String body,{bool isBanned=false}) async {
  //    SheetResponse result = await _bottomSheetService.showBottomSheet(title: "Sure?",description: "");
  //   if(result.confirmed){
  //     _analyticsService.sendNotification(id: uploadLog.uploader_id,message: body,title: title);
  //     uploadLog.setNotificationSent = true;
  //     _firestoreService.updateDocument(uploadLog, Document.UploadLog);
  //     if(isBanned){
  //       User user = await _sharedPreferencesService.getUser();
  //       user.banUser = true;
  //       _firestoreService.updateUserInFirebase(user);
  //     }
  //   }
  // }

  void navigateToEditScreen(UploadLog logItem) {
    _navigationService.navigateTo(
      Routes.uploadLogEditView,
      arguments: UploadLogEditViewArguments(uploadLog: logItem),
    );
  }

  //  void accept(UploadLog uploadLog) async {
  //   DialogResponse result = await _dialogService.showConfirmationDialog(title: "Sure?",description: "");
  //   if(result.confirmed){
  //     _analyticsService.sendNotification(id: uploadLog.uploader_id,message: message,title: title);
  //     uploadLog.setNotificationSent = true;
  //     _firestoreService.updateDocument(uploadLog, Document.UploadLog);
  //   }
  // }

  // void deny(UploadLog uploadLog) async {
  //   DialogResponse result = await _dialogService.showConfirmationDialog(title: "Sure?",description: "");
  //   if(result.confirmed){
  //     _analyticsService.sendNotification(id: uploadLog.uploader_id,message: message,title: title);
  //     uploadLog.setNotificationSent = true;
  //     _firestoreService.updateDocument(uploadLog, Document.UploadLog);
  //   }
  // }

  // void ban(UploadLog uploadLog) async {
  //   String title = "We're Sorry !";
  //   String message = "We're sad to say that you won't be allowed to report or upload any documents. Feel free to contact us using the feedback feature !";
  //   DialogResponse result = await _dialogService.showConfirmationDialog(title: "Sure?",description: "");
  //   if(result.confirmed){
  //     _analyticsService.sendNotification(id: uploadLog.uploader_id,message: message,title: title);
  //     uploadLog.setNotificationSent = true;
  //     _firestoreService.updateDocument(uploadLog, Document.UploadLog);
  //   User user = await _sharedPreferencesService.getUser();
  //   user.banUser = true;
  //   _firestoreService.updateUserInFirebase(user);
  // }
  // }

}
