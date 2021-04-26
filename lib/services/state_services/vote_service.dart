import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/services/funtional_services/db_service.dart';
import 'package:flutter/cupertino.dart';

class VoteService with ChangeNotifier {
  String table = 'uservoted_subjects';
  List<Vote> allVotes = [];
  ValueNotifier<List<Vote>> _userVotedNotesBySubject =
      new ValueNotifier(new List<Vote>());
  Map<String, int> _numberOfVotes = {};

  List<Vote> get userVotesList => allVotes;
  ValueNotifier<List<Vote>> get votesBySub => _userVotedNotesBySubject;
  Map<String, int> get numberOfVotes => _numberOfVotes;

  set setNumberOfVotes(Map<String, int> noOfVotes) {
    _numberOfVotes = noOfVotes;
  }

  //sqlite support boolean but in the form of integer 0-false , 1-true
  addVote({String subname, String noteName, bool upVote, bool downVote}) async {
    DBService _dbservie = locator<DBService>();
    _dbservie.insert(table, {
      'notename': noteName,
      'hasupvoted': upVote ? 1 : 0,
      'hasdownvoted': downVote ? 1 : 0,
      'subname': subname,
    });
    _userVotedNotesBySubject.value.add(Vote(
        hasDownvoted: downVote,
        hasUpvoted: upVote,
        notesName: noteName,
        subname: subname));
    _userVotedNotesBySubject.notifyListeners();
  }

  Future<void> fetchAndSetVotesBySubject(String subName) async {
    DBService _dbservie = locator<DBService>();
    final dataList = await _dbservie.getData(table);
    allVotes = dataList
        .map(
          (item) => Vote(
            notesName: item['notename'],
            hasDownvoted: item['hasdownvoted'] == 1 ? true : false,
            hasUpvoted: item['hasupvoted'] == 1 ? true : false,
            subname: item['subname'],
          ),
        )
        .toList();
    List<Vote> votesBySub = getListOfVoteBySub(subName);
    _userVotedNotesBySubject.value = votesBySub;
    _userVotedNotesBySubject.notifyListeners();
  }

  updateVotes(
      {String subname, String noteName, bool hasUpvotes, bool hasDownvotes}) {
    DBService _dbservie = locator<DBService>();
    _dbservie.updateVotes(
        table,
        {
          'notename': noteName,
          'hasupvoted': hasUpvotes ? 1 : 0,
          'hasdownvoted': hasDownvotes ? 1 : 0,
          'subname': subname,
        },
        noteName);
    _userVotedNotesBySubject.value
        .removeWhere((vote) => vote.notesName == noteName);
    _userVotedNotesBySubject.value.add(Vote(
        hasDownvoted: hasDownvotes,
        hasUpvoted: hasUpvotes,
        notesName: noteName,
        subname: subname));
    _userVotedNotesBySubject.notifyListeners();
  }

  void removeVote(String notesName) {
    DBService _dbservie = locator<DBService>();
    allVotes.removeWhere((vote) => vote.notesName == notesName);
    _dbservie.deleteVote(table, notesName);
    _userVotedNotesBySubject.value
        .removeWhere((vote) => vote.notesName == notesName);
    _userVotedNotesBySubject.notifyListeners();
  }

  List<Vote> getListOfVoteBySub(String subname) {
    List<Vote> votesbySub = [];
    allVotes.forEach((vote) {
      if (vote.subname.toLowerCase() == subname.toLowerCase()) {
        votesbySub.add(vote);
      }
    });
    return votesbySub;
  }
}
