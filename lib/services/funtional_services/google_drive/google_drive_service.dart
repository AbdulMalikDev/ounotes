import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/pdf_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:FSOUNotes/utils/file_picker_service.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:mime/mime.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/io_client.dart';
import 'package:FSOUNotes/app/app.logger.dart';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;

// All top level Variables and Serivces needed are stored in this file
// For specific functions explore the files below

// Contains all firebase read function calls
part './CRUD/google_drive_read.dart';
// Contains all firebase create and update function calls
part './CRUD/google_drive_write.dart';
// Contains all firebase delete function calls
part './CRUD/google_drive_delete.dart';
// Contains all other functions and switch cases
// If its not making a call directly it goes here
part './google_drive_extra/google_drive_functions.dart';

Logger log = getLogger("GoogleDriveService");

class GoogleDriveService {
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  math.Random _rnd = math.Random();

  RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  FilePickerService _filePickerService = locator<FilePickerService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  DownloadService _downloadService = locator<DownloadService>();
  RemoteConfigService _remote = locator<RemoteConfigService>();
  PDFService _pdfService = locator<PDFService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  NotesService _notesService = locator<NotesService>();
  QuestionPaperService _questionPaperService = locator<QuestionPaperService>();
  SyllabusService _syllabusService = locator<SyllabusService>();

  ValueNotifier<double> downloadProgress = new ValueNotifier(0);

  /// Function to Process and Upload [ File ]
  ///
  /// `@return values`
  ///
  ///   - "BLOCKED"
  ///
  ///   - "File is null"
  ///
  ///   - "file is not compatible. Please make sure you uploaded a PDF"
  ///
  ///   - "Upload Successful";
  ///
  processFile({
    @required dynamic doc,
    @required Document docEnum,
    @required AbstractDocument note,
    String type,
    String uploadFileType = Constants.pdf,
  }) async {
    log.v("Uploading file to Google Drive");

    //Variables
    bool isImage;
    String docPath;
    PdfDocument pdf;
    String GDrive_URL;
    ga.File gDriveFileToUpload;
    ga.File response;
    if (type == null) type = note.type;

    /// TODO
    /// handle return of string
    /// add pdf compress library

    //>> Pre-Upload Check
    bool result1 = await _firestoreService.areUsersAllowed();
    bool result2 = await _firestoreService
        .refreshUser()
        .then((user) => user.isUserAllowedToUpload);
    if (!result1 || !result2) {
      return "BLOCKED";
    }
    _logValuesToConsole(note, type);

    //>> 1. Initiate Upload Logic
    try {
      //>> 1.1 Select file, sanitize extension and create a PDF Object

      String tempPath =
          (await _localPath()) + "/${DateTime.now().millisecondsSinceEpoch}";
      //Not defining type since it could be List of files or just one file
      List result =
          await _filePickerService.selectFile(uploadFileType: uploadFileType);
      final document = result[0];
      if (document == null) return "File is null";
      isImage = result[1];
      log.e("isImage : " + isImage.toString());
      docPath = isImage ? document[0].path : document.path;
      log.e(docPath);
      String mimeStr = lookupMimeType(docPath);
      log.e("MimeType : " + mimeStr);
      var fileType = mimeStr.split('/').last;
      bool isValidExtension = ['pdf', 'jpg', 'jpeg', 'png'].contains(fileType);
      if (!isValidExtension) {
        return 'file is not compatible. Please make sure you uploaded a PDF';
      } else if (['jpg', 'jpeg', 'png'].contains(fileType)) {
        pdf = await _pdfService.convertImageToPdf(document, tempPath);
      } else {
        pdf = PdfDocument(
          inputBytes: document.readAsBytesSync(),
        );
      }

      //>> 1.2 Find size of file, make sure not more than 35 MB

      int lengthOfDoc = isImage
          ? await _getLengthOfImages(document)
          : await document.length();
      log.e("lengthOfDoc : " + lengthOfDoc.toString());
      final String bytes = _formatBytes2(lengthOfDoc, 2);
      final String bytesuffix = _formatBytes2Suffix(lengthOfDoc, 2);
      log.i("suffix of size" + bytesuffix);
      log.i("size of file" + bytes);
      var suffix = ["MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      if (double.parse(bytes) > 35 && suffix.contains(bytesuffix)) {
        return "File size more than 35mb";
      }

      //>> 1.3 Verify intent of File Upload with user

      File fileToUpload = isImage ? null : document;
      if (fileToUpload == null) fileToUpload = File(tempPath);
      final validDocument = await _navigationService.navigateTo(
        Routes.pDFScreen,
        arguments: PDFScreenArguments(
            doc: note, pathPDF: fileToUpload.path, isUploadingDoc: true),
      );
      log.i(validDocument);
      if (!validDocument) {
        return "Invalid document";
      }

      //>> 1.4 Compress PDF
      String outputPath = await getOutputPath();
      log.e(outputPath);
      await PdfCompressor.compressPdfFile(
          docPath, outputPath, CompressQuality.MEDIUM);
      fileToUpload = File(outputPath);

      //>> 1.5 Upload to Google Drive

      log.i("Uploading File to Google Drive");
      log.i(doc);
      log.i(document);

      try {
        //>> 1.5.1 initialize http client and GDrive API
        final accountCredentials = new ServiceAccountCredentials.fromJson(
            _remote.remoteConfig.getString("GDRIVE"));
        final scopes = ['https://www.googleapis.com/auth/drive'];
        AutoRefreshingAuthClient gdriveAuthClient =
            await clientViaServiceAccount(accountCredentials, scopes);
        var drive = ga.DriveApi(gdriveAuthClient);
        Subject subject = _subjectsService.getSubjectByName(doc.subjectName);
        String subjectSubFolderID = _getFolderIDForType(subject, docEnum);
        if (subject == null) {
          log.e("Subject is Null");
          return;
        }

        //>> 1.5.2 Set metadata for the GDrive File
        gDriveFileToUpload = ga.File();
        gDriveFileToUpload.parents = [subjectSubFolderID];
        gDriveFileToUpload.name = doc.title;
        gDriveFileToUpload.copyRequiresWriterPermission = true;

        //>> 1.5.3 Commence Upload
        log.e(fileToUpload);
        response = await drive.files.create(
          gDriveFileToUpload,
          uploadMedia:
              ga.Media(fileToUpload.openRead(), fileToUpload.lengthSync()),
        );

        ///>> 1.5.4 Create and Set Data to access the uploaded file
        GDrive_URL =
            "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
        log.w("GDrive Link : " + GDrive_URL);
        doc = _setLinkToDocument(
            doc, GDrive_URL, response.id, subjectSubFolderID, docEnum);
        log.w(doc.toJson());
        // update in firestore with GDrive Link
        await _firestoreService.updateDocument(doc, docEnum);
      } catch (e) {
        return _errorHandling(
            e, "While UPLOADING Notes to Google Drive , Error occurred");
      }

      //>> 1.6 Set Metadata of the file to store in Database
      String fileName = assignFileName(note);
      note.setTitle = fileName;
      note.setUrl = GDrive_URL;
      note.setSize = _formatBytes(fileToUpload.lengthSync(), 2);
      note.setDate = DateTime.now();
      note.setPages = pdf.pages.count;
      log.e(note.toJson());

      //>> Post-Upload Sanitization and finishing touches
      pdf.dispose();
      fileToUpload.delete();
      _firestoreService.saveNotes(note);
      return "Upload Successful";
    } catch (e) {
      return _errorHandling(
          e, "While UPLOADING Notes to Google Drive , Error occurred (outer)");
    }
  }

