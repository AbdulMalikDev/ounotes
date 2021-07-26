
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart' hide log;
import 'package:FSOUNotes/models/question_paper.dart' hide log;
import 'package:FSOUNotes/models/report.dart' hide log;
import 'package:FSOUNotes/models/subject.dart' hide log;
import 'package:FSOUNotes/models/syllabus.dart' hide log;
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart' hide log;
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
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';

// All top level Variables and Serivces needed are stored in this file
// For specific functions explore the files below

// Contains all firebase read function calls
part 'CRUD/firestore_reads.dart';
// Contains all firebase create and update function calls
part './CRUD/firestore_write.dart';
// Contains all firebase delete function calls
part './CRUD/firestore_delete.dart';
// Contains all other functions and switch cases
// If its not making a call directly it goes here
part './firestore_extra.dart/firestore_functions.dart';

class FirestoreService {
  
  Logger log = getLogger("FirestoreService");

  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _subjectsCollectionReference =
      FirebaseFirestore.instance.collection("Subjects");
  final CollectionReference _notesCollectionReference =
      FirebaseFirestore.instance.collection("Notes");
  final CollectionReference _questionPapersCollectionReference =
      FirebaseFirestore.instance.collection("QuestionPapers");
  final CollectionReference _syllabusCollectionReference =
      FirebaseFirestore.instance.collection("Syllabus");
  final CollectionReference _linksCollectionReference =
      FirebaseFirestore.instance.collection("Links");
  final CollectionReference _reportCollectionReference =
      FirebaseFirestore.instance.collection("Report");
  final CollectionReference _confidentialCollectionReference =
      FirebaseFirestore.instance.collection("confidential");
  final CollectionReference _uploadLogCollectionReference =
      FirebaseFirestore.instance.collection("uploadLog");

  NotesService _notesService = locator<NotesService>();
  QuestionPaperService _questionPaperService = locator<QuestionPaperService>();
  SyllabusService _syllabusService = locator<SyllabusService>();
  LinksService _linksService = locator<LinksService>();
  VoteService _voteServie = locator<VoteService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  

  

  

  // //*used for loading all subjects to firebase [one-time] do not activate again
  // loadSubjects() async
  // {
  //   List<Map<String,dynamic>> _subjectsToStore = CourseInfo.allsubjects.map((e) => e.toJson()).toList();

  //   _subjectsToStore.forEach((subject) async {

  //       await FirebaseFirestore.instance.collection("Subjects").doc(subject["id"].toString()).set(subject);

  //   });
  // }

  // //*used for loading all subjects to G-Drive [one-time] do not activate again
  // loadSubjects() async
  // {
  //   List<Map<String,dynamic>> _subjectsToStore = CourseInfo.allsubjects.map((e) => e.toJson()).toList();

  //   _subjectsToStore.forEach((subject) async {

  //       await FirebaseFirestore.instance.collection("Subjects").doc(subject["id"].toString()).set(subject);

  //   });
  //   List<Subject> subs = _subjectsService.allSubjects.value;
  //   subs.forEach((subject) {

  //     print(subject.name);

  //   });
  // }

  

  

  // // getSnapShotOfVotes(Note doc) {
  // //   // return _notesCollectionReference
  // //   //     .document("Note_${note.subjectName}_${note.title}")
  // //   //     .snapshots();
  // //   CollectionReference ref = _notesCollectionReference;
  // //   try {
  // //     if (doc.id != null && doc.id.length > 5) {
  // //       log.i("snapshot of votes called using ID");
  // //       // if () {
  // //       return ref.document(doc.id).snapshots();
  // //       // }
  // //     } else {
  // //       log.i("Getting snapshot of votes");
  // //       return _notesCollectionReference
  // //           .document("Note_${doc.subjectName}_${doc.title}")
  // //           .snapshots();
  // //       // });
  // //     }
  // //   } catch (e) {
  // //     return _errorHandling(
  // //         e, "While increment view notes in Firebase , Error occurred");
  // //   }
  // // }

  
  

  // //* Methods to update models in Firestore Database

  

  

  

  

  

  

  
  // //Get User Stats
  

  

  // // Handling subjects
  

  
}
