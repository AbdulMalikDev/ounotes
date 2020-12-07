import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/services/funtional_services/db_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VoteServie {
  String table = 'uservoted_subjects';
  List<Vote> userVotedNotes = [];
  List<Vote> _recentlyAddedVotes = [];

  List<Vote> get userVotesList => userVotedNotes;
  List<Vote> get votesBySub => _recentlyAddedVotes;

  //sqlite support boolean but in the form of integer 0-false , 1-true
  addVote(
      {String subname,
      String noteName,
      bool hasUpvotes,
      bool hasDownvotes}) async {
    DBService _dbservie = locator<DBService>();
    _dbservie.insert(table, {
      'notename': noteName,
      'hasupvoted': hasUpvotes ? 1 : 0,
      'hasdownvoted': hasDownvotes ? 1 : 0,
      'subname': subname,
    });
  }

  Future<void> fetchAndSetVotes() async {
    DBService _dbservie = locator<DBService>();
    final dataList = await _dbservie.getData(table);
    userVotedNotes = dataList
        .map(
          (item) => Vote(
            notesName: item['notename'],
            hasDownvoted: item['hasdownvoted'] == 1 ? true : false,
            hasUpvoted: item['hasupvoted'] == 1 ? true : false,
            subname: item['subname'],
          ),
        )
        .toList();
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
  }

  void removeVote(String notesName) {
    DBService _dbservie = locator<DBService>();
    userVotedNotes.removeWhere((vote) => vote.notesName == notesName);
    _dbservie.deleteVote(table, notesName);
  }
}