  Future<String> deleteFile({@required dynamic doc}) async {
    try {
      log.e("File being deleted");
      // initialize http client and GDrive API
      final accountCredentials = new ServiceAccountCredentials.fromJson(
          _remote.remoteConfig.getString("GDRIVE"));
      final scopes = ['https://www.googleapis.com/auth/drive'];

      AutoRefreshingAuthClient gdriveAuthClient =
          await clientViaServiceAccount(accountCredentials, scopes);
      var drive = ga.DriveApi(gdriveAuthClient);
      await _firestoreService.deleteDocument(doc);
      await drive.files.delete(doc.GDriveID);
      return "delete successful";
    } catch (e) {
      return _errorHandling(
          e, "While DELETING Notes IN Google Drive , Error occurred");
    }
  }

  downloadFile(
      {@required Note note,
      @required onDownloadedCallback,
      @required startDownload}) async {
    try {
      log.e(note.toJson());
      //*If file exists, avoid downloading again
      File localFile;
      Directory tempDir = await getTemporaryDirectory();
      String filePath = "${tempDir.path}/${note.subjectId}_${note.id}";
      log.e(filePath);
      bool doesFileExist = await _checkIfFileExists(filePath);
      if (doesFileExist) {
        onDownloadedCallback(filePath, note);
        return;
      }

      startDownload();

      //*Google Drive Set Up
      final accountCredentials = new ServiceAccountCredentials.fromJson(
          _remote.remoteConfig.getString("GDRIVE"));
      final scopes = ['https://www.googleapis.com/auth/drive'];
      AutoRefreshingAuthClient gdriveAuthClient =
          await clientViaServiceAccount(accountCredentials, scopes);
      log.e(_remote.remoteConfig.getString("GDRIVE"));
      log.e(accountCredentials);
      log.e(gdriveAuthClient);
      log.e(note.GDriveID);
      log.e(note.GDriveLink);
      log.e(note.GDriveNotesFolderID);
      var drive = ga.DriveApi(gdriveAuthClient);
      log.e(note.GDriveNotesFolderID);
      String fileID = note.GDriveID;
      log.e(note.GDriveNotesFolderID);

      //*Download file
      ga.Media file = await drive.files
          .get(fileID, downloadOptions: ga.DownloadOptions.fullMedia);
      log.e(note.GDriveNotesFolderID);

      //*Figure out size from note.size property to show proper loading indicator
      double contentLength =
          double.parse(note.size == null ? '0.0' : note.size.split(" ")[0]);
      contentLength = note.size == null
          ? 0
          : note.size.split(" ")[1] == 'KB'
              ? contentLength * 1000
              : contentLength * 1000000;
      int downloadedLength = 0;
      downloadProgress.value = 0;
      List<int> dataStore = [];

      //*Start the download
      file.stream.listen((data) {
        downloadedLength += data.length;
        downloadProgress.value = ((downloadedLength / contentLength) * 100);
        print(downloadProgress.value);
        dataStore.insertAll(dataStore.length, data);
      }, onDone: () async {
        localFile = File(filePath);
        await localFile.writeAsBytes(dataStore);
        _insertBookmarks(filePath, note);
        // Download downloadObject = Download(
        //   note.id,
        //   filePath,
        //   note.title,
        //   note.subjectName,
        //   note.author,
        //   note.view,
        //   note.pages,
        //   note.size,
        //   note.uploadDate,
        // );
        // _downloadService.addDownload(download: downloadObject);
        await Future.delayed(Duration(seconds: 1));
        downloadProgress.value = 0;
        onDownloadedCallback(localFile.path, note);
      });
    } catch (e) {
      log.e(e.toString());

      throw e;
    }
  }

