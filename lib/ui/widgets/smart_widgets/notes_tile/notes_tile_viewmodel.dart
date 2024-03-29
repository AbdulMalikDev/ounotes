import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/notification.dart' as local;
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/recently_opened_notes_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/ui/shared/strings.dart';
import 'package:cuid/cuid.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart' as enumConstant;

class NotesTileViewModel extends BaseViewModel {
  final log = getLogger("BuildTileOfNotes");

  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  AdmobService _admobService = locator<AdmobService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  ReportsService _reportsService = locator<ReportsService>();
  DialogService _dialogService = locator<DialogService>();
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SubjectsService _subjectService = locator<SubjectsService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  RecentlyOpenedNotesService _recentlyOpenedNotesService =
      locator<RecentlyOpenedNotesService>();
  PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  bool _isnotedownloaded = false;
  bool get isnotedownloaded => _isnotedownloaded;
  AdmobService get admobService => _admobService;

  bool get isAdmin => _authenticationService.user.isAdmin;

  void reportNote(
      {String id,
      String subjectName,
      String type,
      String title,
      AbstractDocument doc}) async {
    //Collect reason of reporting from user
    SheetResponse reportResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.floating,
      title: 'What\'s wrong with this ?',
      description: 'Reason for reporting...',
      mainButtonTitle: 'Report',
      secondaryButtonTitle: 'Go Back',
    );
    if (reportResponse == null) return;
    if (!reportResponse.confirmed) {
      setBusy(false);
      return;
    }
    log.i("Report BottomSheetResponse " + reportResponse.responseData);

    // Generate report with appropriate data
    Report report = Report(
        id, subjectName, type, title, _authenticationService.user.email,
        reportReason: reportResponse.responseData);

    // Check whether user is banned
    User user = await _firestoreService.refreshUser();
    if (!user.isUserAllowedToUpload) {
      _userIsNotAllowedNotToReport();
      setBusy(false);
      return;
    }

