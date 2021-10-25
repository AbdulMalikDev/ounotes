import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
Logger log = getLogger("ReportedDocumentsViewModel");

class ReportedDocumentsViewModel extends FutureViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  DialogService _dialogService = locator<DialogService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  DocumentService _documentService = locator<DocumentService>();

  ValueNotifier<List<Report>> _reports = new ValueNotifier(new List<Report>());

  ValueNotifier<List<Report>> get reports => _reports;

  bool isloading = false;

  ValueNotifier<double> get downloadProgress =>
      _documentService.downloadProgress;

  getNotificationStatus(Report report) {
    return report.notificationSent ?? false
        ? Future.value("SENT")
        : Future.value("NOT SENT");
  }

  fetchReports() async {
    setBusy(true);
    _reports.value = await _firestoreService.loadReportsFromFirebase();
    setBusy(false);
  }

  @override
  Future futureToRun() => fetchReports();

  void view(Report report) async {
    setBusy(true);
    setLoading(true);
    UploadLog uploadlog = UploadLog.fromReport(report);
    log.e(uploadlog.subjectName);
    await _documentService.viewDocument(uploadlog,viewInBrowser: true);
    await Future.delayed(Duration(seconds:3));
    setLoading(false);
    setBusy(false);
  }

  void delete(Report report, int index) async {
    var result = await _documentService.deleteDocumentForVerifier(UploadLog.fromReport(report));
    _removeReportFromList(result, index);
  }

  void pass(Report report, int index, TextEditingController controller) async {
    UploadLog logItem = UploadLog.fromReport(report);
    logItem.isPassed = true;
    var result = await _documentService.passDocument(logItem, controller.text);
    _removeReportFromList(result, index);
  }

  Future<void> uselessReport(Report report, int index) async {
    var result = await _documentService.deleteReport(report);
    _removeReportFromList(result, index);
  }

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }


  _removeReportFromList(result,index) {
    if (result!=null){
      _reports.value.removeAt(index);
    }
    _reports.notifyListeners();
    notifyListeners();
  }

}