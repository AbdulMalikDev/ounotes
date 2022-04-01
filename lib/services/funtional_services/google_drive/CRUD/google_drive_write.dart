part of './../google_drive_service.dart';

extension GoogleDriveWrites on GoogleDriveService{

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
    @required AbstractDocument abstractDoc,
    @required PdfWeb pdfDocument,
    String uploadFileType = Constants.pdf,
  }) async {
    log.v("Uploading file to Google Drive");

    //Variables
    bool isImage;
    String docPath;
    PdfDocument pdf;
    ga.File response;
    String GDrive_URL;
    List<PdfDocument> pdfs;
    ga.File gDriveFileToUpload;
    String type = abstractDoc.type;
    Document docEnum = abstractDoc.path;

    /// TODO
    /// handle return of string

    //>> Pre-Upload Check
    bool result1 = await _firestoreService.areUsersAllowed();
    bool result2 = await _firestoreService
        .refreshUser()
        .then((user) => user.isUserAllowedToUpload);
    if (!result1 || !result2) {
      return "BLOCKED";
    }
    _logValuesToConsole(abstractDoc, type);

    //>> 1. Initiate Upload Logic
    try {

      log.e("Checkpoint");
      //>> 1.2 Find size of file, make sure not more than 35 MB
      int lengthOfDoc = await pdfDocument.bytes.length;
      log.e("lengthOfDoc : " + lengthOfDoc.toString());
      final String bytes = _formatBytes2(lengthOfDoc, 2);
      final String bytesuffix = _formatBytes2Suffix(lengthOfDoc, 2);
      log.i("suffix of size" + bytesuffix);
      log.i("size of file" + bytes);
      var suffix = ["MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      bool largerSizeThanAllowed = double.parse(bytes) > 35 && suffix.contains(bytesuffix);
      log.e("Checkpoint");

      //>> 1.4 Compress PDF (only if it is notes)
      //* not implemented on web

      //>> 1.5 Upload to Google Drive
      log.i("Uploading File to Google Drive");
      log.i(abstractDoc);
      log.i(pdfDocument);

      try {
        //>> 1.5.1 initialize http client and GDrive API
        log.e("Checkpoint");
        final accountCredentials = new ServiceAccountCredentials.fromJson(
            _remote.remoteConfig.getString("GDRIVE"));
        final scopes = ['https://www.googleapis.com/auth/drive'];
        AutoRefreshingAuthClient gdriveAuthClient =
            await clientViaServiceAccount(accountCredentials, scopes);
        var drive = ga.DriveApi(gdriveAuthClient);
        Subject subject = _subjectsService.getSubjectByName(abstractDoc.subjectName);
        String subjectSubFolderID = _getFolderIDForType(subject, docEnum);
        if (subject == null) {
          log.e("Subject is Null");
          return;
        }
        log.e("Checkpoint");

        //>> 1.5.2 Set metadata for the GDrive File
        log.e("Checkpoint");
        try {
          gDriveFileToUpload = ga.File();
          gDriveFileToUpload.parents = [subjectSubFolderID];
          gDriveFileToUpload.name = abstractDoc.title;
          gDriveFileToUpload.copyRequiresWriterPermission = true;
          
        } catch (e) {
          log.e(e.toString());
          log.e("error here");
          return;
        }

        //>> 1.5.3 Commence Upload
        // log.e(fileToUpload);
        log.e("Checkpoint");
        log.e(pdfDocument);
        // log.e(document.readStream);
        Stream<List<int>> filestream = _convertToStream(pdfDocument.bytes);
        response = await drive.files.create(
          gDriveFileToUpload,
          uploadMedia:
              ga.Media(filestream, pdfDocument.bytes.length),
        );

        ///>> 1.5.4 Create and Set Data to access the uploaded file
        GDrive_URL =
            "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
        log.w("GDrive Link : " + GDrive_URL);
        abstractDoc = _setLinkToDocument(
            abstractDoc, GDrive_URL, response.id, subjectSubFolderID, docEnum);
        log.w(abstractDoc.toJson());
        log.e("Checkpoint");

      } catch (e) {
        return _errorHandling(
            e, "While UPLOADING Notes to Google Drive , Error occurred");
      }

      //>> 1.6 Set Metadata of the file to store in Database
      log.e("Checkpoint");
      String fileName = assignFileName(abstractDoc);
      abstractDoc.setTitle = fileName;
      abstractDoc.setUrl = GDrive_URL;
      abstractDoc.setSize = _formatBytes(pdfDocument.bytes.length, 2);
      abstractDoc.setDate = DateTime.now();
      // abstractDoc.setPages = pdf.pages.count;
      log.e(abstractDoc.toJson());
      log.e("Checkpoint");

      //>> Post-Upload Sanitization and finishing touches
      pdf.dispose();
      // fileToUpload.delete();
      _firestoreService.saveNotes(abstractDoc);
      log.e("UPLOAD SUCCESSFUL");
      return "Upload Successful";

    } catch (e) {
      return _errorHandling(
          e, "While UPLOADING Notes to Google Drive , Error occurred (outer)");
    }
  }

  /// Function to create Folders for a subject in Google Drive Account
  ///
  /// `@return values`
  ///
  ///   - [Subject] created
  ///
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

}

