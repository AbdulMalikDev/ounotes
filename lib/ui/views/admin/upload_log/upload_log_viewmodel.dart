import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
Logger log = getLogger("UploadLogViewModel");

class UploadLogViewModel extends FutureViewModel{
 FirestoreService _firestoreService = locator<FirestoreService>();
 DialogService _dialogService = locator<DialogService>();
 BottomSheetService _bottomSheetService = locator<BottomSheetService>();
 NavigationService _navigationService = locator<NavigationService>();
 AuthenticationService _authenticationService = locator<AuthenticationService>();
 AnalyticsService _analyticsService = locator<AnalyticsService>();
 SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
 SubjectsService _subjectsService = locator<SubjectsService>();
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
    if (logItem.type != Constants.links){
      var document = await _firestoreService.getDocumentById(logItem.subjectName,logItem.id,Constants.getDocFromConstant(logItem.type));
      return document.GDriveLink==null ? "NOT UPLOADED" : "UPLOADED";
    } 
    return "None";
  }
  
  getNotificationStatus(UploadLog logItem) {
    return logItem.notificationSent??false ? Future.value("SENT") : Future.value("NOT SENT");
  }
}
