part of './../firestore_service.dart';

extension FirestoreWrites on FirestoreService{

  saveUser(User user) async {
    Map<String, dynamic> data = user.toJson();
    try {
      await _usersCollectionReference
          .doc(data["id"])
          .set(data,SetOptions(merge: true));
      if (!user.isAdmin)
        await _usersCollectionReference
            .doc(Constants.userStats)
            .update({
          user.college: FieldValue.increment(1),
          user.semester: FieldValue.increment(1),
          user.branch: FieldValue.increment(1),
        });
    } catch (e) {
      return _errorHandling(
          e, "While saving user to Firebase , Error occurred");
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
      await ref.doc(note.id).set(note.toJson(),SetOptions(merge: true));
      await _uploadLogCollectionReference
          .doc(note.id)
          .set(await createUploadLog(note, user));
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
      await _linksCollectionReference.doc(doc.id).set(doc.toJson());
      await _uploadLogCollectionReference
          .doc(doc.id)
          .set(_linkUploadLog(doc, user));
    } catch (e) {
      log.i("Url of link : ${doc.linkUrl}");
      log.i("title of link : ${doc.title}");
      return _errorHandling(
          e, "While saving LINK to Firebase , Error occurred");
    }
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
          await _reportCollectionReference.doc(doc.id).get();
      if (docSnap.exists) {
        await docSnap.reference.update(data);
      } else {
        await _reportCollectionReference.doc(doc.id).set(data);
      }
      _analyticsService.logEvent(
          name: "REPORT", parameters: {"reason": report.reportReason ?? ""});
      _analyticsService.sendNotification(
          isAdmin: true,
          message: Strings.admin_document_report_notification_message,
          title: Strings.admin_document_report_notification_title);
    } catch (e) {
      return _errorHandling(
          e, "While uploading report to Firebase , Error occurred");
    }
  }

  addVerifier(Verifier verifier) async {
    CloudFunctionsService cloudFunctionsService = locator<CloudFunctionsService>();
    AuthenticationService _authenticationService = locator<AuthenticationService>();
    String id = _authenticationService.user.id;
    await cloudFunctionsService.grantVerifierRole(id,verifier.email,verifier.id);
    Map<String, dynamic> data = verifier.toJson();
    try {
      log.i("Adding Verifier to firebase");
      await _verifiersCollectionReference
          .doc(data["Id"])
          .set(data,SetOptions(merge: true));

    } catch (e) {
      return _errorHandling(e, "While saving user to Firebase , Error occurred");
    }
  }


  //******************************           UPDATES           ****************************************/ 

  updateSubjectInFirebase(Map subject) async {
    try {
      await FirebaseFirestore.instance
          .collection("Subjects")
          .doc(subject["id"].toString())
          .set(subject);
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateNoteInFirebase(Note note) async {
    try {
      if (note.subjectId == null) {
        SubjectsService _subjectsService = locator<SubjectsService>();
        Subject subject = _subjectsService.getSubjectByName(note.subjectName);
        note.setSubjectId = subject.id;
      }
      log.e("Note with id ${note.id} is being updated");
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
          .doc(note.id)
          .delete();
      await _subjectsCollectionReference
          .doc(note.subjectId.toString())
          .collection(Constants.firebase_notes)
          .doc(note.id)
          .set(note.toJson(), SetOptions(merge: true));
    } catch (e) {
      log.e(e.toString());
    }
  }

  updateQuestionPaperInFirebase(QuestionPaper note) async {
    if (note.subjectId == null) {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(note.subjectName);
      note.setSubjectId = subject.id;
    }

    try {
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
          .doc(note.id)
          .delete();
      await _subjectsCollectionReference
          .doc(note.subjectId.toString())
          .collection(Constants.firebase_questionPapers)
          .doc(note.id)
          .set(note.toJson(), SetOptions(merge: true));
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateSyllabusInFirebase(Syllabus note) async {
    if (note.subjectId == null) {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(note.subjectName);
      note.setSubjectId = subject.id;
    }

    try {
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
          .doc(note.id)
          .delete();
      await _subjectsCollectionReference
          .doc(note.subjectId.toString())
          .collection(Constants.firebase_syllabus)
          .doc(note.id)
          .set(note.toJson(), SetOptions(merge: true));
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateLinkInFirebase(Link note) async {
    if (note.subjectId == null) {
      SubjectsService _subjectsService = locator<SubjectsService>();
      Subject subject = _subjectsService.getSubjectByName(note.subjectName);
      note.setSubjectId = subject.id;
    }

    try {
      await _getCollectionReferenceAccordingToTypeForTempUpload(note.path)
          .doc(note.id)
          .delete();
      await _subjectsCollectionReference
          .doc(note.subjectId.toString())
          .collection(Constants.firebase_links)
          .doc(note.id)
          .set(note.toJson(), SetOptions(merge: true));
      log.e(note.toJson());
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateUploadLogInFirebase(UploadLog logItem) async {
    Map<String, dynamic> data = logItem.toJson();
    try {
      data.addAll({
        "verifiers" : FieldValue.increment(1),
        if(logItem.additionalInfo!=null)
        "additionalInfoFromVerifiers": FieldValue.arrayUnion([logItem.additionalInfo]),
      });
      await _uploadLogCollectionReference
          .doc(data["id"])
          .set(data,SetOptions(merge: true));
          
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateReportInFirebase(Report note) async {
    log.e(note.id);

    try {
      await _reportCollectionReference.doc(note.id).set(note.toJson(),SetOptions(merge: true));
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateUserInFirebase(User user, {bool updateLocally = true}) async {
    try {
      if (user != null) {
        log.e(user.id);
        await _usersCollectionReference
            .doc(user.id)
            .set(user.toJson(), SetOptions(merge: true));
        if (updateLocally) {
          _sharedPreferencesService.saveUserLocally(user);
        }
      } else {
        log.e("User is Null, not found in Local Storage");
      }
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  updateVerifierInFirebase(Verifier user, {bool updateNumbers = true}) async {
    log.i("Verifier being updated in firebase");
    Map<String, dynamic> data = user.toJson();
    if(updateNumbers){
    data.addAll({
      "docsVerified": FieldValue.arrayUnion([user.docIdBeingVerified]),
      "numOfVerifiedDocs": FieldValue.increment(user.numOfVerifiedDocs),
      "numOfReportedDocs": FieldValue.increment(user.numOfReportedDocs),
    });}

    try {
      // if (user != null && user.docIdBeingVerified!=null){
        log.e(user.id);
        await _verifiersCollectionReference
            .doc(user.id)
            .set(data, SetOptions(merge: true));
      // } else {
      //   log.e("Verifier Null");
      // }
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  addSubject(Subject subject) async {
    try {
      await _subjectsCollectionReference
          .doc(subject.id.toString())
          .set(subject.toJson());
    } catch (e) {
      log.e(e.toString());
    }
    log.e("uploaded");
  }

  Future<Subject> getSubjectByName(String subjectName) async {
    QuerySnapshot docs = await _subjectsCollectionReference
        .where("name", isEqualTo: subjectName)
        .get();
    return Subject.fromData(docs.docs[0].data());
  }

  incrementVotes(Note doc, int val) {
    CollectionReference ref = _subjectsCollectionReference
        .doc(doc.subjectId.toString())
        .collection(Constants.firebase_notes);
    try {
      if (doc.id != null && doc.id.length > 5) {
        log.i("Document being upvoted using ID");
        if (val == 1) {
          ref.doc(doc.id).update({"votes": FieldValue.increment(1)});
        } else if (val == 2) {
          ref.doc(doc.id).update({"votes": FieldValue.increment(2)});
        }
      } else {
        log.i("Document being upvoted");
        if (val == 1) {
          ref
              .doc("Note_${doc.subjectName}_${doc.title}")
              .update({"votes": FieldValue.increment(1)});
        } else if (val == 2) {
          ref
              .doc("Note_${doc.subjectName}_${doc.title}")
              .update({"votes": FieldValue.increment(2)});
        }
      }
    } catch (e) {
      return _errorHandling(
          e, "While Deleting upvoting notes in Firebase , Error occurred");
    }
  }

  decrementVotes(Note doc, int val) {
    CollectionReference ref = _subjectsCollectionReference
        .doc(doc.subjectId.toString())
        .collection(Constants.firebase_notes);

    try {
      if (doc.id != null && doc.id.length > 5) {
        log.i("Document being downvoting using ID");

        if (val == 1) {
          ref.doc(doc.id).update({"votes": FieldValue.increment(-1)});
        } else if (val == 2) {
          ref.doc(doc.id).update({"votes": FieldValue.increment(-2)});
        }
      } else {
        log.i("Document being downvoting in firebase");
        if (val == 1) {
          ref
              .doc("Note_${doc.subjectName}_${doc.title}")
              .update({"votes": FieldValue.increment(-1)});
        } else if (val == 2) {
          ref
              .doc("Note_${doc.subjectName}_${doc.title}")
              .update({"votes": FieldValue.increment(-2)});
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
        ref.doc(docId).update({"view": FieldValue.increment(views)});
        //}
      }
      // else {
      //   log.i("Document view being incremented in firebase");
      //   return _notesCollectionReference
      //       .doc("Note_${doc.subjectName}_${doc.title}")
      //       .update({"view": FieldValue.increment(1)});
      // }
    } catch (e) {
      return _errorHandling(
          e, "While increment view notes in Firebase , Error occurred");
    }
  }

}