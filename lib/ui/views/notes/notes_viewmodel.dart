import 'dart:io';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_view.dart';
import 'package:cuid/cuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import '../../../misc/constants.dart';

class NotesViewModel extends BaseViewModel {
  Logger log = getLogger("Notes view model");
  String table = 'uservoted_subjects';
  List<Download> downloadedNotes = [];
  ValueNotifier<List<Widget>> _notesTiles = new ValueNotifier([]);
  bool _showAdminFeatures = false;

  FirestoreService _firestoreService = locator<FirestoreService>();
  AdmobService _admobService = locator<AdmobService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  NotificationService _notificationService = locator<NotificationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  DocumentService _documentService = locator<DocumentService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();

  double _progress = 0;
  bool isProMember = false;
  String newDocIDUploaded;
  double get progress => _progress;
  String _notetitle = '';
  String get notetitle => _notetitle;
  Note notificationNote;
  List<Widget> mainListOfNotes = [];
  AdmobService get admobService => _admobService;
  RemoteConfigService get remoteConfig => _remoteConfigService;
  // String get ADMOB_AD_BANNER_ID => _admobService.ADMOB_AD_BANNER_ID;
  String get ADMOB_APP_ID => _admobService.ADMOB_APP_ID;
  List<Note> _notes = [];
  ValueNotifier<List<Widget>> get notesTiles => _notesTiles;
  bool isloading = false;
  bool get loading => isloading;
  bool get showAdminFeatures => _showAdminFeatures;
  Box box;
  ValueNotifier<double> get downloadProgress =>
      _googleDriveService.downloadProgress;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  //Refresh the notes Value Notifier to show pinned notes above
  refresh(subjectName) async {
    setBusy(true);
    print("refresh");
    notesTiles.value = [];
    Map<String, Map<String, DateTime>> pinnedNotes = {
      "empty": {"a": DateTime.now()}
    };
    if (box.get("pinnedNotes") != null) {
      Map notesMap = box.get("pinnedNotes");
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
    Map<String, DateTime> subjectPinnedNotes = pinnedNotes[subjectName] ?? {};
    List<String> pinnedNotesIDs = subjectPinnedNotes.keys.toList();
    List<Note> currentSubjectPinnedNotes = [];
    for (int i = 0; i < _notes.length; i++) {
      Note note = _notes[i];
      if (note.GDriveLink == null) {
        continue;
      }
      //>Skip pinned notes to add them in the last
      if (pinnedNotesIDs.contains(note.id)) {
        currentSubjectPinnedNotes.add(note);
        continue;
      }
      //>Add normal notes to the list as usual
      else {
        _notesTiles.value.add(
          _addInkWellWidget(note),
        );
      }
    }

    //Add all the pinned notes
    if (currentSubjectPinnedNotes.isNotEmpty) {
      //>Order dates by most recently pinned
      List<DateTime> dates = subjectPinnedNotes.values.toList();
      dates.sort((a, b) => a.compareTo(b));
      dates = dates.reversed.toList();
      subjectPinnedNotes.remove("a");
      // log.e(currentSubjectPinnedNotes);
      currentSubjectPinnedNotes.asMap().forEach((index, _) {
        DateTime recentDate = dates[index];
        String notesIdCorrespondingToTheRecentDate = subjectPinnedNotes.keys
            .toList()
            .where((key) => subjectPinnedNotes[key] == recentDate)
            .toList()[0];
        Note noteToAdd = currentSubjectPinnedNotes
            .where((note) => note.id == notesIdCorrespondingToTheRecentDate)
            .toList()[0];
        _notesTiles.value.insert(
          index,
          _addInkWellWidget(noteToAdd, isPinned: true),
        );
      });
    }
    setBusy(false);
    notesTiles.notifyListeners();
  }

  List<Note> get notes => _notes;

  Future fetchNotes(String subjectName) async {
    setBusy(true);
    _notes = await _firestoreService.loadNotesFromFirebase(subjectName);
    if (_notes is String) {
      await Fluttertoast.showToast(
          msg:
              "You are facing an error in loading the notes. If you are facing this error more than once, please let us know by using the 'feedback' option in the app drawer.");
      return;
    }

    //> Populate Notes list
    bool notesForNotificationDisplay = false;
    log.e(box.get("pinnedNotes"));
    // box.delete("pinnedNotes");
    Map<String, Map<String, DateTime>> pinnedNotes = {
      "empty": {"a": DateTime.now()}
    };
    if (box.get("pinnedNotes") != null) {
      Map notesMap = box.get("pinnedNotes");
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
      // log.e(pinnedNotes);
    }
    Map<String, DateTime> subjectPinnedNotes = pinnedNotes[subjectName] ?? {};
    List<String> pinnedNotesIDs = subjectPinnedNotes.keys.toList();
    List<Note> currentSubjectPinnedNotes = [];
    for (int i = 0; i < _notes.length; i++) {
      Note note = _notes[i];
      if (note.GDriveLink == null) {
        continue;
      }

      //>To show document highlighted in notification
      if (newDocIDUploaded != null && newDocIDUploaded == note.id) {
        notesForNotificationDisplay = true;
        notificationNote = note;
        continue;
      }
      //>Skip pinned notes to add them in the last
      else if (pinnedNotesIDs.contains(note.id)) {
        currentSubjectPinnedNotes.add(note);
        continue;
      }
      //>Add normal notes to the list as usual
      else {
        _notesTiles.value.add(
          _addInkWellWidget(note),
        );
      }
    }

    //Add all the pinned notes
    if (currentSubjectPinnedNotes.isNotEmpty) {
      //>Order dates by most recently pinned
      List<DateTime> dates = subjectPinnedNotes.values.toList();
      dates.sort((a, b) => a.compareTo(b));
      dates = dates.reversed.toList();
      subjectPinnedNotes.remove("a");
      log.e(currentSubjectPinnedNotes);
      currentSubjectPinnedNotes.asMap().forEach((index, _) {
        DateTime recentDate = dates[index];
        String notesIdCorrespondingToTheRecentDate = subjectPinnedNotes.keys
            .toList()
            .where((key) => subjectPinnedNotes[key] == recentDate)
            .toList()[0];
        Note noteToAdd = currentSubjectPinnedNotes
            .where((note) => note.id == notesIdCorrespondingToTheRecentDate)
            .toList()[0];
        _notesTiles.value.insert(
          index,
          _addInkWellWidget(noteToAdd, isPinned: true),
        );
      });
    }

    //> Adding this in the start so that it doesn't mess up the pinned notes
    if (notesForNotificationDisplay) {
      _notesTiles.value.insert(
        0,
        _addInkWellWidget(notificationNote, notification: true),
      );
    }
    setBusy(false);
    notifyListeners();
  }

  void openDoc(Note note) async {
    _sharedPreferencesService.updateView(note.id);
    User user = await _authenticationService.getUser();
    //TODO show ad
    // if (_admobService.adDue && !user.isPremiumUser ??
    //     false || _admobService.shouldAdBeShown()) {
    //   _navigationService.navigateTo(Routes.watchAdToContinueView);
    //   return;
    // }

    //Check if used already saved his choice of actions
    SharedPreferences prefs = await _sharedPreferencesService.store();
    if (prefs.containsKey("openDocChoice")) {
      String button = prefs.getString("openDocChoice");
      if (button == Constants.downloadAndOpenInApp) {
        navigateToPDFView(note);
      } else {
        _sharedPreferencesService.updateView(note.id);
        Helper.launchURL(note.GDriveLink);
      }
      return;
    }

    //Ask user to select his choice, whether to open in browser or app
    SheetResponse response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.floating2,
      title: 'Where do you want to open the file?',
      description: "",
      mainButtonTitle: 'Open In Browser',
      secondaryButtonTitle: "Download & Open In App",
    );
    log.i("openDoc BottomSheetResponse ");
    if (response == null) return;
    if (!response.confirmed ?? false) {
      return;
    }

    //if he clicked the checkbox to remember his choice the save the changes locally
    if (response.data['checkBox']) {
      prefs.setString(
        "openDocChoice",
        response.data['buttonText'],
      );

      SheetResponse response2 = await _bottomSheetService.showBottomSheet(
        title: "Settings Saved !",
        description: "You can change this anytime in settings screen.",
      );

      //navigate to the selected screen choice either to browser or inapp pdf viewer
      if (response2.confirmed) {
        navigateToPDFScreen(response.data['buttonText'], note);
        return;
      }
    } else {
      navigateToPDFScreen(response.data['buttonText'], note);
    }
    return;
  }

