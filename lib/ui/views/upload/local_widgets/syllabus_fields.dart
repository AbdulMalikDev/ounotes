import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/dropdownview.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/year_widget.dart';
import 'package:FSOUNotes/ui/views/upload/web_upload_document/web_document_edit_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../../AppTheme/AppStateNotifier.dart';
import '../../../../misc/constants.dart';
import '../../../shared/app_config.dart';

class SyllabusFields extends StatefulWidget {
  final int index;
  final WebDocumentEditViewModel model;
  const SyllabusFields({Key key, this.model, this.index}) : super(key: key);

  @override
  State<SyllabusFields> createState() => _SyllabusFieldsState();
}

class _SyllabusFieldsState extends State<SyllabusFields> {
  TextEditingController controllerOfYear1 = TextEditingController();
  TextEditingController controllerOfYear2 = TextEditingController();
  List<DropdownMenuItem<String>> dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> dropDownMenuItemForTypeYear;

  Syllabus doc;

  String selectedSemester;
  String selectedBranch;
  String selectedyeartype;

  @override
  void initState() {
    dropDownMenuItemsofBranch = buildAndGetDropDownMenuItems(CourseInfo.branch);
    dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semestersInNumbers);
    dropDownMenuItemForTypeYear =
        buildAndGetDropDownMenuItems(CourseInfo.yeartype);
    selectedSemester = dropDownMenuItemsofsemester[0].value;
    selectedBranch = dropDownMenuItemsofBranch[0].value;
    selectedyeartype = dropDownMenuItemForTypeYear[0].value;
    doc = widget.model.documents[widget.index];
    doc.semester = selectedSemester;
    doc.branch = selectedBranch;
    super.initState();
  }

  void updateDocument() {
    widget.model.documents[widget.index] = doc;
    print("updated document with index ${widget.index}");
    Syllabus n = widget.model.documents[widget.index];
    print(n.semester);
    print(n.branch);
    print(n.year);
  }

  @override
  Widget build(BuildContext context) {
    double wp = App(context).appWidth(1);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: App(context).appWidth(0.2), vertical: 20),
      decoration: AppStateNotifier.isDarkModeOn
          ? Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [],
            )
          : Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              "File Name : ${widget.model.files[widget.index].name}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: App(context).appScreenHeightWithOutSafeArea(0.15),
                    width: App(context).appScreenWidthWithOutSafeArea(0.1),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pdf.png',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Open",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: wp * 0.4,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropDownView(
                        isExpanded: true,
                        title: "Select Semester",
                        value: selectedSemester,
                        items: dropDownMenuItemsofsemester,
                        onChanged: changedDropDownItemOfSemester,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDownView(
                        isExpanded: true,
                        title: "Select Branch",
                        value: selectedBranch,
                        items: dropDownMenuItemsofBranch,
                        onChanged: changedDropDownItemOfBranch,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      YearFieldWidget(
                        controllerOfYear1: controllerOfYear1,
                        controllerOfYear2: controllerOfYear2,
                        typeofyear: selectedyeartype,
                        dropdownofyear: dropDownMenuItemForTypeYear,
                        changedDropDownItemOfYear: changedDropDownItemOfYear,
                        onChangedYearField: onChangedYearField,
                      ),
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = [];
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Center(child: Text(item))));
    });
    return i;
  }

  void changedDropDownItemOfSemester(String sem) {
    setState(() {
      selectedSemester = sem;
      doc.semester = sem;
      updateDocument();
    });
  }

  void changedDropDownItemOfBranch(String br) {
    setState(() {
      selectedBranch = br;
      doc.branch = br;
      updateDocument();
    });
  }

  void changedDropDownItemOfYear(type) {
    setState(() {
      selectedyeartype = type;
      onChangedYearField(type);
    });
  }

  void onChangedYearField(String value) {
    if (selectedyeartype == CourseInfo.yeartype[0]) {
      doc.year = controllerOfYear1.text;
    } else {
      doc.year = controllerOfYear1.text + '-' + controllerOfYear2.text;
    }
    updateDocument();
  }
}
