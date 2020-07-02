import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReportViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();

  List<Report> _reports;

  List<Report> get reports => _reports;

  fetchReports() async {
    _reports = await _firestoreService.loadReportsFromFirebase();
    print("~~~~~~~~~~~~~~~~~~~~~~~~");
    print(_reports);
  }

  @override
  Future futureToRun() => fetchReports();

  deleteReport(Report report) async {
    var dialogResult = await _dialogService.showConfirmationDialog(
      title: "Are you sure?",
      description:
          "Report will be deleted. As an admin please make sure the issue is resolved",
      cancelTitle: "WAIT",
      confirmationTitle: "OK"
    );
    if(dialogResult.confirmed)await _firestoreService.deleteReport(report);
  }
}
