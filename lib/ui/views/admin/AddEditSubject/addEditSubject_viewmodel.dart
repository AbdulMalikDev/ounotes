import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class AddEditSubjectViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Widget> _children = [];

  List<Widget> get children => _children;
  Map<String, List<String>> _branchToSem = {};

  Map<String, List<String>> get branchToSem => _branchToSem;

  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofCourseType;
  List<DropdownMenuItem<String>> _dropDownMenuItemsofSubjectType;
  String _selectedSemester;
  String _selectedBranch;
  String _selectedCourseType;
  String _selectedSubjectType;

  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  String get courseType => _selectedCourseType;
  String get subType => _selectedSubjectType;
  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> get dropdownofcourseType =>
      _dropDownMenuItemsofCourseType;
  List<DropdownMenuItem<String>> get dropdownofsubjectType =>
      _dropDownMenuItemsofSubjectType;

  init() {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semestersInNumbers);
    _dropDownMenuItemsofCourseType =
        buildAndGetDropDownMenuItems2(CourseType.values);
    _dropDownMenuItemsofSubjectType =
        buildAndGetDropDownMenuItems2(SubjectType.values);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
    _selectedSubjectType = _dropDownMenuItemsofSubjectType[0].value.toString();
    _selectedCourseType = _dropDownMenuItemsofCourseType[0].value.toString();
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

  void changedDropDownItemOfCourseType(String selectedCourseType) {
    _selectedCourseType = selectedCourseType;
    notifyListeners();
  }

  void changedDropDownItemOfSubjecType(String selectedSubjectType) {
    _selectedSubjectType = selectedSubjectType;
    notifyListeners();
  }

  createBranchToSemList(
    Map<String, List<String>> branchToSem,
    BuildContext context,
  ) {
    _branchToSem = branchToSem;
    branchToSem.forEach((key, val) {
      children.add(buildBrToSemWidget(context, key, val.toString()));
    });
    notifyListeners();
  }

  updateCourseAndSubjectType(String courseType, String subjectType) {
    _selectedCourseType = courseType;
    _selectedSubjectType = subjectType;
  }

  Widget buildBrToSemWidget(
      BuildContext context, String branch, String semList) {
    return Container(
      height: App(context).appScreenHeightWithOutSafeArea(0.086),
      width: App(context).appScreenWidthWithOutSafeArea(1) - 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.3, color: Colors.black26),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: Colors.black,
            spreadRadius: -10,
            blurRadius: 14,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      alignment: Alignment.center,
      child: Center(
        child: ListTile(
          title: Text(branch + " : " + semList),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            onPressed: () {
              _branchToSem.remove(branch);
              _children = [];
              createBranchToSemList(_branchToSem, context);
              notifyListeners();
            },
          ),
        ),
      ),
    );
  }

  addBranchToSemEntry(BuildContext context, String branch, String sem) {
    setBusy(true);
    if (_branchToSem[branch] != null) {
      if (_branchToSem[branch].contains(sem)) {
        setBusy(false);
        Fluttertoast.showToast(
            msg: "The pair $branch : $sem is already present in the list...");
        return;
      }
      _branchToSem[branch].add(sem);
      _children = [];
      createBranchToSemList(_branchToSem, context);
    } else {
      _branchToSem.addAll({
        branch: [sem]
      });
      children.add(buildBrToSemWidget(context, br, sem));
    }

    setBusy(false);
    notifyListeners();
  }

  addSubject({String id, String subName}) {
    CourseType courseType = _selectedCourseType as CourseType;
    SubjectType subjectType = _selectedSubjectType as SubjectType;
    Subject sub = new Subject(
      int.parse(id),
      subName,
      branchToSem: _branchToSem,
      courseType: courseType,
      subjectType: subjectType,
    );
    // _firestoreService.addSubject(sub);
  }

  editSubject(
    String id,
    String name,
  ) {
    
    Map<dynamic, dynamic> sub = {
      "id": id,
      "name": name,
      "branchToSem": _branchToSem,
      // "gdriveFolderID": gdriveFolderID,
      // "gdriveNotesFolderID": gdriveNotesFolderID,
      // "gdriveQuestionPapersFolderID": gdriveQuestionPapersFolderID,
      // "gdriveSyllabusFolderID": gdriveSyllabusFolderID,
      "subjectType": _selectedSubjectType,
      "courseType": _selectedCourseType
    };
    // _firestoreService.updateSubjectInFirebase(sub);
  }
}
