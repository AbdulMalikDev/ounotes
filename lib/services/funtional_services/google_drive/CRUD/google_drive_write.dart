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
      bool largerSizeThanAllowed = double.parse(bytes) > 35 && suffix.contains(bytesuffix);

      //>> 1.3 Verify intent of File Upload with user to make sure 
      //>>     they haven't uploaded the wrong file by mistake
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

      //>> 1.4 Compress PDF (only if it is notes)
      if(largerSizeThanAllowed){

        if(docEnum != Document.Notes){
          Fluttertoast.showToast(msg:"File size too large!");
          return;
        }
        String outputPath = await getOutputPath();
        await PdfCompressor.compressPdfFile(
            docPath, outputPath, CompressQuality.MEDIUM);
        fileToUpload = File(outputPath);
        Fluttertoast.showToast(msg: "File Size too large! compressing document... This may decrease quality.",toastLength: Toast.LENGTH_LONG);
        
      }

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
