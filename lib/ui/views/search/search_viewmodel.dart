import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/subject.dart';

import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  Logger log = getLogger("SuggestionListViewModel");
  SubjectsService _subjectsService = locator<SubjectsService>();
  DialogService _dialogService = locator<DialogService>();

  String _subject = "";

  String get subject => _subject;

  List<String> _allSubjects = [];

  ValueNotifier<List<Subject>> get allSubjects => _subjectsService.allSubjects;

  List<String> getSuggestions(String query) {
    return _allSubjects
        .where((sub) => sub.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }

   onSelected({String suggestion}) {
      var subject = _subjectsService.findSubjectByName(suggestion);

    if (subject == null) {
      log.e("Subject with Search suggestion/query not found");
    }
    var result = _subjectsService.addUserSubject(subject);
    if (result is String) {
      Fluttertoast.showToast(msg: "Subject Already added");
    }else{
       Fluttertoast.showToast(
        msg: "$suggestion added to your list of subjects...");
    }
    notifyListeners();
   
  }

  setParams({String sub, Path path}) {
    _subject = sub;
  }

  handleStartUpLogic() {
    _allSubjects = _subjectsService.allSubjects.value
        .map((sub) => sub.name)
        .toList()
        .toSet()
        .toList();
    notifyListeners();
  }
}
