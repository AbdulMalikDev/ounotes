part of './../google_drive_service.dart';

extension GoogleDriveFunctions on GoogleDriveService{

  void _setDataForUploadedFile(ga.File response,String subjectSubFolderID,Document docEnum,doc,note,fileToUpload) async {
      String GDrive_URL =
          "https://drive.google.com/file/d/${response.id}/view?usp=sharing";
      log.w("GDrive Link : " + GDrive_URL);
      doc = _setLinkToDocument(
          doc, GDrive_URL, response.id, subjectSubFolderID, docEnum);
      log.w(doc.toJson());
      //>> Set Metadata of the file to store in Database
      String fileName = assignFileName(note);
      note.setTitle = fileName;
      note.setUrl = GDrive_URL;
      note.setSize = _formatBytes(fileToUpload.lengthSync(), 2);
      note.setDate = DateTime.now();
      // note.setPages = pdf.pages.count;
      log.e(note.toJson());
      // update in firestore with GDrive Link
      await _firestoreService.updateDocument(doc, docEnum);
  }

  Future<File> _compressPDF({File fileToCompress}) async {
    String outputPath = await getOutputPath();
    log.e(outputPath);
    await PdfCompressor.compressPdfFile(fileToCompress.path, outputPath, CompressQuality.MEDIUM);
    fileToCompress = File(outputPath);
    return fileToCompress;
  }

  ga.File _setMetadataToGDriveFile(ga.File gDriveFileToUpload,subjectSubFolderID,doc) {
    gDriveFileToUpload = ga.File();
    gDriveFileToUpload.parents = [subjectSubFolderID];
    gDriveFileToUpload.name = doc.title;
    gDriveFileToUpload.copyRequiresWriterPermission = true;
    return gDriveFileToUpload;
  }

  _initializeHttpClientAndGDriveAPI() async {
    final accountCredentials = new ServiceAccountCredentials.fromJson(
        _remote.remoteConfig.getString("GDRIVE"));
    final scopes = ['https://www.googleapis.com/auth/drive'];
    AutoRefreshingAuthClient gdriveAuthClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    return ga.DriveApi(gdriveAuthClient);
    
  }

  /// Creates [Path] if does not exist in external storage
  _createPath(String dir) async {
    final path = Directory(dir);
    log.e(await path.exists());
    if (!(await path.exists())){
      var result = await path.create(recursive: true);
    }
  }

  _getSubjectFolderID({String subjectName,Document docEnum}){
    Subject subject = _subjectsService.getSubjectByName(subjectName);
    String subjectSubFolderID = _getFolderIDForType(subject, docEnum);
    if (subject == null) {
      log.e("Subject is Null");
      return "";
    }
    return subjectSubFolderID;
  }

  _errorHandling(e, String message) async {
    log.e(message);
    String error;
    if (e is PlatformException) error = e.message;
    error = e.toString();
    log.e(error);
    if ((await _authenticationService.getUser()).isAdmin)
      _bottomSheetService.showBottomSheet(title: "Error", description: error);
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
 
  
  void _logValuesToConsole(AbstractDocument note,type) {
    // Log values to console
    log.i("Values recieved to upload the file :");
    log.i("notesName : ${note.title}");
    log.i("notesId : ${note.id}");
    log.i("Subject Name : ${note.subjectName}");
    log.i("Type : $type");
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> getOutputPath() async {
    var dir = await getExternalStorageDirectory();
    await new Directory('${dir.path}/CompressPdfs').create(recursive: true);

    String randomString = getRandomString(10);
    String pdfFileName = '$randomString.pdf';
    return '${dir.path}/CompressPdfs/$pdfFileName';
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

   Future<int> _getLengthOfImages(List<File> documents) async {
    int totalLength = 0;
    for (File doc in documents) {
      totalLength += (await doc.length());
    }
    return totalLength;
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
      case Document.Random:
        return null;
        break;
      case Document.GDRIVE:
        break;
    }
    return null;
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

  Stream<List<int>> _convertToStream(Uint8List uint8List){
    final sw1 = Stopwatch()..start();
    final result1 = Stream.value(
      List<int>.from(uint8List),
    );
    sw1.stop();
    print('case1: ${sw1.elapsedMicroseconds} µs');

    final sw2 = Stopwatch()..start();
    final result2 = Stream.value(
      uint8List.map((e) => [e]),
    );
    sw2.stop();
    print('case2: ${sw2.elapsedMicroseconds} µs');


    final sw3 = Stopwatch()..start();
    final result3 = Stream.fromIterable(
      uint8List.map((e) => [e]),
    );
    sw3.stop();
    print('case3: ${sw2.elapsedMicroseconds} µs');

    return result1;
    
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

