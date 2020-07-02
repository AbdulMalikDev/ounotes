import 'dart:io';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:cuid/cuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Note> _notes = [];
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  NavigationService _navigationService = locator<NavigationService>();
  DownloadService _downloadService = locator<DownloadService>();
  VoteServie _voteServie = locator<VoteServie>();
  DialogService _dialogService = locator<DialogService>();
  double _progress = 0;
  double get progress => _progress;
  String _notetitle = '';
  String get notetitle => _notetitle;

  List<Vote> get voteslist => userVotedNotesList;

  bool isloading = false;
  bool get loading => isloading;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  List<Note> get notes => _notes;

  Future fetchNotesAndVotes(String subjectName) async {
    setBusy(true);
    _notes = await _firestoreService.loadNotesFromFirebase(subjectName);
    await _voteServie.fetchAndSetVotes();
    await _downloadService.fetchAndSetDownloads();
    userVotedNotesList = _voteServie.userVotesList;
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

  // showDialogOfProgress(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //           title: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text(
  //                 "Note",
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .headline6
  //                     .copyWith(fontSize: 18),
  //               ),
  //             ],
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text(
  //                 "File is downloading",
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .subtitle1
  //                     .copyWith(fontSize: 18),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  getListOfVoteBySub(String subname) {
    List<Vote> votesbySub = [];
    userVotedNotesList.forEach((vote) {
      if (vote.subname.toLowerCase() == subname.toLowerCase()) {
        votesbySub.add(vote);
      }
    });
    return votesbySub;
  }

  String filePath;
  Future<bool> checkNoteInDownloads(Note note) async {
    await _downloadService.fetchAndSetDownloads();
    List<Download> allDownloads = _downloadService.downloadlist;
    allDownloads.forEach((download) {
      if (download.type == Constants.notes) {
        downloadedNotes.add(download);
      }
    });
    for (int i = 0; i < downloadedNotes.length; i++) {
      if (downloadedNotes[i].filename == note.title &&
          downloadedNotes[i].subjectName == note.subjectName) {
        filePath = downloadedNotes[i].path;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void onTap({
    Note note,
    String notesName,
    String subName,
    String type,
  }) async {
    checkNoteInDownloads(note).then((val) async {
      if (val) {
        _navigationService.navigateTo(Routes.pdfScreenRoute,
            arguments: PDFScreenArguments(pathPDF: filePath, title: notesName));
      } else {
        setLoading(true);
        String PDFpath = await _cloudStorageService.downloadFile(
          notesName: notesName,
          subName: subName,
          type: type,
          note: note,
        );
        _firestoreService.incrementView(note);
        _downloadService.addDownload(
          path: PDFpath,
          id: note.id,
          filename: notesName,
          subjectName: subName,
          type: type,
          title: note.title,
        );
        setLoading(false);
        _navigationService.navigateTo(Routes.pdfScreenRoute,
            arguments: PDFScreenArguments(pathPDF: PDFpath, title: notesName));
      }
    });
  }

  // @override
  // Future futureToRun() =>fetchNotes();

}
