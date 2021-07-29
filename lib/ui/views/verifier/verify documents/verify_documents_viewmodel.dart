import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VerifyDocumentsViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DocumentService _documentService = locator<DocumentService>();

  ValueNotifier<List<UploadLog>> _logs = new ValueNotifier(new List<UploadLog>());

  ValueNotifier<List<UploadLog>> get logs => _logs;

  bool isloading = false;

  ValueNotifier<double> get downloadProgress =>
      _documentService.downloadProgress;

  fetchUploadLogs() async {
    _logs.value = await _firestoreService.loadUploadLogFromFirebase();
    _logs.value.removeWhere((log) => log.isVerifierVerified);
    print(_logs.value.length);
  }

  @override
  Future futureToRun() => fetchUploadLogs();

  Future<String> getUploadStatus(UploadLog logItem) async {
    if (logItem.type != Constants.links) {
      var document = await _firestoreService.getDocumentById(
          logItem.subjectName,
          logItem.id,
          Constants.getDocFromConstant(logItem.type));
      return document.GDriveLink == null ? "NOT UPLOADED" : "UPLOADED";
    }
    return "None";
  }

  getNotificationStatus(UploadLog logItem) {
    return logItem.notificationSent ?? false
        ? Future.value("SENT")
        : Future.value("NOT SENT");
  }

  void view(UploadLog logItem) async{
    setBusy(true);
    setLoading(true);
    await _documentService.viewDocument(logItem);
    await Future.delayed(Duration(seconds:3));
    setLoading(false);
    setBusy(false);
  }

  void verify(UploadLog logItem, int index) async {
    var result = await _documentService.verifyDocument(logItem);
    if(result!=null){
      _logs.value[index] = result;
    }
    log.e(result);
    _logs.notifyListeners();
    notifyListeners();
  }

  void pass(UploadLog logItem, TextEditingController controller, int index) async {
    var result = await _documentService.passDocument(logItem,controller.text);
    if(result!=null){
      _logs.value[index] = result;
    }
    log.e(result);
    _logs.notifyListeners();
    notifyListeners();
  }

   setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }
}