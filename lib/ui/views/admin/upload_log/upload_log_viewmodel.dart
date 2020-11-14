import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UploadLogViewModel extends FutureViewModel{
 FirestoreService _firestoreService = locator<FirestoreService>();
 DialogService _dialogService = locator<DialogService>();
 Logger log = getLogger("UploadLogViewModel");

  List<UploadLog> _logs;

  List<UploadLog> get logs => _logs;

  fetchUploadLogs() async {
    _logs = await _firestoreService.loadUploadLogFromFirebase();
  }

  @override
  Future futureToRun() => fetchUploadLogs();

  deleteLogItem(UploadLog report) async {
    var dialogResult = await _dialogService.showConfirmationDialog(
      title: "Are you sure?",
      description:
          "Upload Log will be deleted. As an admin please make sure to take necessary steps",
      cancelTitle: "WAIT",
      confirmationTitle: "Apne baap ku mat sikha"
    );
    if(dialogResult.confirmed)await _firestoreService.deleteUploadLog(report);
  }

  void viewDocument(UploadLog logItem) {
      NotesViewModel notesViewModel = NotesViewModel();

      if (logItem.type == Constants.links){
        _showLink(logItem);
      }else{

      notesViewModel.onTap(
        notesName: logItem.fileName, 
        subName: logItem.subjectName,
        type: logItem.type,
      );

      }
  }

  void uploadDocument(UploadLog logItem) async {
    GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
    if (logItem.type != Constants.notes)
    {
      _dialogService.showDialog(title: "ERROR" , description: "You can only upload Notes from Admin Panel not other documents");
      return;
    }
    // since any other document except Notes do not need uploading
    Note note = await _firestoreService.getNoteById(logItem.id);
    _googleDriveService.processFile(note: note, addToGdrive: true);
  }

  void deleteDocument(UploadLog logItem) async {
    log.e(logItem);
      log.e(logItem.type);

    if (logItem.type != Constants.notes)
    {
      _deleteDocument(logItem);
      return;
    }
    GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
    Note note = await _firestoreService.getNoteById(logItem.id);
    _googleDriveService.processFile(note: note, addToGdrive: false);
  
    }
  
    void _showLink(UploadLog logItem) async {
      Link link = await _firestoreService.getLinkById(logItem.id);
        _dialogService.showDialog(title: "Link Content" , description: link.linkUrl);
    }
  
    void _deleteDocument(UploadLog logItem) async {
      NotesTileViewModel notesTileViewModel = NotesTileViewModel();
      log.e(logItem.type);
      if (logItem.type == Constants.questionPapers)
      {
        QuestionPaper questionPaper = await _firestoreService.getQuestionPaperById(logItem.id);
        notesTileViewModel.delete(questionPaper);
      }else if(logItem.type == Constants.syllabus){
        Syllabus syllabus = await _firestoreService.getSyllabusById(logItem.id);
        notesTileViewModel.delete(syllabus);
      }else if(logItem.type == Constants.links){
        Link link = await _firestoreService.deleteLinkById(logItem.id);
      }
    }
}
