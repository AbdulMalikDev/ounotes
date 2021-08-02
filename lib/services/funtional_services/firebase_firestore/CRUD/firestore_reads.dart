part of './../firestore_service.dart';

extension FirestoreReads on FirestoreService {
  areUsersAllowed() async {
    bool areUsersAllowedToUpload = true;
    QuerySnapshot snapshot = await _confidentialCollectionReference.get();
    snapshot.docs.forEach((doc) {
      areUsersAllowedToUpload =
          (doc.data() as Map)["areUsersAllowedToUpload"] ?? true;
    });
    log.w("Users allowed to upload : $areUsersAllowedToUpload");
    return areUsersAllowedToUpload;
  }

  Future<Map<String, dynamic>> getUserStats() async {
    DocumentSnapshot doc =
        await _usersCollectionReference.doc(Constants.userStats).get();
    return doc.data();
  }

  Future<User> refreshUser() async {
    User user = await _sharedPreferencesService.getUser();
    DocumentSnapshot doc = await _usersCollectionReference.doc(user.id).get();
    User newUser = User.fromData(doc.data());
    _sharedPreferencesService.saveUserLocally(newUser);
    return newUser;
  }

  loadSubjectsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _subjectsCollectionReference.get();
      List<Subject> subjects =
          snapshot.docs.map((doc) => Subject.fromData(doc.data())).toList();
      subjects.removeWhere((sub) => sub.name == null.toString());
      subjects.removeWhere((sub) => sub.name == null.toString().toUpperCase());
      return subjects;
    } catch (e) {
      _errorHandling(
          e, "While retreiving Subjects from Firebase , Error occurred");
      return 'error';
    }
  }

  loadNotesFromFirebase(String subjectName) async {
    try {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(subjectName);
      // QuerySnapshot snapshot = await _notesCollectionReference
      //     .where('subjectName', isEqualTo: subjectName)
      //     .orderBy('votes', descending: true)
      //     .get();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .doc(subject.id.toString())
          .collection(Constants.firebase_notes)
          .orderBy('votes', descending: true)
          .get();
      List<Note> notes = snapshot.docs
          .map((doc) => Note.fromData(doc.data(), doc.id))
          .toList();
      _notesService.setNotes = notes;
      Map<String, int> noOfVotes = {};
      notes.forEach((note) {
        noOfVotes[note.title] = note.votes;
      });

      return notes;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving Notes from Firebase , Error occurred");
    }
  }

  loadQuestionPapersFromFirebase(String subjectName) async {
    try {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(subjectName);
      // QuerySnapshot snapshot = await _questionPapersCollectionReference
      //     .where('subjectName', isEqualTo: subjectName)
      //     .orderBy("year", descending: true)
      //     .get();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .doc(subject.id.toString())
          .collection(Constants.firebase_questionPapers)
          .orderBy("year", descending: true)
          .get();
      List<QuestionPaper> questionPapers = snapshot.docs
          .map((doc) => QuestionPaper.fromData(doc.data()))
          .toList();
      // questionPapers.forEach((element) {log.e(element.url);});
      _questionPaperService.setQuestionPapers = questionPapers;
      return questionPapers;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving QuestionPapers from Firebase , Error occurred");
    }
  }

  loadSyllabusFromFirebase(String subjectName) async {
    try {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(subjectName);
      // QuerySnapshot snapshot = await _syllabusCollectionReference
      //     .where('subjectName', isEqualTo: subjectName)
      //     .get();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .doc(subject.id.toString())
          .collection(Constants.firebase_syllabus)
          .get();
      List<Syllabus> syllabus =
          snapshot.docs.map((doc) => Syllabus.fromData(doc.data())).toList();
      _syllabusService.setSyllabus = syllabus;
      return syllabus;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving Notes from Firebase , Error occurred");
    }
  }

  loadLinksFromFirebase(String subjectName) async {
    try {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(subjectName);
      // QuerySnapshot snapshot = await _linksCollectionReference
      //     .where('subjectName', isEqualTo: subjectName)
      //     .get();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .doc(subject.id.toString())
          .collection(Constants.firebase_links)
          .get();
      List<Link> links =
          snapshot.docs.map((doc) => Link.fromData(doc.data())).toList();
      _linksService.setLinks = links;
      return links;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving Notes from Firebase , Error occurred");
    }
  }

  loadReportsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _reportCollectionReference
          .orderBy("date", descending: true)
          .get();
      List<Report> reports =
          snapshot.docs.map((doc) => Report.fromData(doc.data())).toList();
      return reports;
    } catch (e) {
      return _errorHandling(e,
          "While retreiving REPORTS FOR ADMIN from Firebase , Error occurred");
    }
  }

  loadUploadLogFromFirebase({bool isAdmin = false}) async {
    try {
      QuerySnapshot snapshot; 
      
      if(isAdmin){
      snapshot = await _uploadLogCollectionReference
          .orderBy("uploadedAt", descending: true)
          .where("isVerifierVerified",isEqualTo: true)
          .where("isAdminVerified",isEqualTo: false)
          .get();
      }else{
        snapshot = await _uploadLogCollectionReference
          .orderBy("uploadedAt", descending: true)
          .get();
      }
      log.e(snapshot.docs.length);
      List<UploadLog> uploadLogs = snapshot.docs
          .map((doc) => UploadLog.fromData(doc.data()))
          .toList();
      log.e(uploadLogs);
      return uploadLogs;
    } catch (e) {
      return _errorHandling(e,
          "While retreiving UPLOADLOGS FOR ADMIN from Firebase , Error occurred");
    }
  }

  Future<Note> getNoteById(int subId, String id) async {
    // DocumentSnapshot doc = await _subjectsCollectionReference
    //       .doc(subId.toString())
    //       .collection(Constants.firebase_notes)
    //       .doc(id).get();
    QuerySnapshot docSnaps = await FirebaseFirestore.instance
        .collectionGroup(Constants.firebase_notes)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> docs = docSnaps.docs;
    if (docs.isEmpty) return null;
    DocumentSnapshot doc = docs[docs.length - 1];
    if (!doc.exists) return null;
    return Note.fromData(doc.data(), doc.id);
  }

  Future<Link> getLinkById(int subId, String id) async {
    // DocumentSnapshot doc = await _subjectsCollectionReference
    //       .doc(subId.toString())
    //       .collection(Constants.firebase_links)
    //       .doc(id).get();
    QuerySnapshot docSnaps = await FirebaseFirestore.instance
        .collectionGroup(Constants.firebase_links)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> docs = docSnaps.docs;
    if (docs.isEmpty) return null;
    DocumentSnapshot doc = docs[docs.length - 1];
    return Link.fromData(doc.data());
  }

  Future<QuestionPaper> getQuestionPaperById(int subId, String id) async {
    //  DocumentSnapshot doc = await _subjectsCollectionReference
    //         .doc(subId.toString())
    //         .collection(Constants.firebase_questionPapers)
    //         .doc(id).get();
    QuerySnapshot docSnaps = await FirebaseFirestore.instance
        .collectionGroup(Constants.firebase_questionPapers)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> docs = docSnaps.docs;
    if (docs.isEmpty) return null;
    DocumentSnapshot doc = docs[docs.length - 1];
    return QuestionPaper.fromData(doc.data());
  }

  Future<Syllabus> getSyllabusById(int subId, String id) async {
    // DocumentSnapshot doc = await _subjectsCollectionReference
    //       .doc(subId.toString())
    //       .collection(Constants.firebase_syllabus)
    //       .doc(id).get();
    QuerySnapshot docSnaps = await FirebaseFirestore.instance
        .collectionGroup(Constants.firebase_syllabus)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> docs = docSnaps.docs;
    if (docs.isEmpty) return null;
    DocumentSnapshot doc = docs[docs.length - 1];
    return Syllabus.fromData(doc.data());
  }

  Future<User> getUserById(String id) async {
    DocumentSnapshot doc = await _usersCollectionReference.doc(id).get();
    return User.fromData(doc.data());
  }

  Future<User> getUserByEmail(String email) async {
    log.i("Retreiving user with email : " + email);
    QuerySnapshot snapshot = await _usersCollectionReference.where("email",isEqualTo: email).get();
    return User.fromData(snapshot.docs[0].data());
  }

  Future<UploadLog> getUploadLogById(String id) async => UploadLog.fromData((await _uploadLogCollectionReference.doc(id).get()).data());

}
