import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("UploadLogEditViewModel");

class UploadLogEditViewModel extends BaseViewModel {
  SubjectsService _subjectsService = locator<SubjectsService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofdocumentType;

  String _selectedSemester;
  String _selectedBranch;
  String _selecteddocumentType;
  Document _documentEnum;
  AbstractDocument _doc;
  UploadLog uploadLog;

  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  String get documentType => _selecteddocumentType;
  Document get documentEnum => _documentEnum;
  AbstractDocument get doc => _doc;

  set selectedSemester(String value) => _selectedSemester = value;
  set selectedBranch(String value) => _selectedBranch = value;

  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> get dropdownofdocumentType =>
      _dropDownMenuItemsofdocumentType;

  init(UploadLog uploadLog) async {
    this.uploadLog = uploadLog;
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semestersInNumbers);
    _dropDownMenuItemsofdocumentType =
        buildAndGetDropDownMenuItems2(Document.values);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
    _documentEnum = Constants.getDocFromConstant(uploadLog.type);
    _selecteddocumentType = _documentEnum.toString();
    // _doc = await _firestoreService.getDocumentById(
    //     uploadLog.subjectName, uploadLog.id, _documentEnum);
    return await Future.value(true);
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = List();
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Text(item)));
    });
    return i;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List items) {
    List<DropdownMenuItem<String>> i = List();
    items.forEach((item) {
      i.add(DropdownMenuItem(
          value: item.toString(), child: Text(item.toString())));
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

  void changedDropDownItemOfdocumentType(String selecteddocumentType) {
    _documentEnum = Enum.getDocumentFromString(selecteddocumentType);
    print(_documentEnum);
    print(selecteddocumentType);
    _selecteddocumentType = selecteddocumentType;
    notifyListeners();
  }

  List<String> getSuggestions(String query) {
    List<String> subList = getAllSubjectsList();
    log.e(subList);
    final List<String> suggestions = query.isEmpty
        ? []
        : subList
            .where((sub) => sub.toLowerCase().startsWith(query.toLowerCase()))
            .toList()
            .cast<String>();
    return suggestions;
  }

  List<String> getAllSubjectsList() {
    List<String> userSub = _subjectsService.userSubjects.value
        .map((sub) => sub.name)
        .toList()
        .cast<String>();
    List<String> allSub = _subjectsService.allSubjects.value
        .map((sub) => sub.name)
        .toList()
        .cast<String>();
    List<String> subList = userSub + allSub;
    subList = subList.toSet().toList().cast<String>();
    return subList;
  }

  void onSubmit(
      TextEditingController subjectNameController,
      TextEditingController titleController,
      TextEditingController authorController,
      TextEditingController yearController) async {
    setBusy(true);
    Subject subject =
        _subjectsService.getSubjectByName(subjectNameController.text);
    AbstractDocument docUploaded = await _firestoreService.getDocumentById(
        uploadLog.subjectName,
        uploadLog.id,
        Constants.getDocFromConstant(uploadLog.type));
    AbstractDocument doc;
    switch (_documentEnum) {
      case Document.Notes:
        doc = Note(
          subjectName: subjectNameController.text,
          path: Document.Notes,
          title: titleController.text,
          author: authorController.text,
          type: Constants.getConstantFromDoc(_documentEnum),
          subjectId: subject?.id,
          size: uploadLog.size,
          uploader_id: uploadLog.uploader_id,
          view: 0,
          votes: 0,
          uploadDate: DateTime.now(),
          url: docUploaded.url,
        );
        log.e(doc.toJson());
        break;
      case Document.QuestionPapers:
        doc = QuestionPaper(
          subjectName: subjectNameController.text,
          path: Document.QuestionPapers,
          title: titleController.text,
          branch: _selectedBranch,
          year: yearController.text,
          type: Constants.getConstantFromDoc(_documentEnum),
          subjectId: subject?.id,
          size: uploadLog.size,
          uploader_id: uploadLog.uploader_id,
          uploadDate: DateTime.now(),
          url: docUploaded.url,
        );
        log.e(doc.toJson());
        break;
      case Document.Syllabus:
        doc = Syllabus(
          title: titleController.text,
          subjectName: subjectNameController.text,
          path: Document.Syllabus,
          type: Constants.getConstantFromDoc(_documentEnum),
          semester: _selectedSemester,
          branch: _selectedBranch,
          year: yearController.text,
          subjectId: subject?.id,
          size: uploadLog.size,
          uploader_id: uploadLog.uploader_id,
          uploadDate: DateTime.now(),
          url: docUploaded.url,
        );
        log.e(doc.toJson());
        break;
      case Document.Links:
        doc = Link(
          subjectName: subjectNameController.text,
          title: titleController.text,
          path: Document.Links,
          subjectId: subject?.id,
          uploader_id: uploadLog.uploader_id,
        );
        log.e(doc.toJson());
        break;
      case Document.None:
      case Document.Drawer:
      case Document.UploadLog:
      case Document.Report:
      case Document.UploadLog:
      case Document.Report:
      case Document.Random:
        break;
      case Document.GDRIVE:
        break;
    }
    if (doc.path != Document.Links) {
      SheetResponse response = await _bottomSheetService.showBottomSheet(
        title: "Are you sure you want to update?",
        description: "",
      );
      log.e(response?.confirmed);
      if (response == null || (response != null && !response.confirmed)) {
        setBusy(false);
        return;
      }
      
      //Delete old firestore objects and it's upload log
      await _firestoreService.deleteTempDocumentById(
          uploadLog.id, Constants.getDocFromConstant(uploadLog.type));
      await _firestoreService.deleteTempDocumentById(
          uploadLog.id, Document.UploadLog);

      //Upload new objects
      if (doc.path != Document.Links)
        await _firestoreService.saveNotes(doc);
      else
        await _firestoreService.saveLink(doc);
      log.e(_documentEnum);
      log.e(doc.toJson());
    }
    setBusy(false);
  }
}