  Future downloadPuchasedPdf(
      {Note note,
      Function(String, String) onDownloadedCallback,
      Function startDownload}) async {
    PermissionStatus status = await Permission.storage.request();
    log.e(status.isGranted);

    startDownload();

    //*Google Drive Set Up
    final accountCredentials = new ServiceAccountCredentials.fromJson(
        _remote.remoteConfig.getString("GDRIVE"));
    final scopes = ['https://www.googleapis.com/auth/drive'];
    AutoRefreshingAuthClient gdriveAuthClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    var drive = ga.DriveApi(gdriveAuthClient);
    //*Download file
    String fileID = note.GDriveID;
    ga.Media file = await drive.files
        .get(fileID, downloadOptions: ga.DownloadOptions.fullMedia);
    var dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    String fileName = "${note.subjectName}_${note.title}.pdf";
    String filePath = dir + fileName;

    //*Figure out size from note.size property to show proper loading indicator
    File localFile;
    double contentLength = double.parse(note.size.split(" ")[0]);
    contentLength = note.size.split(" ")[1] == 'KB'
        ? contentLength * 1000
        : contentLength * 1000000;
    log.e("Size in numbers : " + contentLength.toString());
    int downloadedLength = 0;
    downloadProgress.value = 0;
    List<int> dataStore = [];

    //*Start the download
    file.stream.listen((data) {
      downloadedLength += data.length;
      downloadProgress.value = (downloadedLength / contentLength) * 100;
      log.e(downloadedLength);
      log.e(contentLength);
      print("loading.. : " + downloadProgress.value.toString());
      // if(downloadProgress.value < 1)
      // EasyLoading.showProgress(downloadProgress.value, status: 'downloading...');
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      // EasyLoading.dismiss();
      localFile = File(filePath);
      await localFile.writeAsBytes(dataStore);
      await Future.delayed(Duration(seconds: 1));
      downloadProgress.value = 0;
      onDownloadedCallback(localFile.path, fileName);
      log.e("DOWNLOAD DONE");
    });
  }

