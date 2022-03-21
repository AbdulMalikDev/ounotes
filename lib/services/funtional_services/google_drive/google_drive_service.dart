import 'dart:io';
import 'dart:math' as math;

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/pdf_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:FSOUNotes/utils/file_picker_service.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Contains all Google Drive delete function calls
part './CRUD/google_drive_delete.dart';
// Contains all Google Drive read function calls
part './CRUD/google_drive_read.dart';
// Contains all Google Drive create and update function calls
part './CRUD/google_drive_write.dart';
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

  //TODO
  /// Merge the verified document upload to gdrive with the normal wala function
  /// Merge Download and DownloadPurchased functions

  /// Difference betweeen downloadFile and downloadPuchasedPdf seems to be that
  /// in download file we are making sure it hasnt been downloaded before and
  /// for purchased pdfs we are ensuring that its downloaded in the external directory
  /// where its visible. Both should be clubbed into one.

  downloadFile(
      {@required Note note,
      @required onDownloadedCallback,
      @required startDownload,
      loading}) async {
    try {
      int downloadedLength = 0;
      downloadProgress.value = 0;
      List<int> dataStore = [];

      //>> If file exists, avoid downloading again
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

      //>> Google Drive Set Up
      var drive = _initializeHttpClientAndGDriveAPI();
      String fileID = note.GDriveID;

      //>> Initialization for Download
      ga.Media file = await drive.files
          .get(fileID, downloadOptions: ga.DownloadOptions.fullMedia);

      //*Figure out size from note.size property to show proper loading indicator
      double contentLength =
          double.parse(note.size == null ? '0.0' : note.size.split(" ")[0]);
      contentLength = note.size == null
          ? 0
          : note.size.split(" ")[1] == 'KB'
              ? contentLength * 1000
              : contentLength * 1000000;

      //>> Start the download
      file.stream.listen((data) {
        downloadedLength += data.length;
        downloadProgress.value = ((downloadedLength / contentLength) * 100);
        loading.value = downloadProgress.value;
        print(downloadProgress.value);
        dataStore.insertAll(dataStore.length, data);
      }, onDone: () async {
        localFile = File(filePath);
        await localFile.writeAsBytes(dataStore);
        _insertBookmarks(filePath, note);
        Download downloadObject = Download(
          id: note.id,
          path: filePath,
          author: note.author,
          view: note.view,
          size: note.size,
          subjectName: note.subjectName,
          title: note.title,
          uploadDate: note.uploadDate,
        );
        //  note.id,
        //   filePath,
        //   note.title,
        //   note.subjectName,
        //   note.author,
        //   note.view,
        //   note.pages,
        //   note.size,
        //   note.uploadDate,
        _downloadService.addDownload(download: downloadObject);
        await Future.delayed(Duration(seconds: 1));
        downloadProgress.value = 0;
        onDownloadedCallback(localFile.path, note);
      });
    } catch (e) {
      log.e(e.toString());
    }
  }

  Future downloadPuchasedPdf(
      {var note,
      Function(String, String) onDownloadedCallback,
      Function startDownload}) async {

    try {
      
      PermissionStatus status = await Permission.storage.request();
      log.e(status.isGranted);
      int downloadedLength = 0;
      downloadProgress.value = 0;
      List<int> dataStore = [];

      startDownload();

      //*Google Drive Set Up
      ga.DriveApi drive = await _initializeHttpClientAndGDriveAPI();
      print(drive);

      //>> Download file
      String fileID = note.GDriveID;
      ga.Media file = await drive.files
          .get(fileID, downloadOptions: ga.DownloadOptions.fullMedia);
      var dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS)+ "/OUNotes/" + note.subjectName + "/" + note.type.replaceAll(' ', '') + "/";
      _createPath(dir);

      String fileName = "${note.subjectName}_${note.title}.pdf";
      String filePath = dir + fileName;
      log.e(filePath);           
      //*Figure out size from note.size property to show proper loading indicator
      File localFile;
      double contentLength;
      if (note.size != null){
        contentLength = double.parse(note.size.split(" ")[0]);
        contentLength = note.size?.split(" ")[1] == 'KB'
            ? contentLength * 1000
            : contentLength * 1000000;
        log.e("Size in numbers : " + contentLength.toString());
      }else{
        contentLength = 0.0;
      }

      //*Start the download
      file.stream.listen((data) {
        downloadedLength += data.length;
        downloadProgress.value = (downloadedLength / contentLength) * 100;
        // log.e(downloadedLength);
        // log.e(contentLength);
        print("loading.. : " + downloadProgress.value.toString());
        // if(downloadProgress.value < 1)
        // EasyLoading.showProgress(downloadProgress.value, status: 'downloading...');
        dataStore.insertAll(dataStore.length, data);
      }, onDone: () async {
        // EasyLoading.dismiss();
        localFile = File(filePath);
        await localFile.writeAsBytes(dataStore);
        await Future.delayed(Duration(seconds: 1));
        await onDownloadedCallback(localFile.path, fileName);
        log.e("DOWNLOAD DONE");
        downloadProgress.value = 0;
      });

    } catch (e) {
      print("error");
      log.e(e);
    }
  }

//This function is used to upload verified documents that are in Firebase, to Google Drive
  uploadFileToGoogleDriveAfterVerification(
      File fileToUpload, Document docEnum, doc) async {
    try {
      ga.File gDriveFileToUpload;
      ga.File response;
      String subjectSubFolderID;
      AbstractDocument note = doc;

      //>> 1.4 Compress PDF
      fileToUpload = await _compressPDF(fileToCompress: fileToUpload);

      //>> 1.5 Upload to Google Drive
      log.i("Uploading File to Google Drive");

      try {
        //>> 1.5.1 initialize http client and GDrive API
        var drive = _initializeHttpClientAndGDriveAPI();
        subjectSubFolderID =
            _getSubjectFolderID(subjectName: doc.subjectName, docEnum: docEnum);
        gDriveFileToUpload = _setMetadataToGDriveFile(
            gDriveFileToUpload, subjectSubFolderID, doc);

        //>> 1.5.3 Commence Upload
        log.e(fileToUpload);
        response = await drive.files.create(
          gDriveFileToUpload,
          uploadMedia:
              ga.Media(fileToUpload.openRead(), fileToUpload.lengthSync()),
        );

        ///>> 1.5.4 Create and Set Data to access the uploaded file
        _setDataForUploadedFile(
            response, subjectSubFolderID, docEnum, doc, note, fileToUpload);
      } catch (e) {
        return _errorHandling(
            e, "While UPLOADING Notes to Google Drive , Error occurred");
      }

      //>> Post-Upload Sanitization and finishing touches
      // pdf.dispose();
      fileToUpload.delete();
      return "Upload Successful";
    } catch (e) {
      log.e(e);
    }
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