    // If user is reporting the same document 2nd time the result will be a String
    var result = await _reportsService.addReport(report);
    if (result is String) {
      _dialogService.showDialog(
          title: "Thank you for reporting", description: result);
    } else {
      await _firestoreService.reportNote(report: report, doc: doc);
      Fluttertoast.showToast(
          msg: "Your report has been recorded. The admins will look into this.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void openDoc(Note note) async {
    await _sharedPreferencesService.updateView(note.id);
    //Add to recently opened notes
    _recentlyOpenedNotesService.addRecentlyOpenedNotes(
      recentlyOpenedNotes: RecentlyOpenedNotes(
        author: note.author,
        id: note.id,
        pages: note.pages,
        size: note.size,
        subjectName: note.subjectName,
        title: note.title,
        uploadDate: note.uploadDate,
        url: note.url,
        view: note.view,
      ),
    );
    Helper.launchURL(note.GDriveLink);
  }

  Future delete(AbstractDocument doc) async {
    var result = await _dialogService.showConfirmationDialog(
        title: "Are you sure?",
        description: "You sure you want to delete this?",
        cancelTitle: "NO",
        confirmationTitle: "YES");
    if (!result.confirmed) {
      setBusy(false);
      return;
    }
    setBusy(true);
    var response = await _cloudStorageService.deleteDocument(doc);
    setBusy(false);
    if (response is String) {
      _dialogService.showDialog(title: "Error", description: response);
    }
    Fluttertoast.showToast(
        msg: "Delete hogaya , khush? baigan...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  deleteFromGdrive(Note note) async {
    var result = await _dialogService.showConfirmationDialog(
        title: "Are you sure?",
        description: "You sure you want to delete this?",
        cancelTitle: "NO",
        confirmationTitle: "YES");
    if (!result.confirmed) {
      setBusy(false);
      return;
    }
    setBusy(true);
    var response = await _googleDriveService.deleteFile(doc: note);
    setBusy(false);
    if (response is String) {
      _dialogService.showDialog(title: "Error", description: response);
    }
    Fluttertoast.showToast(
        msg: "Delete hogaya , khush? baigan...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  navigateToEditView(Note note) {
    _navigationService.navigateTo(Routes.editView,
        arguments: EditViewArguments(
            path: Document.Notes,
            subjectName: note.subjectName,
            textFieldsMap: Constants.EditNotes,
            note: note,
            title: note.title));
  }

  void _userIsNotAllowedNotToReport() async {
    await _bottomSheetService.showBottomSheet(
      title: "Oops !",
      description:
          "You have been banned by admins for uploading irrelevant content or reporting documents with no issue again and again. Use the feedback option in the drawer to contact the admins if you think this is a mistake",
    );
  }



  void pinNotes(Note note, Function refresh) {
    //Initialize and fetch pinned notes
    Map<String, Map<String, DateTime>> pinnedNotes = {
      "empty": {"a": DateTime.now()}
    };
    if (_subjectService.documentHiveBox.get("pinnedNotes") != null) {
      Map notesMap = _subjectService.documentHiveBox.get("pinnedNotes");
      notesMap = notesMap.map((key, value) {
        if (value.isEmpty) {
          value = {"a": DateTime.now()};
        }
        pinnedNotes.addEntries([
          MapEntry<String, Map<String, DateTime>>(
              key as String, new Map<String, DateTime>.from(value))
        ]);
        return MapEntry<String, Map<String, DateTime>>(
            key as String, new Map<String, DateTime>.from(value));
      });
    }
    Map<String, DateTime> subjectPinnedNotes =
        pinnedNotes[note.subjectName] ?? {};

    //add the pinned notes
    subjectPinnedNotes[note.id.toString()] = DateTime.now();

    //save the pinned notes
    pinnedNotes.update(
      note.subjectName,
      (value) => subjectPinnedNotes,
      ifAbsent: () => subjectPinnedNotes,
    );
    _subjectService.documentHiveBox.put("pinnedNotes", pinnedNotes);

    //Notify UI
    refresh(note.subjectName);
  }

  void unpinNotes(Note note, Function refresh) {
    Map<String, Map<String, DateTime>> pinnedNotes = {
      "empty": {"a": DateTime.now()}
    };
    //Initialize and fetch pinned notes
    if (_subjectService.documentHiveBox.get("pinnedNotes") == null) return;

    Map notesMap = _subjectService.documentHiveBox.get("pinnedNotes");
    notesMap = notesMap.map((key, value) {
      if (value.isEmpty) {
        value = {"a": DateTime.now()};
      }
      pinnedNotes.addEntries([
        MapEntry<String, Map<String, DateTime>>(
            key as String, new Map<String, DateTime>.from(value))
      ]);
      return MapEntry<String, Map<String, DateTime>>(
          key as String, new Map<String, DateTime>.from(value));
    });

    Map<String, DateTime> subjectPinnedNotes = pinnedNotes[note.subjectName];
    if (subjectPinnedNotes == null || subjectPinnedNotes.isEmpty) return;

    //remove pinned notes
    subjectPinnedNotes.remove(note.id);

    //save the pinned notes
    pinnedNotes.update(
      note.subjectName,
      (value) => subjectPinnedNotes,
      ifAbsent: () => subjectPinnedNotes,
    );
    _subjectService.documentHiveBox.put("pinnedNotes", pinnedNotes);

    //notify UI for update
    refresh(note.subjectName);
  }

  thankUser(Note note) async {

    //Locally store to make sure double thanking (lol) is not possible
    String boxName = enumConstant.Constants.thankUserBox;
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    Box box = Hive.box(boxName);
    String key = "${note.subjectId}_${note.id}";
    var result = box.get(key);
    if(result != null){
      Fluttertoast.showToast(
        msg: "You have already thanked this user 😊!",
        backgroundColor: Colors.teal,
        );
      return;
    }
    box.put(key,key);

    //Create notification object and send
    String title = Strings.thank_user_notification_title;
    String body = Strings.thank_user_notification_message(note);
    String userId = note.uploader_id;
    String id = newCuid(); 
    local.Notification notification = local.Notification(id:id,heading:title,body:body,userId: userId);
    await _pushNotificationService.sendNotification(notification:notification);

  }
}
