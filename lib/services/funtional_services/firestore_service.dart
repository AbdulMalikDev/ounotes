import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/misc/course_info.dart';
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
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/links_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuid/cuid.dart';
import 'package:FSOUNotes/ui/shared/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

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
  VoteService _voteServie = locator<VoteService>();
  

  AnalyticsService _analyticsService = locator<AnalyticsService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  _getCollectionReferenceAccordingToType(Document path,id) {
    switch (path) {
      case Document.Notes:
        return _subjectsCollectionReference
          .document(id.toString()) 
          .collection(Constants.firebase_notes);
        break;
      case Document.QuestionPapers:
        return _subjectsCollectionReference
          .document(id.toString()) 
          .collection(Constants.firebase_questionPapers);
        break;
      case Document.Syllabus:
        return _subjectsCollectionReference
          .document(id.toString()) 
          .collection(Constants.firebase_syllabus);
        break;
      case Document.Links:
        return _subjectsCollectionReference
          .document(id.toString()) 
          .collection(Constants.firebase_links);
        break;
      case Document.None:
      case Document.Report:
      case Document.UploadLog:
      case Document.Drawer:
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

  saveUser(User user) async {
    Map<String, dynamic> data = user.toJson();
    try {
      await _usersCollectionReference.document(data["id"]).setData(data,merge: true);
      if(!user.isAdmin)await _usersCollectionReference.document(Constants.userStats).updateData({
        user.college : FieldValue.increment(1),
        user.semester : FieldValue.increment(1),
        user.branch : FieldValue.increment(1),
      });
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
      //     .getDocuments();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .document(subject.id.toString()) 
          .collection(Constants.firebase_notes) 
          .orderBy('votes', descending: true)
          .getDocuments();
      List<Note> notes = snapshot.documents
          .map((doc) => Note.fromData(doc.data, doc.documentID))
          .toList();
      _notesService.setNotes = notes;
      Map<String, int> noOfVotes = {};
      notes.forEach((note) {
        noOfVotes[note.title] = note.votes;
      });
      _voteServie.setNumberOfVotes = noOfVotes;

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
      //     .getDocuments();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .document(subject.id.toString()) 
          .collection(Constants.firebase_questionPapers)
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
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(subjectName);
      // QuerySnapshot snapshot = await _syllabusCollectionReference
      //     .where('subjectName', isEqualTo: subjectName)
      //     .getDocuments();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .document(subject.id.toString()) 
          .collection(Constants.firebase_syllabus)
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
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(subjectName);
      // QuerySnapshot snapshot = await _linksCollectionReference
      //     .where('subjectName', isEqualTo: subjectName)
      //     .getDocuments();
      QuerySnapshot snapshot = await _subjectsCollectionReference
          .document(subject.id.toString()) 
          .collection(Constants.firebase_links)
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
      QuerySnapshot snapshot = await _reportCollectionReference
          .orderBy("date", descending: true)
          .getDocuments();
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
      QuerySnapshot snapshot = await _uploadLogCollectionReference
          .orderBy("uploadedAt", descending: true)
          .getDocuments();
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
      User user = await _sharedPreferencesService.getUser();
      String id = newCuid();
      note.setId = id;
      note.setUploaderId = user.id;
      log.i("Document being saved");
      CollectionReference ref =
          _getCollectionReferenceAccordingToTypeForTempUpload(note.path);
      log.i(ref.toString());
      log.i(note.path);
      log.i(note.id);
      log.i(note.toJson());
      await ref.document(note.id).setData(note.toJson());
      await _uploadLogCollectionReference
          .document(note.id)
          .setData(_createUploadLog(note, user));
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
      AuthenticationService _authenticationService =
          locator<AuthenticationService>();
      User user = await _authenticationService.getUser();
      log.e("saving link");
      String id = newCuid();
      doc.setId = id;
      doc.setUploaderId = user.id;
      await _linksCollectionReference
            .document(doc.id).setData(doc.toJson());
      await _uploadLogCollectionReference
          .document(doc.id)
          .setData(_linkUploadLog(doc, user));
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
      AuthenticationService _authenticationService =
          locator<AuthenticationService>();
      User user = await _authenticationService.getUser();
      data.addAll({
        "reporter_id": user.id,
        "id": doc.id,
        "title": doc.title,
        "type": doc.type,
        "reports": FieldValue.increment(1),
        "date": DateTime.now(),
        "reportReasons": FieldValue.arrayUnion([report.reportReason]),
      });
      DocumentSnapshot docSnap =
          await _reportCollectionReference.document(doc.id).get();
      if (docSnap.exists) {
        await docSnap.reference.updateData(data);
      } else {
        await _reportCollectionReference.document(doc.id).setData(data);
      }
      _analyticsService.logEvent(name:"REPORT",parameters:{"reason":report.reportReason??""});
      _analyticsService.sendNotification(isAdmin: true,message: Strings.admin_document_report_notification_message,title: Strings.admin_document_report_notification_title);
    } catch (e) {
      return _errorHandling(
          e, "While uploading report to Firebase , Error occurred");
    }
  }

  deleteDocument(AbstractDocument doc) async {
    log.w(doc.path);

    CollectionReference ref = _getCollectionReferenceAccordingToType(doc.path,doc.subjectId);

    //Before rewriting whole application , there was no real system of ids
    //In an effort to be backward compatible we had to take care of both cases
    try {

      if (doc.id != null) {
        log.w("Document being deleted using ID");
        if (doc.id.length > 5) {
          await ref.document(doc.id).delete();
          await _uploadLogCollectionReference.document(doc.id).delete();
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
    SubjectsService _subjectsService = locator<SubjectsService>();
    CollectionReference ref = _subjectsCollectionReference
          .document(doc.subjectId.toString()) 
          .collection(Constants.firebase_notes);
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
          ref
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(1)});
        } else if (val == 2) {
          ref
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
    CollectionReference ref = _subjectsCollectionReference
          .document(doc.subjectId.toString()) 
          .collection(Constants.firebase_notes);

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
          ref
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(-1)});
        } else if (val == 2) {
          ref
              .document("Note_${doc.subjectName}_${doc.title}")
              .updateData({"votes": FieldValue.increment(-2)});
        }
      }
    } catch (e) {
      return _errorHandling(
          e, "While Deleting downvoting notes in Firebase , Error occurred");
    }
  }

  incrementView(String docId, int views) {
    CollectionReference ref = _notesCollectionReference;
    try {
      if (docId != null && docId.length > 5) {
        log.i("Document being increment view using ID");
        // if (doc.id.length > 5) {
        ref.document(docId).updateData({"view": FieldValue.increment(views)});
        //}
      }
      // else {
      //   log.i("Document view being incremented in firebase");
      //   return _notesCollectionReference
      //       .document("Note_${doc.subjectName}_${doc.title}")
      //       .updateData({"view": FieldValue.increment(1)});
      // }
    } catch (e) {
      return _errorHandling(
          e, "While increment view notes in Firebase , Error occurred");
    }
  }

  // getSnapShotOfVotes(Note doc) {
  //   // return _notesCollectionReference
  //   //     .document("Note_${note.subjectName}_${note.title}")
  //   //     .snapshots();
  //   CollectionReference ref = _notesCollectionReference;
  //   try {
  //     if (doc.id != null && doc.id.length > 5) {
  //       log.i("snapshot of votes called using ID");
  //       // if () {
  //       return ref.document(doc.id).snapshots();
  //       // }
  //     } else {
  //       log.i("Getting snapshot of votes");
  //       return _notesCollectionReference
  //           .document("Note_${doc.subjectName}_${doc.title}")
  //           .snapshots();
  //       // });
  //     }
  //   } catch (e) {
  //     return _errorHandling(
  //         e, "While increment view notes in Firebase , Error occurred");
  //   }
  // }

  Map<String, dynamic> _createUploadLog(AbstractDocument note, User user) {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    Map<String, dynamic> uploadLog = {
      "uploader_name": user.username,
      "uploader_id": user.id,
      "id": note.id,
      "subjectName": note.subjectName,
      "type": note.type,
      "fileName": note.title,
      "uploadedAt": DateTime.now(),
      "email": _authenticationService.user.email,
      "size": note.size,
    };
    _analyticsService.sendNotification(isAdmin: true,message: Strings.admin_document_upload_notification_message,title: Strings.admin_document_upload_notification_title);
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
      "email": _authenticationService.user.email,
      "size": 0,
    };
    _analyticsService.logEvent(name:"UPLOAD_LINK" , parameters: uploadLog , addInNotificationService:true);
    _analyticsService.sendNotification(isAdmin: true,message: Strings.admin_document_upload_notification_message,title: Strings.admin_document_upload_notification_title);
    return uploadLog;
  }

  deleteReport(Report report) async {
    await _reportCollectionReference.document(report.id).delete();
  }

  deleteUploadLog(UploadLog report) async {
    await _uploadLogCollectionReference.document(report.id).delete();
  }

  //* Methods to update models in Firestore Database

  updateSubjectInFirebase(Map subject) async {
    try {
      await Firestore.instance
          .collection("Subjects")
          .document(subject["id"].toString())
          .setData(subject);
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateNoteInFirebase(Note note) async {
    try {
      if(note.subjectId == null){
        SubjectsService _subjectsService = locator<SubjectsService>();
        Subject subject = _subjectsService.getSubjectByName(note.subjectName);
        note.setSubjectId = subject.id;
      }
      log.e("Note with id ${note.id} is being updated");
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
              .document(note.id)
              .delete();
      await _subjectsCollectionReference
              .document(note.subjectId.toString()) 
              .collection(Constants.firebase_notes)
              .document(note.id)
              .setData(note.toJson(),merge: true);
     
    } catch (e) {
      log.e(e.toString());
    }
  }

  updateQuestionPaperInFirebase(QuestionPaper note) async {
    if(note.subjectId == null){
        SubjectsService _subjectsService = locator<SubjectsService>();
        Subject subject = _subjectsService.getSubjectByName(note.subjectName);
        note.setSubjectId = subject.id;
      }

    try {
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
              .document(note.id)
              .delete();
      await _subjectsCollectionReference
              .document(note.subjectId.toString()) 
              .collection(Constants.firebase_questionPapers)
              .document(note.id)
              .setData(note.toJson(),merge: true);
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateSyllabusInFirebase(Syllabus note) async {
    if(note.subjectId == null){
        SubjectsService _subjectsService = locator<SubjectsService>();
        Subject subject = _subjectsService.getSubjectByName(note.subjectName);
        note.setSubjectId = subject.id;
      }

    try {
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
              .document(note.id)
              .delete();
      await _subjectsCollectionReference
              .document(note.subjectId.toString()) 
              .collection(Constants.firebase_syllabus)
              .document(note.id)
              .setData(note.toJson(),merge: true);
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateLinkInFirebase(Link note) async {
    if(note.subjectId == null){
        SubjectsService _subjectsService = locator<SubjectsService>();
        Subject subject = _subjectsService.getSubjectByName(note.subjectName);
        note.setSubjectId = subject.id;
      }

    try {
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
              .document(note.id)
              .delete();
      await _subjectsCollectionReference
              .document(note.subjectId.toString()) 
              .collection(Constants.firebase_links)
              .document(note.id)
              .setData(note.toJson(),merge: true);
      log.e(note.toJson());
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateUploadLogInFirebase(UploadLog note) async {
    log.e(note.id);

    try {
      await _uploadLogCollectionReference
          .document(note.id)
          .setData(note.toJson());
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateReportInFirebase(Report note) async {
    log.e(note.id);

    try {
      await _reportCollectionReference.document(note.id).setData(note.toJson());
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateUserInFirebase(User user, {bool updateLocally = true}) async {
    try {
      if (user != null) {
        log.e(user.id);
        await _usersCollectionReference.document(user.id).setData(user.toJson(),merge: true);
        if(updateLocally){_sharedPreferencesService.saveUserLocally(user);}

      }else{log.e("User is Null, not found in Local Storage");}
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  Future<Note> getNoteById(int subId,String id) async {
    // DocumentSnapshot doc = await _subjectsCollectionReference
    //       .document(subId.toString()) 
    //       .collection(Constants.firebase_notes)
    //       .document(id).get();
    QuerySnapshot docSnaps = await Firestore.instance 
          .collectionGroup(Constants.firebase_notes)
          .where("id",isEqualTo:id)
          .getDocuments();
    List<DocumentSnapshot> docs = docSnaps.documents;
    if(docs.isEmpty)return null;
    DocumentSnapshot doc = docs[docs.length-1];
    if(!doc.exists)return null;
    return Note.fromData(doc.data, doc.documentID);
  }

  Future<Link> getLinkById(int subId,String id) async {
    // DocumentSnapshot doc = await _subjectsCollectionReference
    //       .document(subId.toString()) 
    //       .collection(Constants.firebase_links)
    //       .document(id).get();
    QuerySnapshot docSnaps = await Firestore.instance 
          .collectionGroup(Constants.firebase_links)
          .where("id",isEqualTo:id)
          .getDocuments();
    List<DocumentSnapshot> docs = docSnaps.documents;
    if(docs.isEmpty)return null;
    DocumentSnapshot doc = docs[docs.length-1];
    return Link.fromData(doc.data);
  }

  Future<QuestionPaper> getQuestionPaperById(int subId,String id) async {
  //  DocumentSnapshot doc = await _subjectsCollectionReference
  //         .document(subId.toString()) 
  //         .collection(Constants.firebase_questionPapers)
  //         .document(id).get();
   QuerySnapshot docSnaps = await Firestore.instance 
          .collectionGroup(Constants.firebase_questionPapers)
          .where("id",isEqualTo:id)
          .getDocuments();
    List<DocumentSnapshot> docs = docSnaps.documents;
    if(docs.isEmpty)return null;
    DocumentSnapshot doc = docs[docs.length-1];
    return QuestionPaper.fromData(doc.data);
  }

  Future<Syllabus> getSyllabusById(int subId,String id) async {
    // DocumentSnapshot doc = await _subjectsCollectionReference
    //       .document(subId.toString()) 
    //       .collection(Constants.firebase_syllabus)
    //       .document(id).get();
    QuerySnapshot docSnaps = await Firestore.instance 
          .collectionGroup(Constants.firebase_syllabus)
          .where("id",isEqualTo:id)
          .getDocuments();
    List<DocumentSnapshot> docs = docSnaps.documents;
    if(docs.isEmpty)return null;
    DocumentSnapshot doc = docs[docs.length-1];
    return Syllabus.fromData(doc.data);
  }

  Future<User> getUserById(String id) async {
    DocumentSnapshot doc = await _usersCollectionReference.document(id).get();
    return User.fromData(doc.data);
  }

  deleteLinkById(int subId,String id) async {
    // await _subjectsCollectionReference
    //       .document(subId.toString()) 
    //       .collection(Constants.firebase_links)
    //       .document(id)
    //       .delete();
    QuerySnapshot docSnaps = await Firestore.instance 
          .collectionGroup(Constants.firebase_links)
          .where("id",isEqualTo:id)
          .getDocuments();
    List<DocumentSnapshot> docs = docSnaps.documents;
    if(docs.isEmpty)return null;
    docs.forEach((doc) { doc.reference.delete(); });
    await _uploadLogCollectionReference.document(id).delete();
    await _reportCollectionReference.document(id).delete();
    return null;
  }

  deleteNoteById(int subId,String id) async {
    // await _subjectsCollectionReference
    //       .document(subId.toString()) 
    //       .collection(Constants.firebase_notes)
    //       .document(id)
    //       .delete();
    await _subjectsCollectionReference
              .document(subId.toString()) 
              .collection(Constants.firebase_notes)
              .document(id)
              .delete();
    await _uploadLogCollectionReference.document(id).delete();
    await _reportCollectionReference.document(id).delete();
    return null;
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
    SubjectsService _subjectsService = locator<SubjectsService>();
    Subject subject = _subjectsService.getSubjectByName(subjectName);
    switch (document) {
      case Document.Notes:
        return await this.getNoteById(subject.id,id);
        break;
      case Document.QuestionPapers:
        return await this.getQuestionPaperById(subject.id,id);
        break;
      case Document.Syllabus:
        return await this.getSyllabusById(subject.id,id);
        break;
      case Document.Links:
        return await this.getLinkById(subject.id,id);
        break;
      default:
        break;
    }
  }

  //Get User Stats
  Future<Map<String, dynamic>> getUserStats() async {
    DocumentSnapshot doc =
        await _usersCollectionReference.document(Constants.userStats).get();
    return doc.data;
  }

  Future<User> refreshUser() async {
    User user = await _sharedPreferencesService.getUser();
    DocumentSnapshot doc =
        await _usersCollectionReference.document(user.id).get();
    User newUser = User.fromData(doc.data);
    _sharedPreferencesService.saveUserLocally(newUser);
    return newUser;
  }

  // Handling subjects
  Future<bool> destroySubject(String subjectName,int subjectId) async {
    //Warn
    log.e("Warning this will delete all Notes,QPapers and syllabi having subject name ${subjectName}");
    SheetResponse response = await _bottomSheetService.showCustomSheet(variant:BottomSheetType.filledStacks,title: "Sure?",description:"Warning this will delete all Notes,QPapers and syllabi having subject name that was entered",mainButtonTitle: "ok",secondaryButtonTitle: "no");
    if (response==null || !response.confirmed){return false;}

    //Delete subject
    try {

      await deleteSubjectById(subjectId);
      QuerySnapshot noteDocs     = await _subjectsCollectionReference.document(subjectId.toString()).collection(Constants.firebase_notes).getDocuments();
      QuerySnapshot qPaperDocs   = await _subjectsCollectionReference.document(subjectId.toString()).collection(Constants.firebase_questionPapers).getDocuments();
      QuerySnapshot syllabusDocs = await _subjectsCollectionReference.document(subjectId.toString()).collection(Constants.firebase_syllabus).getDocuments();
      QuerySnapshot linksDocs    = await _subjectsCollectionReference.document(subjectId.toString()).collection(Constants.firebase_links).getDocuments();
      
      noteDocs.documents.forEach((DocumentSnapshot doc)     { doc.reference.delete(); });
      qPaperDocs.documents.forEach((DocumentSnapshot doc)   { doc.reference.delete(); });
      syllabusDocs.documents.forEach((DocumentSnapshot doc) { doc.reference.delete(); });
      linksDocs.documents.forEach((DocumentSnapshot doc)    { doc.reference.delete(); });

      return true;
    }catch (e) {
      log.e(e.toString());
    }
  }

  deleteSubjectById(int id)async{
    await _subjectsCollectionReference.document(id.toString()).delete();
  }

  addSubject(Subject subject) async {
    try {
      await _subjectsCollectionReference.document(subject.id.toString()).setData(subject.toJson());
    } catch (e) {
      log.e(e.toString());
    }
    log.e("uploaded");
  }

  Future<Subject> getSubjectByName(String subjectName) async {
    QuerySnapshot docs = await _subjectsCollectionReference.where("name",isEqualTo:subjectName).getDocuments();
    return Subject.fromData(docs.documents[0].data);
  }
  
}
