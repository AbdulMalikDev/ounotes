import 'dart:io';
import 'dart:math' as math;

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:FSOUNotes/utils/file_picker_service.dart';
import 'package:cuid/cuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

@lazySingleton
class CloudStorageService {
  FilePickerService _filePickerService = locator<FilePickerService>();
  NotesService _notesService = locator<NotesService>();
  QuestionPaperService _questionPaperService = locator<QuestionPaperService>();
  SyllabusService _syllabusService = locator<SyllabusService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  DownloadService _downloadService = locator<DownloadService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  Logger log = getLogger("CloudStorageService");
  final String url =
      "https://storage.googleapis.com/ou-notes.appspot.com/pdfs/";
  StorageReference _storageReference = FirebaseStorage.instance.ref();
  StorageUploadTask _storageUploadTask;
  StorageTaskSnapshot _storageTaskSnapshot;

  downloadFile({
    String notesName,
    String subName,
    String type,
    AbstractDocument note,
  }) async {
    log.i("notesName : $notesName");
    log.i("Subject Name : $subName");
    log.i("Type : $type");
    try {
      String fileUrl =
          "https://storage.googleapis.com/ou-notes.appspot.com/pdfs/$subName/$type/$notesName";
      log.i(Uri.parse(fileUrl));
      //final filename = fileUrl.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(fileUrl));
      var response = await request.close();
      log.w("downloading");
      var bytes = await consolidateHttpClientResponseBytes(
        response,
        // onBytesReceived: (bytesReceived, expectedContentLength) {
        //   if (expectedContentLength != null) {
        //     log.w("downloading" +
        //         (bytesReceived / expectedContentLength * 100)
        //             .toStringAsFixed(0) +
        //         "%");
        //   }
        // },
      );

      String dir = (await getApplicationDocumentsDirectory()).path;
      String id = newCuid();
      if (note.id == null || note.id.length == 0) {
        note.setId = id;
      }
      note.setIsDownloaded = true;
      File file = new File('$dir/$id');
      await file.writeAsBytes(bytes);
      log.i("file path: ${file.path}");
      return file.path;
    } catch (e) {
      log.e("While retreiving Notes from Firebase STORAGE , Error occurred");
      String error;
      if (e is PlatformException) error = e.message;
      error = e.toString();
      log.e(error);
      return "error";
    }
  }

