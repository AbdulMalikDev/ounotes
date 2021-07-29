import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class RecentlyOpenedNotesService {
  Logger log = getLogger("RecentlyOpenedNotesService");
  User user;
  List<RecentlyOpenedNotes> _RecentlyOpenedNotess = [];

  List<RecentlyOpenedNotes> get RecentlyOpenedNoteslist =>
      _RecentlyOpenedNotess;

  addRecentlyOpenedNotes({RecentlyOpenedNotes recentlyOpenedNotes}){
    Box<RecentlyOpenedNotes> recentlyOpenedNotesBox =
        Hive.box<RecentlyOpenedNotes>(Constants.recentlyOpenedNotes);

    ///If the note is already present then find its index,
    ///and move it to top of the list(which in out case is the last element of the list)
    if (recentlyOpenedNotesBox.values.contains(recentlyOpenedNotes)) {
      List<RecentlyOpenedNotes> recentlyOpenedNotesList =
          recentlyOpenedNotesBox.values.toList();
      int noteIndex = 0;
      //find the note idx
      for (int i = 0; i < recentlyOpenedNotesBox.length; i++) {
        if (recentlyOpenedNotesList[i].id == recentlyOpenedNotes.id) {
          if (i == recentlyOpenedNotesList.length - 1) {
            return;
          }
          noteIndex = i;
          break;
        }
      }
      recentlyOpenedNotesBox.deleteAt(noteIndex);
    }
    recentlyOpenedNotesBox.add(recentlyOpenedNotes);

    if (recentlyOpenedNotesBox.length > 10) {
      //if RecentlyOpenedNotess list length is > 10
      //then delete the oldest RecentlyOpenedNotes which is at index 0
      recentlyOpenedNotesBox.deleteAt(0);
    }
  }

  void removeRecentlyOpenedNotes(int index, String path) {
    CloudStorageService _cloudStorageService = locator<CloudStorageService>();
    _cloudStorageService.deleteContent(path);
    Box recentlyOpenedNotesBox = Hive.box('RecentlyOpenedNotess');
    recentlyOpenedNotesBox.deleteAt(index);
  }
}
