import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VerifyDocumentsViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<UploadLog> _logs;

  List<UploadLog> get logs => _logs;

  fetchUploadLogs() async {
    _logs = await _firestoreService.loadUploadLogFromFirebase();
    print(_logs.length);
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
}