part of './../firestore_service.dart';

extension FirestoreFunctions on FirestoreService{

  // All switch cases

  _getCollectionReferenceAccordingToType(Document path, id) {
    switch (path) {
      case Document.Notes:
        return _subjectsCollectionReference
            .doc(id.toString())
            .collection(Constants.firebase_notes);
        break;
      case Document.QuestionPapers:
        return _subjectsCollectionReference
            .doc(id.toString())
            .collection(Constants.firebase_questionPapers);
        break;
      case Document.Syllabus:
        return _subjectsCollectionReference
            .doc(id.toString())
            .collection(Constants.firebase_syllabus);
        break;
      case Document.Links:
        return _subjectsCollectionReference
            .doc(id.toString())
            .collection(Constants.firebase_links);
        break;
      case Document.None:
      case Document.Report:
      case Document.UploadLog:
      case Document.Drawer:
      case Document.Random:
        break;
    }
  }

  _getCollectionReferenceAccordingToTypeForTempUpload(Document path) {
    switch (path) {
      case Document.Notes:
        return _notesCollectionReference;
        break;
      case Document.QuestionPapers:
        return _questionPapersCollectionReference;
        break;
      case Document.Syllabus:
        return _syllabusCollectionReference;
        break;
      case Document.Links:
        return _linksCollectionReference;
        break;
      case Document.None:
      case Document.Report:
      case Document.UploadLog:
      case Document.Drawer:
      case Document.Random:
        break;
    }
  }

  updateDocument(dynamic doc, Document document) async {
    switch (document) {
      case Document.Notes:
        await this.updateNoteInFirebase(doc);
        break;
      case Document.QuestionPapers:
        await this.updateQuestionPaperInFirebase(doc);
        break;
      case Document.Syllabus:
        await this.updateSyllabusInFirebase(doc);
        break;
      case Document.Links:
        await this.updateLinkInFirebase(doc);
        break;
      case Document.UploadLog:
        await this.updateUploadLogInFirebase(doc);
        break;
      case Document.Report:
        await this.updateReportInFirebase(doc);
        break;
      default:
        break;
    }
  }

  getDocumentById(String subjectName,String id, Document document) async {
    if(id == null){log.e("getDocumentById called with null id");return;}
    SubjectsService _subjectsService = locator<SubjectsService>();
    Subject subject = _subjectsService.getSubjectByName(subjectName);
    switch (document) {
      case Document.Notes:
        return await this.getNoteById(subject.id, id);
        break;
      case Document.QuestionPapers:
        return await this.getQuestionPaperById(subject.id, id);
        break;
      case Document.Syllabus:
        return await this.getSyllabusById(subject.id, id);
        break;
      case Document.Links:
        return await this.getLinkById(subject.id, id);
        break;
      case Document.UploadLog:
        return await this.getUploadLogById(id);
        break;
      default:
        break;
    }
  }

  deleteTempDocumentById(String id, Document document) async {
    if(id == null){log.e("getDocumentById called with null id");return;}
    switch (document) {
      case Document.Notes:
        return await _notesCollectionReference.doc(id).delete();
        break;
      case Document.QuestionPapers:
        return await _questionPapersCollectionReference.doc(id).delete();
        break;
      case Document.Syllabus:
        return await _syllabusCollectionReference.doc(id).delete();
        break;
      case Document.Links:
        return await _linksCollectionReference.doc(id).delete();
        break;
      case Document.UploadLog:
        return await _uploadLogCollectionReference.doc(id).delete();
        break;
    case Document.Report:
        return await _reportCollectionReference.doc(id).delete();
        break;
      default:
        break;
    }
  }


  // All Functions
  
  Future<Map<String, dynamic>> createUploadLog(AbstractDocument note, [User user]) async {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    User user = await _authenticationService.getUser();
    Map<String, dynamic> uploadLog = {
      if(user.username!=null)"uploader_name"            : user.username,
      if(user.id!=null)"uploader_id"                    : user.id,
      if(note.id!=null)"id"                             : note.id,
      if(note.subjectName!=null)"subjectName"           : note.subjectName,
      if(note.type!=null)"type"                         : note.type,
      if(note.title!=null)"fileName"                    : note.title,
      "uploadedAt"                                      : DateTime.now(),
      if(_authenticationService.user.email!=null)"email": _authenticationService.user.email,
      if(note.size!=null)"size"                         : note.size,
    };
    // _analyticsService.sendNotification(
    //     isAdmin: true,
    //     message: Strings.admin_document_upload_notification_message,
    //     title: Strings.admin_document_upload_notification_title);
    return uploadLog;
  }

  Map<String, dynamic> _linkUploadLog(Link note, User user) {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    Map<String, dynamic> uploadLog = {
      "uploader_id": user.id,
      "id": note.id,
      "subjectName": note.subjectName,
      "type": Constants.links,
      "fileName": note.title,
      "uploadedAt": DateTime.now(),
      //todo
      // "email": _authenticationService.user.email,
      "size": 0,
    };
    _analyticsService.logEvent(
        name: "UPLOAD_LINK",
        parameters: uploadLog,
        addInNotificationService: true);
    // _analyticsService.sendNotification(
    //     isAdmin: true,
    //     message: Strings.admin_document_upload_notification_message,
    //     title: Strings.admin_document_upload_notification_title);
    return uploadLog;
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
