import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditViewModel extends BaseViewModel{

  Logger log = getLogger("UploadViewModel");
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  SubjectsService _subjectsService = locator<SubjectsService>();


  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;

  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> _dropDownMenuItemForTypeYear;
  bool _ischecked = false;

  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;

  List<DropdownMenuItem<String>> get dropdownofyear =>
      _dropDownMenuItemForTypeYear;

  String _selectedSemester;
  String _selectedBranch;
  String _selectedyeartype;

  String _year = '2020';

  String get year => _year;

  set setYear(String year) {
    _year = year;
    notifyListeners();
  }

  String _document;
  String get document => _document;
  String get typeofyear => _selectedyeartype;
  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  bool get ischecked => _ischecked;

  getSuggestions(String query) {
    List<String> subList = getAllSubjectsList();
    final List<String> suggestions = query.isEmpty
        ? []
        : subList
            .where((sub) => sub.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return suggestions;
  }

  List<String> getAllSubjectsList() {
    List<String> userSub =
        _subjectsService.userSubjects.value.map((sub) => sub.name).toList();
    List<String> allSub =
        _subjectsService.allSubjects.value.map((sub) => sub.name).toList();
    List<String> subList = userSub + allSub;
    subList = subList.toSet().toList();
    return subList;
  }

  initialise(Document path) {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semestersInNumbers);
    _dropDownMenuItemForTypeYear =
        buildAndGetDropDownMenuItems(CourseInfo.yeartype);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
    _selectedyeartype = _dropDownMenuItemForTypeYear[0].value;
    _document = Constants.getDocumentNameFromEnum(path);
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = List();
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Text(item)));
    });
    return i;
  }

  void changedDropDownItemOfSemester(String selectedSemester) {
    _selectedSemester = selectedSemester;
    notifyListeners();
  }

  void changedDropDownItemOfBranch(String selectedBranch) {
    _selectedBranch = selectedBranch;
    notifyListeners();
  }

  void changedDropDownItemOfYear(selectedYearType) {
    _selectedyeartype = selectedYearType;
    notifyListeners();
  }

    void changeCheckMark(bool val) {
      _ischecked = val;
      notifyListeners();
    }

  navigatetoPrivacyPolicy() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  navigateToTermsAndConditionView() {
    _navigationService.navigateTo(Routes.termsAndConditionView);
  }

  Future handleUpdate(String text1, String text2, String text3, Document path,
    String subjectName, BuildContext context , document) async {
    //* For all 4 upload screens , there are different text fields and
    //* their value may be different while uploading , so i have used switch case to
    //* handle all 4 situations
    setBusy(true);

    String type;
    var doc;

    switch (path) {
      case Document.Notes:
        type = Constants.notes;
        Note note = document;
        doc = Note(
          subjectName: subjectName,
          path: Document.Notes,
          title: text1,
          author: text2,
          uploadDate: note.uploadDate,
          view: note.view,
          type: type,
          GDriveID: note.GDriveID,
          GDriveLink: note.GDriveLink,
          GDriveNotesFolderID: note.GDriveNotesFolderID,
          firebaseId: note.firebaseId,
          id: note.id,
          isDownloaded: note.isDownloaded,
          size: note.size,
          uploader_id: note.uploader_id,
          url: note.url,
          votes: note.votes, 
        );
        break;
      case Document.QuestionPapers:
        QuestionPaper paper = document;
        type = Constants.questionPapers;
        doc = QuestionPaper(
          subjectName: subjectName,
          path: Document.QuestionPapers,
          title: text1,
          branch: text2,
          year: text1,
          type: type,
          GDriveID: paper.GDriveID,
          GDriveLink: paper.GDriveLink,
          GDriveQuestionPaperFolderID:paper.GDriveQuestionPaperFolderID,
          id: paper.id,
          isDownloaded: paper.isDownloaded,
          note: paper.note,
          size: paper.size,
          uploadDate: paper.uploadDate,
          uploader_id: paper.uploader_id,
          url: paper.url,
        );
        break;
      case Document.Syllabus:
        Syllabus paper = document;
        type = Constants.syllabus;
        doc = Syllabus(
          title: "$text1$text2",
          subjectName: subjectName,
          path: Document.Syllabus,
          type: type,
          semester: text1,
          branch: text2,
          year: text3,
          GDriveID: paper.GDriveID,
          GDriveLink: paper.GDriveLink,
          GDriveSyllabusFolderID: paper.GDriveSyllabusFolderID,
          id: paper.id,
          isDownloaded: paper.isDownloaded,
          note: paper.note,
          size: paper.size,
          uploadDate: paper.uploadDate,
          uploader_id: paper.uploader_id,
          url: paper.url, 
        );
        break;
      case Document.Links:
        Link link = document;
        type = Constants.links;
        doc = Link(
          subjectName: subjectName,
          title: text1,
          description: text2,
          linkUrl: text3,
          path: Document.Links,
          id: link.id,
          uploader_id: link.uploader_id,
        );
        break;
      case Document.None:
      case Document.UploadLog:
      case Document.Drawer:
      case Document.Report:
      default:
        break;
    }

      _firestoreService.updateDocument(doc, path);
      setBusy(false);
      _navigationService.popRepeated(1);
    }

  
}