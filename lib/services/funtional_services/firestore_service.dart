import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/course_info.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/state_services/links_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuid/cuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class FirestoreService {
  Logger log = getLogger("FirestoreService");
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");
  final CollectionReference _subjectsCollectionReference =
      Firestore.instance.collection("Subjects");
  final CollectionReference _notesCollectionReference =
      Firestore.instance.collection("Notes");
  final CollectionReference _questionPapersCollectionReference =
      Firestore.instance.collection("QuestionPapers");
  final CollectionReference _syllabusCollectionReference =
      Firestore.instance.collection("Syllabus");
  final CollectionReference _linksCollectionReference =
      Firestore.instance.collection("Links");
  final CollectionReference _reportCollectionReference =
      Firestore.instance.collection("Report");
  final CollectionReference _confidentialCollectionReference =
      Firestore.instance.collection("confidential");
  final CollectionReference _uploadLogCollectionReference =
      Firestore.instance.collection("uploadLog");

  NotesService _notesService = locator<NotesService>();
  QuestionPaperService _questionPaperService = locator<QuestionPaperService>();
  SyllabusService _syllabusService = locator<SyllabusService>();
  LinksService _linksService = locator<LinksService>();

  AnalyticsService _analyticsService = locator<AnalyticsService>();
  

  _getCollectionReferenceAccordingToType(Document path) {
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
      case Document.Drawer:
        break;
    }
  }

  areUsersAllowed() async {
    bool areUsersAllowedToUpload = true;
    QuerySnapshot snapshot =
        await _confidentialCollectionReference.getDocuments();
    snapshot.documents.forEach((doc) {
      areUsersAllowedToUpload = doc.data["areUsersAllowedToUpload"] ?? true;
    });
    log.w("Users allowed to upload : $areUsersAllowedToUpload");
    return areUsersAllowedToUpload;
  }

  saveUser(Map<String, dynamic> data) async {
    try {
      await _usersCollectionReference.document(data["id"]).setData(data);
    } catch (e) {
      return _errorHandling(
          e, "While saving user to Firebase , Error occurred");
    }
  }

  loadSubjectsFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await _subjectsCollectionReference.getDocuments();
      List<Subject> subjects =
          snapshot.documents.map((doc) => Subject.fromData(doc.data)).toList();

      return subjects;
    } catch (e) {
      _errorHandling(
          e, "While retreiving Subjects from Firebase , Error occurred");
      return 'error';
    }
  }

  loadNotesFromFirebase(String subjectName) async {
    try {
      QuerySnapshot snapshot = await _notesCollectionReference
          .where('subjectName', isEqualTo: subjectName)
          .getDocuments();
      List<Note> notes =
          snapshot.documents.map((doc) => Note.fromData(doc.data,doc.documentID)).toList();
      _notesService.setNotes = notes;
      return notes;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving Notes from Firebase , Error occurred");
    }
  }

  loadQuestionPapersFromFirebase(String subjectName) async {
    try {
      QuerySnapshot snapshot = await _questionPapersCollectionReference
          .where('subjectName', isEqualTo: subjectName)
          .orderBy("year", descending: true)
          .getDocuments();
      List<QuestionPaper> questionPapers = snapshot.documents
          .map((doc) => QuestionPaper.fromData(doc.data))
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
      QuerySnapshot snapshot = await _syllabusCollectionReference
          .where('subjectName', isEqualTo: subjectName)
          .getDocuments();
      List<Syllabus> syllabus =
          snapshot.documents.map((doc) => Syllabus.fromData(doc.data)).toList();
      _syllabusService.setSyllabus = syllabus;
      return syllabus;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving Notes from Firebase , Error occurred");
    }
  }

  loadLinksFromFirebase(String subjectName) async {
    try {
      QuerySnapshot snapshot = await _linksCollectionReference
          .where('subjectName', isEqualTo: subjectName)
          .getDocuments();
      List<Link> links =
          snapshot.documents.map((doc) => Link.fromData(doc.data)).toList();
      _linksService.setLinks = links;
      return links;
    } catch (e) {
      return _errorHandling(
          e, "While retreiving Notes from Firebase , Error occurred");
    }
  }

  loadReportsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _reportCollectionReference.orderBy("date",descending: true).getDocuments();
      List<Report> reports =
          snapshot.documents.map((doc) => Report.fromData(doc.data)).toList();
      return reports;
    } catch (e) {
      return _errorHandling(e,
          "While retreiving REPORTS FOR ADMIN from Firebase , Error occurred");
    }
  }

  loadUploadLogFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await _uploadLogCollectionReference.orderBy("uploadedAt",descending: true).getDocuments();
      List<UploadLog> uploadLogs = snapshot.documents
          .map((doc) => UploadLog.fromData(doc.data))
          .toList();
      log.e(uploadLogs);
      return uploadLogs;
    } catch (e) {
      return _errorHandling(e,
          "While retreiving UPLOADLOGS FOR ADMIN from Firebase , Error occurred");
    }
  }

  Future saveNotes(AbstractDocument note) async {
    try {
      AuthenticationService _authenticationService = locator<AuthenticationService>();
      User user = await _authenticationService.getUser();
      String id = newCuid();
      note.setId = id;
      log.i("Document being saved");
      CollectionReference ref =
          _getCollectionReferenceAccordingToType(note.path);
      log.i(ref.toString());
      log.i(note.path);
      log.i(note.id);
      log.i(note.toJson());
      await ref.document(note.id).setData(note.toJson());
      await _uploadLogCollectionReference
          .document(note.id)
          .setData(_createUploadLog(note,user));
    } catch (e) {
      log.e("Document id : ${note.id}");
      log.e("Document Subject Name : ${note.subjectName}");
      log.e("Document Title : ${note.title}");
      return _errorHandling(
          e, "While saving Document to Firebase , Error occurred");
    }
  }


  saveLink(Link doc) async {
    try {
      AuthenticationService _authenticationService = locator<AuthenticationService>();
      User user = await _authenticationService.getUser();
      log.e("saving link");
      String id = newCuid();
      doc.setId = id;
      await _linksCollectionReference.document(doc.id).setData(doc.toJson());
      await _linksCollectionReference.document("length").updateData({"len" : FieldValue.increment(1)});
      await _uploadLogCollectionReference
          .document(doc.id)
          .setData(_linkUploadLog(doc,user));
    } catch (e) {
      log.i("Url of link : ${doc.linkUrl}");
      log.i("title of link : ${doc.title}");
      return _errorHandling(
          e, "While saving LINK to Firebase , Error occurred");
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

  reportNote({Report report, AbstractDocument doc}) async {
    try {
      Map<String, dynamic> data = report.toJson();
      AuthenticationService _authenticationService = locator<AuthenticationService>();
      User user = await _authenticationService.getUser();
      data.addAll({
        "reporter_id":user.id,
        "id": doc.id,
        "title": doc.title,
        "type": doc.type,
        "reports": FieldValue.increment(1),
        "date" : DateTime.now(), 
      });
      DocumentSnapshot docSnap =
          await _reportCollectionReference.document(doc.id).get();
      if (docSnap.exists) {
        await docSnap.reference.updateData(data);
      } else {
        await _reportCollectionReference.document(doc.id).setData(data);
      }
      _analyticsService.logEvent(name:"REPORT",parameters:report.toJson(),addInNotificationService: true);
    } catch (e) {
      return _errorHandling(
          e, "While uploading report to Firebase , Error occurred");
    }
  }

  deleteDocument(AbstractDocument doc) async {
    log.w(doc.path);

    CollectionReference ref = _getCollectionReferenceAccordingToType(doc.path);

    //Before rewriting whole application , there was no real system of ids
    //In an effort to be backward compatible we had to take care of both cases
    try {
      if (doc.id != null) {
        log.w("Document being deleted using ID");
        if (doc.id.length > 5) {
          await ref.document(doc.id).delete();
          await _uploadLogCollectionReference.document(doc.id).delete();
          if (doc.path == Document.Links){
            await _linksCollectionReference.document("length").updateData({"len" : FieldValue.increment(-1)});
          }
          DocumentSnapshot docSnap =
              await _reportCollectionReference.document(doc.id).get();
          if (docSnap.exists) {
            docSnap.reference.delete();
          }
        }
      } else {
        log.w(
            "Document being deleted using url matching in firebase , may cause more reads");
        QuerySnapshot snapshot =
            await ref.where("url", isEqualTo: doc.url).getDocuments();
        snapshot.documents.forEach((doc) async {
          await doc.reference.delete();
        });
      }
    } catch (e) {
      return _errorHandling(
          e, "While Deleting document in Firebase , Error occurred");
    }
  }

  isUserAllowed(String id) async {
    bool allowed = true;
    DocumentSnapshot doc = await _usersCollectionReference.document(id).get();
    allowed = doc.data["isUserAllowedToUpload"] ?? true;
    log.w("User allowed to upload ? : $allowed");
    return allowed;
  }

  //*used for loading all subjects to firebase [one-time] do not activate again
  // loadSubjects() async
  // {
  //   List<Map<String,dynamic>> _subjectsToStore = CourseInfo.allsubjects.map((e) => e.toJson()).toList();

  //   _subjectsToStore.forEach((subject) async {

  //       await Firestore.instance.collection("Subjects").document(subject["id"].toString()).setData(subject);

  //   });
  // }

  //*used for loading all subjects to G-Drive [one-time] do not activate again
  // loadSubjects() async
  // {
  //   // List<Map<String,dynamic>> _subjectsToStore = CourseInfo.allsubjects.map((e) => e.toJson()).toList();

  //   // _subjectsToStore.forEach((subject) async {

  //   //     await Firestore.instance.collection("Subjects").document(subject["id"].toString()).setData(subject);

  //   // });
  //   List<Subject> subs = _subjectsService.allSubjects.value;
  //   subs.forEach((subject) {

  //     print(subject.name);



  //   });
  // }

  incrementVotes(Note doc, int val) {
    CollectionReference ref = _notesCollectionReference;
    try {
      if (doc.id != null && doc.id.length > 5) {
        log.i("Document being upvoted using ID");
        if (val == 1) {
          ref.document(doc.id).updateData({"votes": FieldValue.increment(1)});
        } else if (val == 2) {
          ref.document(doc.id).updateData({"votes": FieldValue.increment(2)});
        }
      } else {
        log.i("Document being upvoted");
        if (val == 1) {
          _notesCollectionReference
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(1)});
        } else if (val == 2) {
          _notesCollectionReference
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(2)});
        }
      }
    } catch (e) {
      return _errorHandling(
          e, "While Deleting upvoting notes in Firebase , Error occurred");
    }
  }

  decrementVotes(Note doc, int val) {
    CollectionReference ref = _notesCollectionReference;

    try {
      if (doc.id != null && doc.id.length > 5) {
        log.i("Document being downvoting using ID");

        if (val == 1) {
          ref.document(doc.id).updateData({"votes": FieldValue.increment(-1)});
        } else if (val == 2) {
          ref.document(doc.id).updateData({"votes": FieldValue.increment(-2)});
        }
      } else {
        log.i("Document being downvoting in firebase");
        if (val == 1) {
          _notesCollectionReference
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(-1)});
        } else if (val == 2) {
          _notesCollectionReference
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(-2)});
        }
      }
    } catch (e) {
      return _errorHandling(
          e, "While Deleting downvoting notes in Firebase , Error occurred");
    }
  }

  incrementView(Note doc) {
    CollectionReference ref = _notesCollectionReference;
    try {
      if (doc.id != null && doc.id.length > 5) {
        log.i("Document being increment view using ID");
        // if (doc.id.length > 5) {
        ref.document(doc.id).updateData({"view": FieldValue.increment(1)});
        //}
      } else {
        log.i("Document view being incremented in firebase");
        return _notesCollectionReference
            .document("Note_${doc.subjectName}_${doc.title}")
            .updateData({"view": FieldValue.increment(1)});
      }
    } catch (e) {
      return _errorHandling(
          e, "While increment view notes in Firebase , Error occurred");
    }
  }

  getSnapShotOfVotes(Note doc) {
    // return _notesCollectionReference
    //     .document("Note_${note.subjectName}_${note.title}")
    //     .snapshots();
    CollectionReference ref = _notesCollectionReference;
    try {
      if (doc.id != null && doc.id.length > 5) {
        log.i("snapshot of votes called using ID");
        // if () {
        return ref.document(doc.id).snapshots();
        // }
      } else {
        log.i("Getting snapshot of votes");
        return _notesCollectionReference
            .document("Note_${doc.subjectName}_${doc.title}")
            .snapshots();
        // });
      }
    } catch (e) {
      return _errorHandling(
          e, "While increment view notes in Firebase , Error occurred");
    }
  }

  Map<String, dynamic> _createUploadLog(AbstractDocument note,User user) {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    Map<String,dynamic> uploadLog = {
                                        "uploader_name":user.username,
                                        "uploader_id":user.id,
                                        "id": note.id,
                                        "subjectName": note.subjectName,
                                        "type": note.type,
                                        "fileName": note.title,
                                        "uploadedAt": DateTime.now(),
                                        "email": _authenticationService.user.email,
                                        "size": note.size,
                                    };
    return uploadLog;
  }

  Map<String, dynamic> _linkUploadLog(Link note,User user) {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    Map<String,dynamic> uploadLog =  {
      "uploader_id":user.id,
      "id": note.id,
      "subjectName": note.subjectName,
      "type": Constants.links,
      "fileName": note.title,
      "uploadedAt": DateTime.now(),
      "email": _authenticationService.user.email,
      "size": 0,
    };
    _analyticsService.logEvent(name:"UPLOAD_LINK" , parameters: uploadLog , addInNotificationService:true);
    return uploadLog;
  }

  deleteReport(Report report) async {
    await _reportCollectionReference.document(report.id).delete();
  }

  deleteUploadLog(UploadLog report) async {
    await _uploadLogCollectionReference.document(report.id).delete();
  }

  void updateSubjectInFirebase(Map subject) async {
    await Firestore.instance.collection("Subjects").document(subject["id"].toString()).setData(subject);
  }

  updateNoteInFirebase(Map note) async {
    log.e(note["firebaseId"].toString());
    await Firestore.instance.collection("Notes").document(note["firebaseId"].toString()).setData(note);
  }

  Future<Note> getNoteById(String id) async {
    DocumentSnapshot doc = await _notesCollectionReference.document(id).get();
    return Note.fromData(doc.data,doc.documentID);
  }

  Future<Link> getLinkById(String id) async {
    DocumentSnapshot doc = await _linksCollectionReference.document(id).get();
    return Link.fromData(doc.data);
  }
  Future<QuestionPaper> getQuestionPaperById(String id) async {
    DocumentSnapshot doc = await _questionPapersCollectionReference.document(id).get();
    return QuestionPaper.fromData(doc.data);
  }
  Future<Syllabus> getSyllabusById(String id) async {
    DocumentSnapshot doc = await _syllabusCollectionReference.document(id).get();
    return Syllabus.fromData(doc.data);
  }

  deleteLinkById(String id) async {
    await _linksCollectionReference.document(id).delete();
    await _uploadLogCollectionReference.document(id).delete();
    await _reportCollectionReference.document(id).delete();
    await _linksCollectionReference.document("length").updateData({"len" : FieldValue.increment(-1)});
    return null;
  }
  deleteNoteById(String id) async {
    await _notesCollectionReference.document(id).delete();
    await _uploadLogCollectionReference.document(id).delete();
    await _reportCollectionReference.document(id).delete();
    return null;
  }

}
