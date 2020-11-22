import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/db_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:FSOUNotes/ui/views/home/home_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
import 'package:FSOUNotes/utils/file_picker_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuid/cuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

@lazySingleton
class GoogleDriveService {
  FilePickerService _filePickerService = locator<FilePickerService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  NotesService _notesService = locator<NotesService>();
  QuestionPaperService _questionPaperService = locator<QuestionPaperService>();
  SyllabusService _syllabusService = locator<SyllabusService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  DownloadService _downloadService = locator<DownloadService>();
  DialogService _dialogService = locator<DialogService>();
  SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();
  Logger log = getLogger("GoogleDriveService");

  processFile({
    @required Note note,
    @required bool addToGdrive,
  }) async {
    log.i("Uploading File from Firebase Storage to Google Drive");
    try {
      log.e("Should this be added to GDrive : $addToGdrive");
      if (addToGdrive){

        // initialize http client and GDrive API
        var AuthHeaders = await _authenticationService.refreshSignInCredentials();
        var client = GoogleHttpClient(AuthHeaders);  
        var drive = ga.DriveApi(client);
        log.e(AuthHeaders);  
        
        // retrieve subject and notesmodel
        // log.e(_subjectsService.allSubjects);
        log.e(note.subjectName);
        Subject subject = _subjectsService.getSubjectByName(note.subjectName);
        log.e(subject);
        if (subject == null) {log.e("Subject is Null");return;}
        NotesViewModel notesViewModel = NotesViewModel();
        // Download File from Firebase
        ga.File fileToUpload = ga.File();  
        File file = await notesViewModel.downloadFile(notesName: note.title , subName: note.subjectName , type: Constants.notes);
        log.e(file);
        // Upload File To GDrive
        fileToUpload.parents = [subject.gdriveNotesFolderID];  
        fileToUpload.name = note.title;
        fileToUpload.copyRequiresWriterPermission = true; 
        print("Uploading file..........."); 
        var response = await drive.files.create(  
          fileToUpload, 
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
        );

        // Create Gdrive View Link
        String GDrive_URL = "https://drive.google.com/file/d/${response.id}/view?usp=sharing";  
        log.w(GDrive_URL);

        // add the link to the note object
        note.setGdriveDownloadLink(GDrive_URL);
        log.w(note.toJson());

        // update in firestore with GDrive Link
        _firestoreService.updateNoteInFirebase(note);

      }

      // if accidentally added to GDrive delete it from there too
      String result;
      if ( !addToGdrive && (note.GDriveLink != null && note.GDriveLink.length != 0))
      {
        log.w("File being deleted from GDrive");
        result = await this.deleteFile(note: note);
      }

      // Delete it from Firebase Storage
      _cloudStorageService.deleteDocument(note,addedToGdrive:addToGdrive);

      return addToGdrive ? "upload successful" : result ?? "delete successful";
    } catch (e) {
      return _errorHandling(e, "While UPLOADING Notes from Firebase STORAGE to Google Drive , Error occurred");
    }
  }

  Future<String> deleteFile({Note note}) async {
    try{
      log.e("File being deleted");
      // initialize http client and GDrive API
      var AuthHeaders = await _authenticationService.refreshSignInCredentials();
      var client = GoogleHttpClient(AuthHeaders);
      log.e(_authenticationService.user.googleSignInAuthHeaders);  
      var drive = ga.DriveApi(client);
      
      //Extract File ID
      String url = note.GDriveLink.split("https://drive.google.com/file/d/")[1];
      String FileID = url.split("/view?usp=sharing")[0];

      
      var response = await drive.files.delete(FileID);
      await _firestoreService.deleteDocument(note);
      return "delete successful";

    }catch (e) {
      return _errorHandling(e, "While DELETING Notes IN Google Drive , Error occurred");
    }
  }

  

  _errorHandling(e, String message) {
    log.e(message);
    String error;
    if (e is PlatformException) error = e.message;
    error = e.toString();
    log.e(error);
    return error;
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
