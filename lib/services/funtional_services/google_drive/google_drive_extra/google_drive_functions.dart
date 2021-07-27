part of './../google_drive_service.dart';

extension GoogleDriveFunctions on GoogleDriveService{
  
  
  
  
  void _logValuesToConsole(AbstractDocument note,type) {
    // Log values to console
    log.i("Values recieved to upload the file :");
    log.i("notesName : ${note.title}");
    log.i("Subject Name : ${note.subjectName}");
    log.i("Type : $type");
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
    }
    return null;
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
}