// legacy code 31 March 2022
// processFile({
//     @required AbstractDocument abstractDoc,
//     String uploadFileType = Constants.pdf,
//   }) async {
//     log.v("Uploading file to Google Drive");

//     //Variables
//     bool isImage;
//     String docPath;
//     PdfDocument pdf;
//     ga.File response;
//     String GDrive_URL;
//     List<PdfDocument> pdfs;
//     ga.File gDriveFileToUpload;
//     String type = abstractDoc.type;
//     Document docEnum = abstractDoc.path;

//     /// TODO
//     /// handle return of string

//     //>> Pre-Upload Check
//     bool result1 = await _firestoreService.areUsersAllowed();
//     bool result2 = await _firestoreService
//         .refreshUser()
//         .then((user) => user.isUserAllowedToUpload);
//     if (!result1 || !result2) {
//       return "BLOCKED";
//     }
//     _logValuesToConsole(abstractDoc, type);

//     //>> 1. Initiate Upload Logic
//     try {

//       //>> 1.1 Select file, sanitize extension and create a PDF Object
//       //Not defining type since it could be List of files or just one file
//       List<PlatformFile> files =
//           await _filePickerService.selectFile(uploadFileType: uploadFileType);
//       if (files == null || files.isEmpty){
//         Fluttertoast.showToast(msg: "FILES NOT SELECTED");
//         return;
//       }
//       PlatformFile document = files[0];
//       log.e("Checkpoint");
//       // String mimeStr = lookupMimeType(files[0].path);
//       // log.e("MimeType : " + mimeStr);
//       // var fileType = mimeStr.split('/').last;
//       //! Since only PDF file allowed in web
//       var fileType = 'pdf';
//       log.e("Checkpoint");
//       bool isValidExtension = ['pdf', 'jpg', 'jpeg', 'png'].contains(fileType);
//       if (!isValidExtension) {
//         return 'file is not compatible. Please make sure you uploaded a PDF';
//       } else if (['jpg', 'jpeg', 'png'].contains(fileType)) {
//         // pdf = await _pdfService.convertImageToPdf(document, tempPath);
//         Fluttertoast.showToast(msg: "IMAGES CONVERSION NOT AVAILABLE IN WEB");
//         return;
//       } else {
//       log.e("Checkpoint");
//         try{
//           // log.e(document.bytes);
//           // log.e(List<int>.from(document.bytes));
//           pdf = PdfDocument(
//             inputBytes: List<int>.from(document.bytes),
//           );

//         }catch(e){log.e(e.toString());}

//       }

//       log.e("Checkpoint");
//       //>> 1.2 Find size of file, make sure not more than 35 MB
//       int lengthOfDoc = await document.bytes.lengthInBytes;
//       log.e("lengthOfDoc : " + lengthOfDoc.toString());
//       final String bytes = _formatBytes2(lengthOfDoc, 2);
//       final String bytesuffix = _formatBytes2Suffix(lengthOfDoc, 2);
//       log.i("suffix of size" + bytesuffix);
//       log.i("size of file" + bytes);
//       var suffix = ["MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
//       bool largerSizeThanAllowed = double.parse(bytes) > 35 && suffix.contains(bytesuffix);
//       log.e("Checkpoint");

//       //>> 1.3 Verify intent of File Upload with user to make sure 
//       //>>     they haven't uploaded the wrong file by mistake
//       PlatformFile fileToUpload = document;
//       final validDocument = await _navigationService.navigateTo(
//         Routes.pDFScreen,
//         arguments: PDFScreenArguments(
//             doc: abstractDoc, bytes:document.bytes , isUploadingDoc: true),
//       );
//       log.i(validDocument);
//       if (!validDocument) {
//         return "Invalid document";
//       }

