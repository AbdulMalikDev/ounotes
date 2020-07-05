import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotesService {
  List<Note> _notes;

  List<Note> get notes => _notes;

  set setNotes(List<Note> notes) {
    _notes = notes;
  }

  bool get isNotesPresent => _notes != null;

  //* This Function will assign name accordingly
  //* in other words it handles duplicates
  assignNameToNotes({String title}) {
    //Decide FileName
    String fileName = title;
    int count = _findNumberOfNotesByName(title: title);
    if (count != 0) {
      fileName = fileName + "No." + (count + 1).toString();
    }
    return fileName;
  }

  _findNumberOfNotesByName({String title}) {
    if(_notes==null){return 0;}
    int count = _notes.where((c) => c.title.contains(title)).toList().length;
    return count;
  }
}
