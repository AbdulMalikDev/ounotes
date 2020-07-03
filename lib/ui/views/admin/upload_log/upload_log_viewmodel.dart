import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UploadLogViewModel extends FutureViewModel{
 FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();

  List<UploadLog> _logs;

  List<UploadLog> get logs => _logs;

  fetchUploadLogs() async {
    _logs = await _firestoreService.loadUploadLogFromFirebase();
  }

  @override
  Future futureToRun() => fetchUploadLogs();

  deleteLogItem(UploadLog report) async {
    var dialogResult = await _dialogService.showConfirmationDialog(
      title: "Are you sure?",
      description:
          "Upload Log will be deleted. As an admin please make sure to take necessary steps",
      cancelTitle: "WAIT",
      confirmationTitle: "Apne baap ku mat sikha"
    );
    if(dialogResult.confirmed)await _firestoreService.deleteUploadLog(report);
  }
}