  onShowAdminFeature(bool val) {
    _showAdminFeatures = val;
    notifyListeners();
  }

  navigateToPDFScreen(String buttonText, Note note) {
    if (buttonText == 'Open In App') {
      navigateToPDFView(note);
    } else {
      _sharedPreferencesService.updateView(note.id);
      Helper.launchURL(note.GDriveLink);
    }
  }

  void navigateToPDFView(Note note) async {
    try {
      _googleDriveService.downloadPuchasedPdf(
        note: note,
        startDownload: () {
          setLoading(true);
        },
        onDownloadedCallback: (path, _) {
          setLoading(false);
          _navigationService.navigateTo(Routes.pDFScreen,
              arguments: PDFScreenArguments(
                  pathPDF: path, doc: note, isUploadingDoc: false));
        },
      );
    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(
          msg: "An error Occurred while downloading pdf..." +
              "Please check you internet connection and try again later");
      return;
    }
  }

  void navigateBack() {
    _navigationService.popRepeated(1);
  }

  // void incrementViewForAd() async {
  //   User user = await _authenticationService.getUser();
  //   if (!(_admobService.adDue && !user.isPremiumUser ??
  //       false || _admobService.shouldAdBeShown()))
  //     this.admobService.incrementNumberOfTimeNotesOpened();
  //   this.admobService.shouldAdBeShown();
  // }

