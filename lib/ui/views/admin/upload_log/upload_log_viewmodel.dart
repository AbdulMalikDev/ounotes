import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("UploadLogViewModel");

class UploadLogViewModel extends FutureViewModel{
 FirestoreService _firestoreService = locator<FirestoreService>();
 NavigationService _navigationService = locator<NavigationService>();

  List<UploadLog> _logs;

  List<UploadLog> get logs => _logs;

  fetchUploadLogs() async {
    _logs = await _firestoreService.loadUploadLogFromFirebase();
  }

  @override
  Future futureToRun() => fetchUploadLogs();

  navigateToUploadLogDetailView(UploadLog uploadLog) async {
    _navigationService.navigateTo(Routes.uploadLogDetailViewRoute,arguments: UploadLogDetailViewArguments(logItem: uploadLog));
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
}
