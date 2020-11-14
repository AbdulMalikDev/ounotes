import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotesTileViewModel extends BaseViewModel {
  final log = getLogger("BuildTileOfNotes");

  FirestoreService _firestoreService = locator<FirestoreService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  ReportsService _reportsService = locator<ReportsService>();
  DialogService _dialogService = locator<DialogService>();
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();

  VoteServie _voteServie = locator<VoteServie>();
  bool _hasalreadyvoted = false;
  bool get hasalreadyvoted => _hasalreadyvoted;
  String _vote = Constants.none;
  String get vote => _vote;

  bool _isnotedownloaded = false;
  bool get isnotedownloaded => _isnotedownloaded;

  handleVotes(String vote, String votedon, Note note) {
    //if the user has pressed on same vote again then make the vote to none and update it in db
    if (vote == votedon) {
      _vote = Constants.none;
      if (votedon == Constants.upvote) {
        _firestoreService.decrementVotes(note, 1);
      } else {
        _firestoreService.incrementVotes(note, 1);
      }
      _voteServie.removeVote(note.title);
    } else {
      //if not then check if he upvoted or downvoted
      //if upvoted then increment the votes
      //check if vote was none or not
      bool wasvotenone = false;
      if (votedon == Constants.upvote) {
        if (_vote == Constants.none) wasvotenone = true;
        _vote = Constants.upvote;
        //if vote was none then incementvote by once
        if (wasvotenone)
          _firestoreService.incrementVotes(note, 1);
        else {
          _firestoreService.incrementVotes(note, 2);
        }
        //if user has not already voted then add to db
        if (!hasalreadyvoted) {
          addtoVotes(hasupvotes: true, hasdownvotes: false, note: note);
        }
        //else the user has already voted then update the value in the db
        else {
          updateVotes(hasupvotes: true, hasdownvotes: false, note: note);
        }
      } else {
        if (_vote == Constants.none) wasvotenone = true;
        _vote = Constants.downvote;
        if (wasvotenone)
          _firestoreService.decrementVotes(note, 1);
        else {
          _firestoreService.decrementVotes(note, 2);
        }
        if (!hasalreadyvoted) {
          addtoVotes(hasupvotes: false, hasdownvotes: true, note: note);
        } else {
          updateVotes(hasupvotes: false, hasdownvotes: true, note: note);
        }
      }
    }
    notifyListeners();
  }

  addtoVotes({bool hasupvotes, bool hasdownvotes, Note note}) {
    _voteServie.addVote(
      noteName: note.title,
      hasDownvotes: hasdownvotes,
      hasUpvotes: hasupvotes,
      subname: note.subjectName,
    );
  }

  updateVotes({bool hasupvotes, bool hasdownvotes, Note note}) {
    _voteServie.updateVotes(
      noteName: note.title,
      hasDownvotes: hasdownvotes,
      hasUpvotes: hasupvotes,
      subname: note.subjectName,
    );
  }

  getSnapShotOfVotes(Note note) {
    return _firestoreService.getSnapShotOfVotes(note);
  }

  // getListOfVoteBySub(String subname) {
  //   votesbySub.forEach((vote) {
  //     if (vote.subname.toLowerCase() == subname.toLowerCase()) {
  //       votesbySub.add(vote);
  //     }
  //   });
  // }

  checkIfUserVotedAndDownloadedNote(
      List<Vote> votesbySub, List<Download> downloadedNotebySub, Note note) {
    setBusy(true);
    for (int j = 0; j < downloadedNotebySub.length; j++) {
      if (downloadedNotebySub[j].filename == note.title) {
        _isnotedownloaded = true;
      }
    }
    for (int i = 0; i < votesbySub.length; i++) {
      if (note.title.toLowerCase() == votesbySub[i].notesName.toLowerCase()) {
        log.i("checking if user voted");
        votesbySub[i].hasUpvoted
            ? _vote = Constants.upvote
            : votesbySub[i].hasDownvoted
                ? _vote = Constants.downvote
                : _vote = Constants.none;
        _hasalreadyvoted = true;
      }
    }
    notifyListeners();
    setBusy(false);
  }

  bool get isAdmin => _authenticationService.user.isAdmin;

  void reportNote(
      {String id, String subjectName, String type, String title , AbstractDocument doc}) async {
    Report report =
        Report(id, subjectName, type, title, _authenticationService.user.email);
    var dialogResult = await _dialogService.showConfirmationDialog(
        title: "Are You Sure?",
        description: "Are you sure you want to report this Document?",
        cancelTitle: "NO",
        confirmationTitle: "YES");
    if (!dialogResult.confirmed) {
      return;
    }
    var result = await _reportsService.addReport(report);
    if (result is String) {
      _dialogService.showDialog(
          title: "Thank you for reporting", description: result);
    } else {
      await _firestoreService.reportNote(report: report , doc:doc);
      Fluttertoast.showToast(
          msg: "Your report has been recorded. The admins will look into this.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setBusy(false);
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
    var response = await _googleDriveService.deleteFile(note:note);
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

  
}