  deleteContent(String path) async {
    try {
      // final dir = await _localPath;
      final file = File('$path');
      file.deleteSync(recursive: true);
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }

  uploadFile({
    String type,
    AbstractDocument note,
    String uploadFileType,
  }) async {

    bool result1 = await _firestoreService.areUsersAllowed();
    bool result2 =
        await _firestoreService.refreshUser().then((user) => user.isUserAllowedToUpload);
    if (!result1 || !result2) {
      return "BLOCKED";
    }

    //Log values to console
    log.i("Values recieved to upload the file :");
    log.i("notesName : ${note.title}");
    log.i("Subject Name : ${note.subjectName}");
    log.i("Type : $type");
    
    try {
      //*Select file and sanitize extension
      PdfDocument pdf;
      //Not defining type since it could be List of files or just one file
      final document = await _filePickerService.selectFile(uploadFileType:uploadFileType);
      if(document==null)return "File is null";
      bool isImage = (document.runtimeType.toString() == "List<File>");
      String docPath = isImage ? document[0].path : document.path; 
      String mimeStr = lookupMimeType(docPath);
      var fileType = mimeStr.split('/').last;
      if (!['pdf','jpg','jpeg','png'].contains(fileType)) {
        return 'file is not compatible. Please make sure you uploaded a PDF';
      }else if(['jpg','jpeg','png'].contains(fileType)){
        pdf = _convertImageToPdf(document);
      }else{
        pdf = PdfDocument(inputBytes: document.readAsBytesSync(),);
      }

      //*Find the size of the file and make sure it's not more than 35 MB
      int lengthOfDoc = isImage ? await _getLengthOfImages(document) : await document.length(); 
      final String bytes = _formatBytes2(lengthOfDoc, 2);
      final String bytesuffix = _formatBytes2Suffix(lengthOfDoc, 2);
      log.i("suffix of size" + bytesuffix);
      log.i("size of file" + bytes);
      var suffix = ["MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      if (double.parse(bytes) > 35 && suffix.contains(bytesuffix)) {
        return "File size more than 35mb";
      }
      
      //*Save file to upload
      File fileToUpload = isImage ? null : document; 
      if(fileToUpload==null)fileToUpload = await new File((await _localPath)+"/${DateTime.now().millisecondsSinceEpoch}").writeAsBytes(document.save());
      
      //*Show document to user
      //TODO WAJID bookmarks and units covered logic will be displayed when user is taken to pdf screen, 
      //! add it in the pdf screen, after user put info, just pop the pdf screen, it will come back to this function
      await _navigationService.navigateTo(Routes.pdfScreenRoute,arguments: PDFScreenArguments(doc: note,pathPDF:fileToUpload.path,askBookMarks: true));
      
      //*Set info on document and upload
      String fileName = assignFileName(note);
      note.setTitle = fileName;
      StorageUploadTask uploadTask = _storageReference
          .child("pdfs/${note.subjectName}/$type/$fileName")
          .putFile(fileToUpload);
      log.i("url : pdfs/${note.subjectName}/$type/$fileName");

      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();

      final metaData = await storageSnap.ref.getMetadata();
      final sizeInBytes = metaData.sizeBytes;
      final uploadedOn = metaData.creationTimeMillis;
      final String size = _formatBytes(sizeInBytes, 2);
      log.w("Document uploaded has size $size");
      DateTime upload = DateTime.fromMillisecondsSinceEpoch(uploadedOn);
      note.setUrl = downloadUrl;
      note.setSize = size;
      note.setDate = upload;
      note.setPages = pdf.pages.count;

      pdf.dispose();
      fileToUpload.delete();
      _firestoreService.saveNotes(note);
      return "upload successful";

    } catch (e) {
      log.e("While UPLOADING Notes from Firebase STORAGE , Error occurred");
      String error;
      if (e is PlatformException) error = e.message;
      error = e.toString();
      log.e(error);
      return "error";
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String assignFileName(AbstractDocument doc) {
    switch (doc.path) {
      case Document.Notes:
        return _notesService.assignNameToNotes(title: doc.title);
        break;
      case Document.QuestionPapers:
        return _questionPaperService.assignNameToQuestionPaper(
            title: doc.title);
        break;
      case Document.Syllabus:
        return _syllabusService.assignNameToSyllabus(title: doc.title);
        break;
      case Document.Links:
        return null;
        break;
      case Document.None:
      case Document.Report:
      case Document.UploadLog:
      case Document.Drawer:
        return null;
        break;
    }
    return null;
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  _formatBytes2(int bytes, int decimals) {
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals));
  }

  _formatBytes2Suffix(int bytes, int decimals) {
    var i = (math.log(bytes) / math.log(1024)).floor();
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    return suffixes[i];
  }

  Future deleteDocument(AbstractDocument doc,{bool addedToGdrive = false}) async {
    //Delete from storage
    try {
      //Delete from firebase if not added to Gdrive
      if (!addedToGdrive)
      {
          await _firestoreService.deleteDocument(doc);
      }
      StorageReference docRef = _storageReference
          .child("pdfs/${doc.subjectName}/${doc.type}/${doc.title}");
      log.e("pdfs/${doc.subjectName}/${doc.type}/${doc.title} DELETED");
      await docRef.delete();


    } catch (e) {
      return _errorHandling(
          e, "While deleting document in FIREBASE STORAGE , Error occurred");
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

  PdfDocument _convertImageToPdf(List<File> documents) {
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    documents.forEach((file) { 

      //Adds a page to the document
      PdfPage page = document.pages.add();

      //Draw the image
      page.graphics.drawImage(
          PdfBitmap(file.readAsBytesSync()),
          Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height)
      );
    
    });

    return document;
  }

  _getLengthOfImages(List<File> documents) async {
    int totalLength = 0;
    documents.forEach((doc) async {
      totalLength += (await doc.length());
    });
    return totalLength;
  }
}
