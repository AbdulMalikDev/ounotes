import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReportedDocumentsViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

  List<Report> _reports;

  List<Report> get reports => _reports;

  getNotificationStatus(Report report) {
    return report.notificationSent ?? false
        ? Future.value("SENT")
        : Future.value("NOT SENT");
  }

  fetchReports() async {
    _reports = await _firestoreService.loadReportsFromFirebase();
  }

  @override
  Future futureToRun() => fetchReports();
}