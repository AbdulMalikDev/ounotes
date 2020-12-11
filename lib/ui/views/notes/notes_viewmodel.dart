import 'dart:io';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_view.dart';
import 'package:cuid/cuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotesViewModel extends BaseViewModel {
  Logger log = getLogger("Notes view model");
  FirestoreService _firestoreService = locator<FirestoreService>();
  String table = 'uservoted_subjects';
  List<Vote> userVotedNotesList = [];
  List<Download> downloadedNotes = [];
  var _notes;

  AdmobService _admobService = locator<AdmobService>();
  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  DownloadService _downloadService = locator<DownloadService>();
  VoteServie _voteServie = locator<VoteServie>();

  double _progress = 0;
  double get progress => _progress;
  String _notetitle = '';
  String get notetitle => _notetitle;
  bool _ischecked = false;

  List<Vote> get voteslist => userVotedNotesList;
  AdmobService get admobService => _admobService;
  RemoteConfigService get remoteConfig => _remoteConfigService;
  String get ADMOB_AD_BANNER_ID => _admobService.ADMOB_AD_BANNER_ID;
  String get ADMOB_APP_ID => _admobService.ADMOB_APP_ID;
  List<Widget> _notesTiles = [];

  List<Widget> get notesTiles => _notesTiles;

  List<String> getzones() => [_remoteConfigService.remoteConfig.getString('ADCOLONY_ZONE_BANNER')];

  bool isloading = false;
  bool get loading => isloading;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  List<Note> get notes => _notes;

  Future fetchNotesAndVotes(String subjectName, BuildContext context) async {
    setBusy(true);
    _notes = await _firestoreService.loadNotesFromFirebase(subjectName);
    if (_notes is String) {
      await Fluttertoast.showToast(
          msg:
              "You are facing an error in loading the notes. If you are facing this error more than once, please let us know by using the 'feedback' option in the app drawer.");
      return;
    }
    await _voteServie.fetchAndSetVotes();
    await _downloadService.fetchAndSetDownloads();
    userVotedNotesList = _voteServie.userVotesList;

    for (int i = 0; i < _notes.length; i++) {
      Note note = _notes[i];
      if (notes[i].GDriveLink == null) {
        continue;
      }
      _notesTiles.add(
        InkWell(
          child: NotesTileView(
            ctx: context,
            note: note,
            index: i,
            votes: getListOfVoteBySub(subjectName),
            downloadedNotes: getListOfNotesInDownloads(subjectName),
            //votes: v.getListOfVoteBySub(
            //  notes[index].subjectName),
          ),
          onTap: () {
            // model.onTap(
            //   notesName: note.title,
            //   subName: note.subjectName,
            //   note: note,
            //   //! This is used so that spelling is not messed up while uploading
            //   type: Constants.notes,
            // );
            incrementViewForAd();
            openDoc(context, note);
          },
        ),
      );
    }
    setBusy(false);
    notifyListeners();
  }

  getListOfNotesInDownloads(String subName) {
    List<Download> allDownloads = _downloadService.downloadlist;
    List<Download> downloadsbysub = [];
    allDownloads.forEach((download) {
      if (download.type == Constants.notes &&
          download.subjectName.toLowerCase() == subName.toLowerCase()) {
        downloadsbysub.add(download);
      }
    });
    return downloadsbysub;
  }

  List<Vote> getListOfVoteBySub(String subname) {
    List<Vote> votesbySub = [];
    userVotedNotesList.forEach((vote) {
      if (vote.subname.toLowerCase() == subname.toLowerCase()) {
        votesbySub.add(vote);
      }
    });
    return votesbySub;
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

  void openDoc(BuildContext context, Note note) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Where do you want to open the file?",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        child: Text(
                          "Open in App",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 15),
                        ),
                        onPressed: () {
                          _sharedPreferencesService.updateView(note.id);
                          Navigator.pop(context);
                          navigateToWebView(note);
                        }),
                    FlatButton(
                        child: Text(
                          "Open In Browser",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 15),
                        ),
                        onPressed: () {
                          _sharedPreferencesService.updateView(note.id);
                          Helper.launchURL(note.GDriveLink);
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ]);
        });
  }

  void navigateToWebView(Note note) {
    _navigationService.navigateTo(Routes.webViewWidgetRoute,
        arguments: WebViewWidgetArguments(note: note));
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
        arguments: PDFScreenArguments(pathPDF: PDFpath, title: notesName));
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
}