  List<Subject> getSimilarSubjects(String subjectName) {
    return _subjectsService.getSimilarSubjects(subjectName);
  }

  //download doc on tap
  onTap({
    String notesName,
    String subName,
    String type,
    AbstractDocument doc,
  }) async {
    _progress = 0;
    notifyListeners();
    setLoading(true);
    File file = await downloadFile(
      notesName: notesName,
      subName: subName,
      type: type,
      doc: doc,
    );
    String PDFpath = file.path;
    log.e(file.path);
    if (PDFpath == 'error') {
      await Fluttertoast.showToast(
          msg:
              'An error has occurred while downloading document...Please Verify your internet connection.');
      setLoading(false);
      return;
    }
    setLoading(false);
    _navigationService.navigateTo(Routes.pDFScreen,
        arguments: PDFScreenArguments(pathPDF: PDFpath, isUploadingDoc: false));
  }

  downloadFile({
    String notesName,
    String subName,
    String type,
    String id,
    AbstractDocument doc,
  }) async {
    log.i("notesName : $notesName");
    log.i("Subject Name : $subName");
    log.i("Type : $type");
    try {
      String fileUrl =
          "https://storage.googleapis.com/ou-notes.appspot.com/pdfs/$subName/$type/$notesName";
      if (doc != null) fileUrl = doc.url;
      log.e(doc.url);
      log.i(Uri.parse(fileUrl));
      var request = await HttpClient().getUrl(Uri.parse(fileUrl));
      var response = await request.close();
      log.w("downloading");
      var bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (bytesReceived, expectedContentLength) {
          if (expectedContentLength != null) {
            _progress = (bytesReceived / expectedContentLength * 100);
            print(_progress);
            notifyListeners();
          }
        },
      );
      String dir = (await getApplicationDocumentsDirectory()).path;
      String id = newCuid();
      File file = new File('$dir/$id.pdf');
      file = await file.writeAsBytes(bytes);
      log.i("file path: ${file.path}");
      String mimeStr = lookupMimeType(file.path);
      log.e(file.uri);
      return file;
    } catch (e) {
      log.e("While retreiving Notes from Firebase STORAGE , Error occurred");
      String error;
      if (e is PlatformException) error = e.message;
      error = e.toString();
      log.e(error);
      return "error";
    }
  }

  Widget _addInkWellWidget(Note note,
      {bool notification = false, bool isPinned = false}) {
    return InkWell(
      child: NotesTileView(
        note: note,
        notification: notification,
        isPinned: isPinned,
        refresh: refresh,
        onDownloadCallback: handleDownload,
        onTap: () async {
          await incrementViewForAd();
          openDoc(note);
        },
      ),
      onTap: () async {
        await incrementViewForAd();
        openDoc(note);
      },
    );
  }

  void incrementViewForAd() {
    this.admobService.incrementNumberOfTimeNotesOpened();
    // this.admobService.shouldAdBeShown();
  }

  initialize() async {
    box = await Hive.openBox("Documents");
    _subjectsService.setBox(box);
  }

  void handleDownload({Note note}) async {
    await _documentService.downloadDocument(note: note,author: note.author,setLoading: setLoading);
  }
}
