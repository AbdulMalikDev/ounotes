import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReportViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  List<Report> _reports;

  List<Report> get reports => _reports;

  fetchReports() async {
    _reports = await _firestoreService.loadReportsFromFirebase();
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

  void accept(Report report) {
    String title = "Thank you for reporting";
    String message = "We have reviewed the document you have reported \" ${report.title} \" in the \" ${report.subjectName} \" subject and we have removed it ! Thank you again for making OU Notes a better place !";
    _analyticsService.sendNotification(id: report.reporter_id,message: message,title: title);
  }

  void deny(Report report) {
    String title = "Thank you for reporting";
    String message = "We have reviewed the document you have reported \" ${report.title} \" in the \" ${report.subjectName} \" subject and we have found NO ISSUE with it. Feel free to contact us using the feedback feature !";
    _analyticsService.sendNotification(id: report.reporter_id,message: message,title: title);
  }

  void ban(Report report) {
    String title = "We're Sorry !";
    String message = "We're sad to say that you won't be allowed to report or upload any documents. Feel free to contact us using the feedback feature !";
    _analyticsService.sendNotification(id: report.reporter_id,message: message,title: title);
  }
}
