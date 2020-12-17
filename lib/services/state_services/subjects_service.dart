import 'dart:convert';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:observable_ish/list/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SubjectsService with ChangeNotifier {
  Logger log = getLogger("SubjectsService");
  FirestoreService _firestoreService = locator<FirestoreService>();
  static List<Subject> fakeData = [
    Subject.namedParameter(
        branch: ["s"], id: 12, name: "ljsdlf", semester: [1, 2])
  ];

  ValueNotifier<List<Subject>> _userSubjects =
      new ValueNotifier(new List<Subject>());

  ValueNotifier<List<Subject>> _allSubjects =
      new ValueNotifier(new List<Subject>());

  void setUserSubjects(users) {
    _userSubjects = users;
  }

  ValueNotifier<List<Subject>> get userSubjects => _userSubjects;
  ValueNotifier<List<Subject>> get allSubjects  => _allSubjects;

  Future<dynamic> addUserSubject(Subject subject) async {
    if (_userSubjects.value.firstWhere(
            (element) =>
                element.name.toLowerCase() == subject.name.toLowerCase(),
            orElse: () => null) !=
        null) {
      print('repeated');
      return "Repeated";
    }
    List<Subject> subs = _userSubjects.value;
    subs.add(subject);
    _userSubjects.value = subs;
    List<Subject> subsr = _allSubjects.value;
    subsr.removeWhere((sub) => sub == subject);
    _allSubjects.value = subsr;
    _userSubjects.notifyListeners();
    _allSubjects.notifyListeners();
    await _saveStateToLocal();
    return null;
  }

  removeUserSubject(Subject subject) async {
    List<Subject> subs = _userSubjects.value;
    subs.remove(subject);
    _userSubjects.value = subs;
    List<Subject> subsr = _allSubjects.value;
    subsr.add(subject);
    _allSubjects.value = subsr;
    _userSubjects.notifyListeners();
    _allSubjects.notifyListeners();
    await _saveStateToLocal();
  }

  removeUserSubjectAtIntex(int index) async {
    List<Subject> subs = _userSubjects.value;
    final Subject subject = subs.removeAt(index);
    _userSubjects.value = subs;
    _userSubjects.notifyListeners();
    await _saveStateToLocal();
    return subject;
  }

  insertUserSubject(int index, Subject subject) async {
    List<Subject> subs = _userSubjects.value;
    subs.insert(index, subject);
    _userSubjects.value = subs;
    _userSubjects.notifyListeners();
    await _saveStateToLocal();
  }

  Subject findSubjectByName(String name) {
    var sub = _allSubjects.value.firstWhere(
      (subject) => subject.name == name,
      orElse: () => null,
    );
    return sub;
  }

  loadSubjects() async {
    SharedPreferencesService pref = locator<SharedPreferencesService>();
    SharedPreferences prefs = await pref.store();
    _allSubjects.value = [];
    _userSubjects.value = [];
    List<Subject> subjectObjects = [];
    var allsubjects;
    //*Try-catch block for retreiving All Subjects
    try {
      //Check if stored in local Storage and retreive
      if (prefs.containsKey("all_subjects")) {
        log.i("all subjects found in local storage");
        List allsubs = json.decode(prefs.getString("all_subjects"));
        subjectObjects = allsubs
            .map((jsonSubject) => Subject.fromData(jsonSubject))
            .toList();

        _allSubjects.value = subjectObjects;
      } else {
        //Get from Firebase
        subjectObjects = await _firestoreService.loadSubjectsFromFirebase();
        if (subjectObjects is String) {
          throw (subjectObjects);
        }
        _allSubjects.value = subjectObjects;
      }

      _allSubjects.notifyListeners();
    } catch (e) {
      log.e("Error occurred");
      String error;
      if (e is PlatformException) error = e.message;
      error = e.toString();
      log.e(error);
      return error;
    }

    subjectObjects = [];
    var subjects;
    //For User subjects
    if (prefs.containsKey("user_subjects")) {
      log.i("user subjects found in local storage");
      List allsubs = json.decode(prefs.getString("user_subjects"));
      subjectObjects =
          allsubs.map((jsonSubject) => Subject.fromData(jsonSubject)).toList();
      _userSubjects.value = subjectObjects;
    } else {
      _userSubjects.value = [];
    }
    _userSubjects.notifyListeners();
  }

  _saveStateToLocal() async {
    SharedPreferencesService sharedPreferencesService =
        locator<SharedPreferencesService>();
    SharedPreferences prefs = await sharedPreferencesService.store();
    List<Map<String, dynamic>> userSubjects =
        _userSubjects.value.map((sub) => sub.toJson()).toList();
    prefs.setString("user_subjects", json.encode(userSubjects));
    List<Map<String, dynamic>> allSubjects =
        _allSubjects.value.map((sub) => sub.toJson()).toList();
    prefs.setString("all_subjects", json.encode(allSubjects));
  }

  //* This was created for getting the subject by name
  //* even if it is in userSubjects or allSubjects does not matter
  Subject getSubjectByName(String subjectName) {
    Subject subject = null;
    List<Subject> allSubs = this.allSubjects.value;
    List<Subject> userSubs = this.userSubjects.value;
    subject = allSubs.firstWhere((subject) => subject.name == subjectName,
        orElse: () => null);
    if (subject == null) {
      subject = userSubs.firstWhere((subject) => subject.name == subjectName,
          orElse: () => null);
    }
    return subject;
  }

  //* Returns all subjects with match atleast one word with any other subject.
  //? Test Input : Database Management Systems
  List<Subject> getSimilarSubjects(String query){
    List<String> queryWords = _sanitizeAndSplitQuery(query);
    List<Subject> matchingSubjects = [];
    List<Subject> allSubjects = this.userSubjects.value + this.allSubjects.value;
    allSubjects.forEach((subject) {
        
        //Skip iteration if same subject
        if(subject.name == query)return; 
        List<String> subjectWords = _sanitizeAndSplitQuery(subject.name);//? [INDUSTRIAL, PHSYCHOLOGY]
        subjectWords.forEach((subjectWord) {
          queryWords.forEach((queryWord) {
            String longWord  = subjectWord.length >= queryWord.length ? subjectWord : queryWord;
            String shortWord = subjectWord.length < queryWord.length ? subjectWord : queryWord;
            if(longWord.contains(shortWord)){
              bool isSimilar = _isSimilar(longWord,shortWord);
              if(isSimilar && !matchingSubjects.contains(subject)){
                matchingSubjects.add(subject);
              }
            }
          });
        });
        
    });
    return matchingSubjects.reversed.toList();
  }

  bool _isSimilar(String longWord, String shortWord) {
    int sameLetters = 0;
    int totalLetters = longWord.length;
    longWord.split("").asMap().forEach((index,longWordChar) { 
      if(index >= shortWord.length)return;
      if(longWordChar == shortWord[index])sameLetters++;
    });
    double percentage = sameLetters/totalLetters * 100;
    int percentageMatchingSet = 90;
    
    return percentage >= percentageMatchingSet;
  }

  List<String> _sanitizeAndSplitQuery(String query) {
    //? [EFFECTIVE, TECHNICAL, COMMUNICATION]
    //? split with "-" for subjects like MATHEMATICS-III
    List<String> queryWords = (query.split(" ") + query.split("-"));
    //? Remove duplicate words
    queryWords.toSet().toList();
    //? Remove words with less than 3 letters like "OF" , "I" etc.
    queryWords.removeWhere((queryWord) => queryWord.length < 3);
    return queryWords;
  }
}
