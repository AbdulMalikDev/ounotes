import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
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
 AuthenticationService _authenticationService = locator<AuthenticationService>();
 AnalyticsService _analyticsService = locator<AnalyticsService>();
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
      setBusy(true);
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
      setBusy(false);
  }
  
  
  void uploadDocument(UploadLog logItem) async {
    setBusy(true);
    GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
    if (logItem.type == Constants.links)
    {
      _dialogService.showDialog(title: "ERROR" , description: "This is a link Bruh.");
      setBusy(false);
      return;
    }
    // since any other document except Notes do not need uploading
    dynamic doc = await _firestoreService.getDocumentById(logItem.id,Constants.getDocFromConstant(logItem.type));
    if(doc.GDriveLink != null){await _dialogService.showDialog(title: "ERROR" , description: "ALREADY UPLOADED");return;}
    String result = await _googleDriveService.processFile(doc: doc, document:Constants.getDocFromConstant(logItem.type) , addToGdrive: true);
    _dialogService.showDialog(title: "OUTPUT" , description: result);
    setBusy(false);
  }

  void deleteDocument(UploadLog logItem) async {
    setBusy(true);
    log.e(logItem);
    log.e(logItem.type);

    if (logItem.type == Constants.links)
    {
      log.e("document to be deleted is a link");
      _deleteDocument(logItem);
      setBusy(false);
      return;
    }

    GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
    dynamic doc = await _firestoreService.getDocumentById(logItem.id,Constants.getDocFromConstant(logItem.type));
    String result = await _googleDriveService.processFile(doc: doc, document:Constants.getDocFromConstant(logItem.type) , addToGdrive: false);
    _dialogService.showDialog(title: "OUTPUT" , description: result);
    setBusy(false);

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

  Future<String> getStatus(UploadLog logItem) async {
    if (logItem.type == Constants.notes){
      Note note = await _firestoreService.getNoteById(logItem.id);
      return note.GDriveLink==null ? "NOT UPLOADED" : "UPLOADED";
    } 
    return "None";
  }

   void accept(UploadLog uploadLog) async {
    String title = "Thank you for uploading ${uploadLog.uploader_name ?? ''} !!";
    String message = "We have reviewed the document you have uploaded \" ${uploadLog.fileName} \" in the \" ${uploadLog.subjectName} \" subject and it is LIVE ! Thank you again for making OU Notes a better place and helping all of us !";
    DialogResponse result = await _dialogService.showConfirmationDialog(title: "Sure?",description: "");
    if(result.confirmed){
    _analyticsService.sendNotification(id: uploadLog.uploader_id,message: message,title: title);
    }
  }


  void deny(UploadLog uploadLog) async {
    String title = "Thank you for uploading ${uploadLog.uploader_name ?? ''} !!";
    String message = "We have reviewed the document you have uploaded \" ${uploadLog.fileName} \" in the \" ${uploadLog.subjectName} \" subject and the document does not match our standards. Please try again with a better document. Feel free to contact us using the feedback feature !";
    DialogResponse result = await _dialogService.showConfirmationDialog(title: "Sure?",description: "");
    if(result.confirmed){
    _analyticsService.sendNotification(id: uploadLog.uploader_id,message: message,title: title);
    }
  }

  void ban(UploadLog uploadLog) async {
    String title = "We're Sorry !";
    String message = "We're sad to say that you won't be allowed to report or upload any documents. Feel free to contact us using the feedback feature !";
    DialogResponse result = await _dialogService.showConfirmationDialog(title: "Sure?",description: "");
    if(result.confirmed){
    _analyticsService.sendNotification(id: uploadLog.uploader_id,message: message,title: title);
    }
  }
}