  Future<Subject> createSubjectFolders(Subject subject) async {
    log.i("${subject.name} folders being created in GDrive");
    // initialize http client and GDrive API
    try {
      var AuthHeaders = await _authenticationService.refreshSignInCredentials();
      var client = GoogleHttpClient(AuthHeaders);
      var drive = ga.DriveApi(client);
      var subjectFolder = await drive.files.create(
        ga.File()
          ..name = subject.name
          ..parents = [
            _remoteConfigService.remoteConfig.getString("ROOT_FOLDER_GDRIVE")
          ] // Optional if you want to create subfolder
          ..mimeType =
              'application/vnd.google-apps.folder', // this defines its folder
      );
      var notesFolder = await drive.files.create(
        ga.File()
          ..name = 'NOTES'
          ..parents = [
            subjectFolder.id
          ] // Optional if you want to create subfolder
          ..mimeType =
              'application/vnd.google-apps.folder', // this defines its folder
      );
      var questionPapersFolder = await drive.files.create(
        ga.File()
          ..name = 'QUESTION PAPERS'
          ..parents = [
            subjectFolder.id
          ] // Optional if you want to create subfolder
          ..mimeType =
              'application/vnd.google-apps.folder', // this defines its folder
      );
      var syllabusFolder = await drive.files.create(
        ga.File()
          ..name = 'SYLLABUS'
          ..parents = [
            subjectFolder.id
          ] // Optional if you want to create subfolder
          ..mimeType =
              'application/vnd.google-apps.folder', // this defines its folder
      );

      subject.addFolderID(subjectFolder.id);
      subject.addNotesFolderID(notesFolder.id);
      subject.addQuestionPapersFolderID(questionPapersFolder.id);
      subject.addSyllabusFolderID(syllabusFolder.id);
      log.e(subjectFolder.id);
      log.e(notesFolder.id);
      log.e(questionPapersFolder.id);
      log.e(syllabusFolder.id);
      return subject;
    } catch (e) {
      log.e("Error while creating folders for new subject ${subject.name}");
      log.e(e.toString());
      return null;
    }
  }

  deleteSubjectFolder(Subject subject) async {
    log.i("${subject.name} folders being DELETED in GDrive");
    // initialize http client and GDrive API
    try {
      var AuthHeaders = await _authenticationService.refreshSignInCredentials();
      var client = GoogleHttpClient(AuthHeaders);
      var drive = ga.DriveApi(client);
      await drive.files.delete(subject.gdriveFolderID);
    } catch (e) {
      log.e("Error while DELETING folders for subject : ${subject.name}");
      log.e(e.toString());
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

  String _getFolderIDForType(Subject subject, Document document) {
    switch (document) {
      case Document.Notes:
        return subject.gdriveNotesFolderID;
        break;
      case Document.QuestionPapers:
        return subject.gdriveQuestionPapersFolderID;
        break;
      case Document.Syllabus:
        return subject.gdriveSyllabusFolderID;
        break;
      default:
        break;
    }
    return null;
  }

  _setLinkToDocument(dynamic doc, String gDrive_URL, String id,
      String subjectSubFolderID, Document document) {
    switch (document) {
      case Document.Notes:
        Note note = doc;
        note.setGdriveDownloadLink(gDrive_URL);
        note.setGdriveID(id);
        note.setGDriveNotesFolderID(subjectSubFolderID);
        return note;
        break;
      case Document.QuestionPapers:
        QuestionPaper paper = doc;
        paper.setGdriveDownloadLink(gDrive_URL);
        paper.setGdriveID(id);
        paper.setGDriveQuestionPapersFolderID(subjectSubFolderID);
        return paper;
        break;
      case Document.Syllabus:
        Syllabus syllabus = doc;
        syllabus.setGdriveDownloadLink(gDrive_URL);
        syllabus.setGdriveID(id);
        syllabus.setGDriveSyllabusFolderID(subjectSubFolderID);
        return syllabus;
        break;
      default:
        break;
    }
  }

  Future<bool> _checkIfFileExists(String filePath) async {
    bool doesExist = false;
    try {
      doesExist = await File(filePath).exists();
    } catch (e) {
      return false;
    }
    return doesExist;
  }

  void _insertBookmarks(String filePath, Note note) {
    //Check if pages field is populated
    //if not update in firebase.
    bool noteHasPages = true;
    if (note.pages == null) {
      noteHasPages = false;
    }

    //Loads an existing PDF document
    PdfDocument document =
        PdfDocument(inputBytes: File(filePath).readAsBytesSync());
    int pages = document.pages.count;
    List<String> bookmarkNames = note.bookmarks.keys.toList();
    List<int> bookmarkPageNos = note.bookmarks.values.toList();
    for (int i = 0; i < note.bookmarks.length; i++) {
      if (bookmarkPageNos[i] > pages - 1 || bookmarkPageNos[i] < 0) continue;
      //Creates a document bookmark
      PdfBookmark bookmark = document.bookmarks.insert(i, bookmarkNames[i]);

      //Sets the destination page and location
      bookmark.destination =
          PdfDestination(document.pages[bookmarkPageNos[i]], Offset(20, 20));
    }

    //Saves the document
    File(filePath).writeAsBytes(document.save());
    note.setPages = pages;
    if (!noteHasPages) {
      _firestoreService.updateDocument(note, Document.Notes);
    }

    //Disposes the document
    document.dispose();
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
