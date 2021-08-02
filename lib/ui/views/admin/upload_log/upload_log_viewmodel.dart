import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("UploadLogViewModel");

class UploadLogViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DocumentService _documentService = locator<DocumentService>();

  List<UploadLog> _logs;

  List<UploadLog> get logs => _logs;

  fetchUploadLogs() async {
    _logs = await _firestoreService.loadUploadLogFromFirebase(isAdmin: true);
  }

  @override
  Future futureToRun() => fetchUploadLogs();

  navigateToUploadLogDetailView(UploadLog uploadLog) async {
    _navigationService.navigateTo(Routes.uploadLogDetailView,
        arguments: UploadLogDetailViewArguments(logItem: uploadLog));
  }

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

  processDocument(UploadLog logItem) async {
    if(logItem.isReport){
      deleteDocument(logItem);
    }else{
      uploadDocument(logItem);
    }
  }

  deleteDocument(UploadLog logItem) async {
    setBusy(true);
    var result = await _documentService.deleteDocument(logItem);
    deleteLogItem(logItem);
    setBusy(false);
  }

  uploadDocument(UploadLog logItem) async {
    setBusy(true);
    try {
      var result = await _documentService.uploadDocument(logItem);
      deleteLogItem(logItem);

    } catch (e) {
      _bottomSheetService.showBottomSheet(
        title: "OOPS",
        description: e.toString(),
      );
    }
    List<String> docsToUploadIds;
    docsToUploadIds = OnboardingService.box.get("upload_docs") ?? [];
    docsToUploadIds?.remove(logItem.id);
    OnboardingService.box.put("upload_docs", docsToUploadIds);
    setBusy(false);
  }

  deleteLogItem(UploadLog report) async {
    await _firestoreService.deleteUploadLog(report);
  }

  uploadSelectedDocuments() async {
    List<UploadLog> uploadLogs = [];
    List<String> docsToUploadIds;
    docsToUploadIds = OnboardingService.box.get("upload_docs") ?? [];

    for (String id in docsToUploadIds) {
      var log = _logs.where((log) => log.id == id)?.toList();
      if (log == null || log.isEmpty) continue;
      uploadLogs.add(log[0]);
    }

    for (UploadLog log in (uploadLogs ?? [])) {
      await this.processDocument(log);
    }
  }

  uploadAllDocuments() async {
    for (UploadLog log in _logs) {
      await this.processDocument(log);
    }
  }
}
