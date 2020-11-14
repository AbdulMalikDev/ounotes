import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  // FirestoreService _firestoreService = locator<FirestoreService>();

  ValueNotifier<List<Subject>> get userSubjects =>
      _subjectsService.userSubjects;
  ValueNotifier<List<Subject>> get allSubjects =>
      _subjectsService.allSubjects;

  showIntroDialog() async {
    if (_subjectsService.userSubjects.value.length == 0) {
      //If delay not added, error of build not completed may occur
      await Future.delayed(Duration(seconds: 1));
      await _dialogService.showDialog(
        title: "Welcome to OU Notes App",
        description:
            "Please use \"+\" button to add subjects and swipe left or right to delete them",
        buttonTitle: 'Ok'
        
      );
    }
  }

  void loadSubjectsToDrive() {

  }




  //* one-time use for GDrive upload
  void addSubjectToFirebase(Subject subject) {
    FirestoreService _firestoreService = locator<FirestoreService>();
    _firestoreService.updateSubjectInFirebase(subject.toJson());
    
  }

  Future<List<Note>> getNotesFromFirebase(Subject subject) async {
    FirestoreService _firestoreService = locator<FirestoreService>();
    return await _firestoreService.loadNotesFromFirebase(subject.name);
  }

  void updateNoteInFirebase(Note note) async  {
    FirestoreService _firestoreService = locator<FirestoreService>();
    return await _firestoreService.updateNoteInFirebase(note.toJson());
  }
}
