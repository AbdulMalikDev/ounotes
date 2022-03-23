import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddEditSubjectViewModel extends BaseViewModel {
  SubjectsService _subjectsService = locator<SubjectsService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>(); 
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

  addSubject({String subName}) async {

    int id  = await _subjectsService.getNewSubjectID();
    log.e("New subject ID" + id.toString());

    CourseType courseType = Enum.getCourseTypeFromString(_selectedCourseType);
    SubjectType subjectType = Enum.getSubjectTypeFromString(_selectedSubjectType);
    Subject subject = new Subject(
      id,
      subName,
      branchToSem: _branchToSem,
      courseType: courseType,
      subjectType: subjectType,
    );
    log.e(subject.toJson());

    String result = await _subjectsService.addSubject(subject);
    if (result == "ERROR ADDING SUBJECT"){
      await _bottomSheetService.showBottomSheet(title: result);
    }else{
      await _bottomSheetService.showBottomSheet(title: "Successful");
    }
    _navigationService.popRepeated(1);
  }

  editSubject(Subject subject, String name) async {
    log.e("Existing subject ID" + subject.id.toString());
    CourseType courseType = Enum.getCourseTypeFromString(_selectedCourseType);
    SubjectType subjectType = Enum.getSubjectTypeFromString(_selectedSubjectType);
    subject = Subject(
      subject.id,
      name,
      branchToSem: _branchToSem,
      subjectType: subjectType,
      courseType : courseType,
      );
    log.e("Subject changed to " + subject.name);
    String result = await _subjectsService.updateSubject(subject);
    if (result == "SUCCESS ADDING SUBJECT"){
      await _bottomSheetService.showBottomSheet(title: result);
    }else{
      await _bottomSheetService.showBottomSheet(title: "Some error occurred");
    }
    _navigationService.popRepeated(1);
  }
}
