part of './../firestore_service.dart';

extension FirestoreDeletes on FirestoreService{

  deleteReport(Report report) async {
    await _reportCollectionReference.doc(report.id).delete();
  }

  deleteUploadLog(UploadLog report) async {
    await _uploadLogCollectionReference.doc(report.id).delete();
  }

  deleteNoteById(int subId, String id) async {
    // await _subjectsCollectionReference
    //       .document(subId.toString())
    //       .collection(Constants.firebase_notes)
    //       .document(id)
    //       .delete();
    await _subjectsCollectionReference
        .doc(subId.toString())
        .collection(Constants.firebase_notes)
        .doc(id)
        .delete();
    await _uploadLogCollectionReference.doc(id).delete();
    await _reportCollectionReference.doc(id).delete();
    return null;
  }

  Future<bool> destroySubject(String subjectName, int subjectId) async {
    //Warn
    log.e(
        "Warning this will delete all Notes,QPapers and syllabi having subject name ${subjectName}");
    SheetResponse response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.filledStacks,
        title: "Sure?",
        description:
            "Warning this will delete all Notes,QPapers and syllabi having subject name that was entered",
        mainButtonTitle: "ok",
        secondaryButtonTitle: "no");
    if (response == null || !response.confirmed) {
      return false;
    }

    //Delete subject
    try {
      await deleteSubjectById(subjectId);
      QuerySnapshot noteDocs = await _subjectsCollectionReference
          .doc(subjectId.toString())
          .collection(Constants.firebase_notes)
          .get();
      QuerySnapshot qPaperDocs = await _subjectsCollectionReference
          .doc(subjectId.toString())
          .collection(Constants.firebase_questionPapers)
          .get();
      QuerySnapshot syllabusDocs = await _subjectsCollectionReference
          .doc(subjectId.toString())
          .collection(Constants.firebase_syllabus)
          .get();
      QuerySnapshot linksDocs = await _subjectsCollectionReference
          .doc(subjectId.toString())
          .collection(Constants.firebase_links)
          .get();

      noteDocs.docs.forEach((DocumentSnapshot doc) {
        doc.reference.delete();
      });
      qPaperDocs.docs.forEach((DocumentSnapshot doc) {
        doc.reference.delete();
      });
      syllabusDocs.docs.forEach((DocumentSnapshot doc) {
        doc.reference.delete();
      });
      linksDocs.docs.forEach((DocumentSnapshot doc) {
        doc.reference.delete();
      });

      return true;
    } catch (e) {
      log.e(e.toString());
      return false;
    }
  }

  deleteSubjectById(int id) async {
    await _subjectsCollectionReference.doc(id.toString()).delete();
  }

  deleteDocument(AbstractDocument doc) async {
    log.w(doc.path);

    CollectionReference ref =
        _getCollectionReferenceAccordingToType(doc.path, doc.subjectId);

    //todo remove backward compatibility
    //Before rewriting whole application , there was no real system of ids
    //In an effort to be backward compatible we had to take care of both cases
    try {
      if (doc.id != null) {
        log.w("Document being deleted using ID");
        if (doc.id.length > 5) {
          await ref.doc(doc.id).delete();
          await _uploadLogCollectionReference.doc(doc.id).delete();
          DocumentSnapshot docSnap =
              await _reportCollectionReference.doc(doc.id).get();
          if (docSnap.exists) {
            docSnap.reference.delete();
          }
        }
      } else {
        log.w(
            "Document being deleted using url matching in firebase , may cause more reads");
        QuerySnapshot snapshot =
            await ref.where("url", isEqualTo: doc.url).get();
        snapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });
      }
    } catch (e) {
      return _errorHandling(
          e, "While Deleting document in Firebase , Error occurred");
    }
  }

  deleteLinkById(int subId,String id) async {
    // await _subjectsCollectionReference
    //       .document(subId.toString())
    //       .collection(Constants.firebase_links)
    //       .document(id)
    //       .delete();
    QuerySnapshot docSnaps = await FirebaseFirestore.instance
        .collectionGroup(Constants.firebase_links)
        .where("id", isEqualTo: id)
        .get();
    List<DocumentSnapshot> docs = docSnaps.docs;
    if (docs.isEmpty) return null;
    docs.forEach((doc) {
      doc.reference.delete();
    });
    await _uploadLogCollectionReference.doc(id).delete();
    await _reportCollectionReference.doc(id).delete();
    return null;
  }

}