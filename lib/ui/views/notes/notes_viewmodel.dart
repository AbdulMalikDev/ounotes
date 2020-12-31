import 'dart:convert';
import 'dart:io';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_view.dart';
import 'package:cuid/cuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class NotesViewModel extends BaseViewModel {
  Logger log = getLogger("Notes view model");
  String table = 'uservoted_subjects';
  List<Vote> userVotedNotesList = [];
  List<Download> downloadedNotes = [];
  ValueNotifier<List<Widget>> _notesTiles =
      new ValueNotifier(new List<Widget>());

  FirestoreService _firestoreService = locator<FirestoreService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>(); 
  AdmobService _admobService = locator<AdmobService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  DownloadService _downloadService = locator<DownloadService>();
  VoteService _voteService = locator<VoteService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  double _progress = 0;

  String newDocIDUploaded;
  double get progress => _progress;
  String _notetitle = '';
  String get notetitle => _notetitle;
  bool _ischecked = false;
  Note notificationNote;
  List<Widget> mainListOfNotes = [];
  List<Vote> get voteslist => userVotedNotesList;
  AdmobService get admobService => _admobService;
  RemoteConfigService get remoteConfig => _remoteConfigService;
  String get ADMOB_AD_BANNER_ID => _admobService.ADMOB_AD_BANNER_ID;
  String get ADMOB_APP_ID => _admobService.ADMOB_APP_ID;
  List<Note> _notes = [];
  ValueNotifier<List<Widget>> get notesTiles => _notesTiles;
  bool isloading = false;
  bool get loading => isloading;
  Box box;
  ValueNotifier<List<Vote>> get userVotesBySub => _voteService.votesBySub;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  //Refresh the notes Value Notifier to show pinned notes above
  refresh(subjectName) async {
    notesTiles.value = [];
    await fetchNotesAndVotes(subjectName);
  }

  List<Note> get notes => _notes;
  // _notes.addListener(() { })

  Future fetchNotesAndVotes(String subjectName) async {
    setBusy(true);
    _notes = await _firestoreService.loadNotesFromFirebase(subjectName);
    if (_notes is String) {
      await Fluttertoast.showToast(
          msg:
              "You are facing an error in loading the notes. If you are facing this error more than once, please let us know by using the 'feedback' option in the app drawer.");
      return;
    }
    await _voteService.fetchAndSetVotesBySubject(subjectName);
    // await _downloadService.fetchAndSetDownloads();
    userVotedNotesList = _voteService.userVotesList;

    //> Populate Notes list
    bool notesForNotificationDisplay = false;
    log.e(box.get("pinnedNotes"));
    // box.delete("pinnedNotes");
    Map<String, Map<String, DateTime>> pinnedNotes = {"empty": {"a": DateTime.now()}};
    if(box.get("pinnedNotes") != null){
      Map notesMap = box.get("pinnedNotes");
      notesMap = notesMap.map((key, value) {
        if(value.isEmpty){value = {"a": DateTime.now()};}
        pinnedNotes.addEntries([MapEntry<String,Map<String, DateTime>>(key as String, new Map<String,DateTime>.from(value))]);
        return MapEntry<String,Map<String, DateTime>>(key as String, new Map<String,DateTime>.from(value));
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

    //> Adding this in the end so that it doesn't mess up the pinned notes
    if (notesForNotificationDisplay) {
      _notesTiles.value.insert(
        0,
        _addInkWellWidget(notificationNote, notification: true),
      );
    }
    setBusy(false);
    notifyListeners();
  }

  getListOfNotesInDownloads(String subName) {
    // List<Download> allDownloads = _downloadService.downloadlist;
    List<Download> downloadsbysub = [];
    // allDownloads.forEach((download) {
    //   if (download.type == Constants.notes &&
    //       download.subjectName.toLowerCase() == subName.toLowerCase()) {
    //     downloadsbysub.add(download);
    //   }
    // });
    return downloadsbysub;
  }

  // String filePath;
  // Future<bool> checkNoteInDownloads(Note note) async {
  //   await _downloadService.fetchAndSetDownloads();
  //   List<Download> allDownloads = _downloadService.downloadlist;
  //   allDownloads.forEach((download) {
  //     if (download.type == Constants.notes) {
  //       downloadedNotes.add(download);
  //     }
  //   });
  //   for (int i = 0; i < downloadedNotes.length; i++) {
  //     if (downloadedNotes[i].filename == note.title &&
  //         downloadedNotes[i].subjectName == note.subjectName) {
  //       filePath = downloadedNotes[i].path;
  //       notifyListeners();
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  void openDoc(Note note) async {
    SharedPreferences prefs = await _sharedPreferencesService.store();
    if (prefs.containsKey("openDocChoice")) {
      String button = prefs.getString("openDocChoice");
      if (button == "Open In App") {
        navigateToWebView(note);
      } else {
        _sharedPreferencesService.updateView(note.id);
        Helper.launchURL(note.GDriveLink);
      }
      return;
    }

    SheetResponse response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.floating2,
      title: 'Where do you want to open the file?',
      description:
          "Tip : Open Notes in Google Drive app to avoid loading issues. ' Open in Browser > Google Drive Icon ' ",
      mainButtonTitle: 'Open In Browser',
      secondaryButtonTitle: 'Open In App',
    );
    log.i("openDoc BottomSheetResponse ");
    if(response == null)return;
    if (!response.confirmed ?? false) {
      return;
    }

    if (response.responseData['checkBox']) {
      prefs.setString(
        "openDocChoice",
        response.responseData['buttonText'],
      );

      SheetResponse response2 = await _bottomSheetService.showBottomSheet(
        title: "Settings Saved !",
        description:
            "You can change this setting in the profile screen anytime.",
      );

      if (response2.confirmed) {
        navigateToPDFScreen(response.responseData['buttonText'], note);
        return;
      }
    } else {
      navigateToPDFScreen(response.responseData['buttonText'], note);
    }

    return;
  }

  navigateToPDFScreen(String buttonText, Note note) {
    if (buttonText == 'Open In App') {
      navigateToWebView(note);
    } else {
      _sharedPreferencesService.updateView(note.id);
      Helper.launchURL(note.GDriveLink);
    }
  }

  void navigateToWebView(Note note) {
    _googleDriveService.downloadFile(note: note, onDownloadedCallback: (path,note){
          _navigationService.navigateTo(Routes.pdfScreenRoute,arguments: PDFScreenArguments(pathPDF: path,doc: note));
        });
  }

  void navigateBack() {
    _navigationService.popRepeated(1);
  }

  @override
  void dispose() {
    this.admobService.hideNotesViewBanner();
    this.admobService.hideNotesViewInterstitialAd();
    super.dispose();
  }

  void incrementViewForAd() {
    this.admobService.incrementNumberOfTimeNotesOpened();
    if (this.admobService.shouldAdBeShown()) {
      this.admobService.showNotesViewInterstitialAd();
    }
  }

  List<Subject> getSimilarSubjects(String subjectName) {
    return _subjectsService.getSimilarSubjects(subjectName);
  }

   //download doc on tap
  void onTap({
    String notesName,
    String subName,
    String type,
  }) async {
    _progress = 0;
    notifyListeners();
    setLoading(true);
    File file = await downloadFile(
      notesName: notesName,
      subName: subName,
      type: type,
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
    // _firestoreService.incrementView(note);
    setLoading(false);
    _navigationService.navigateTo(Routes.pdfScreenRoute,
        arguments: PDFScreenArguments(pathPDF: PDFpath));
  }

  @override
  // Future futureToRun() =>fetchNotes();

  // old download logic for firebase
  downloadFile({
    String notesName,
    String subName,
    String type,
    String id,
  }) async {
    log.i("notesName : $notesName");
    log.i("Subject Name : $subName");
    log.i("Type : $type");
    try {
      String fileUrl =
          "https://storage.googleapis.com/ou-notes.appspot.com/pdfs/$subName/$type/$notesName";
      log.i(Uri.parse(fileUrl));
      var request = await HttpClient().getUrl(Uri.parse(fileUrl));
      var response = await request.close();
      log.w("downloading");
      var bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (bytesReceived, expectedContentLength) {
          if (expectedContentLength != null) {
            _progress = (bytesReceived / expectedContentLength * 100);
            notifyListeners();
          }
        },
      );

      String dir = (await getApplicationDocumentsDirectory()).path;
      String id = newCuid();
      // if (id == null || note.id.length == 0) {
      //   note.setId = id;
      // }
      File file = new File('$dir/$id');
      await file.writeAsBytes(bytes);
      log.i("file path: ${file.path}");
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
        votes: _voteService.votesBySub.value,
        downloadedNotes: getListOfNotesInDownloads(note.subjectName),
        notification: notification,
        isPinned: isPinned,
        refresh: refresh,
      ),
      onTap: () {
        incrementViewForAd();
        openDoc(note);
      },
    );
  }

  initialize() async {
    box = await Hive.openBox("Documents");
    _subjectsService.setBox(box);
  }
}