//       //>> 1.4 Compress PDF (only if it is notes)
//       if(largerSizeThanAllowed){
        
//         if(docEnum != Document.Notes){
//           Fluttertoast.showToast(msg:"File size too large!");
//           return;
//         }

//         log.e("Compressing file");
//         // String outputPath = await getOutputPath();
//         // await PdfCompressor.compressPdfFile(
//         //     docPath, outputPath, CompressQuality.MEDIUM);
//         fileToUpload = document;
//         await Fluttertoast.showToast(msg: "File Size too large! compressing document... This may decrease quality.",toastLength: Toast.LENGTH_LONG);
//         Fluttertoast.showToast(msg: "Cannot compress in web",toastLength: Toast.LENGTH_LONG);
        
//       }

//       //>> 1.5 Upload to Google Drive
//       log.i("Uploading File to Google Drive");
//       log.i(abstractDoc);
//       log.i(document);

//       try {
//         //>> 1.5.1 initialize http client and GDrive API
//         log.e("Checkpoint");
//         final accountCredentials = new ServiceAccountCredentials.fromJson(
//             _remote.remoteConfig.getString("GDRIVE"));
//         final scopes = ['https://www.googleapis.com/auth/drive'];
//         AutoRefreshingAuthClient gdriveAuthClient =
//             await clientViaServiceAccount(accountCredentials, scopes);
//         var drive = ga.DriveApi(gdriveAuthClient);
//         Subject subject = _subjectsService.getSubjectByName(abstractDoc.subjectName);
//         String subjectSubFolderID = _getFolderIDForType(subject, docEnum);
//         if (subject == null) {
//           log.e("Subject is Null");
//           return;
//         }
//         log.e("Checkpoint");

//         //>> 1.5.2 Set metadata for the GDrive File
//         log.e("Checkpoint");
//         try {
//           gDriveFileToUpload = ga.File();
//           gDriveFileToUpload.parents = [subjectSubFolderID];
//           gDriveFileToUpload.name = abstractDoc.title;
//           gDriveFileToUpload.copyRequiresWriterPermission = true;
          
//         } catch (e) {
//           log.e(e.toString());
//           log.e("error here");
//           return;
//         }

//         //>> 1.5.3 Commence Upload
//         // log.e(fileToUpload);
//         log.e("Checkpoint");
//         log.e(document);
//         // log.e(document.readStream);
//         Stream<List<int>> filestream = _convertToStream(document.bytes);
//         response = await drive.files.create(
//           gDriveFileToUpload,
//           uploadMedia:
//               ga.Media(filestream, document.bytes.lengthInBytes),
//         );

//         ///>> 1.5.4 Create and Set Data to access the uploaded file
//         GDrive_URL =
//             "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
//         log.w("GDrive Link : " + GDrive_URL);
//         abstractDoc = _setLinkToDocument(
//             abstractDoc, GDrive_URL, response.id, subjectSubFolderID, docEnum);
//         log.w(abstractDoc.toJson());
//         log.e("Checkpoint");

//       } catch (e) {
//         return _errorHandling(
//             e, "While UPLOADING Notes to Google Drive , Error occurred");
//       }

//       //>> 1.6 Set Metadata of the file to store in Database
//       log.e("Checkpoint");
//       String fileName = assignFileName(abstractDoc);
//       abstractDoc.setTitle = fileName;
//       abstractDoc.setUrl = GDrive_URL;
//       abstractDoc.setSize = _formatBytes(fileToUpload.bytes.lengthInBytes, 2);
//       abstractDoc.setDate = DateTime.now();
//       abstractDoc.setPages = pdf.pages.count;
//       log.e(abstractDoc.toJson());
//       log.e("Checkpoint");

//       //>> Post-Upload Sanitization and finishing touches
//       pdf.dispose();
//       // fileToUpload.delete();
//       _firestoreService.saveNotes(abstractDoc);
//       log.e("UPLOAD SUCCESSFUL");
//       return "Upload Successful";

//     } catch (e) {
//       return _errorHandling(
//           e, "While UPLOADING Notes to Google Drive , Error occurred (outer)");
//     }
//   }
