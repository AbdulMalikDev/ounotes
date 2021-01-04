import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/admin/AddEditSubject/textFormField.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_detail/upload_log_edit/upload_log_edit_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:stacked/stacked.dart';

class UploadLogEditView extends StatefulWidget {
  final UploadLog uploadLog;
  UploadLogEditView({this.uploadLog, Key key}) : super(key: key);

  @override
  _UploadLogEditViewState createState() => _UploadLogEditViewState();
}

class _UploadLogEditViewState extends State<UploadLogEditView> {
  TextEditingController subjectNameController = TextEditingController();

  TextEditingController titleController = TextEditingController();

  TextEditingController authorController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<UploadLogEditViewModel>.reactive(
      viewModelBuilder: () => UploadLogEditViewModel(),
      onModelReady: (model) async {
        await model.init(widget.uploadLog);
        subjectNameController =
            TextEditingController(text: widget.uploadLog?.subjectName ?? "");
        titleController = TextEditingController(
            text: widget.uploadLog?.fileName?.toString() ?? "");
        switch(model.documentEnum){
          case Document.Notes:
            authorController = TextEditingController(text:(model.doc as Note).author);
            break;
          case Document.Syllabus:
              model.selectedSemester = (model.doc as Syllabus).semester;
              model.selectedBranch = (model.doc as Syllabus).branch;
              yearController = TextEditingController(text:(model.doc as Syllabus).year);
              break;
          case Document.QuestionPapers:
            print("questionPaper");
            model.selectedBranch = (model.doc as QuestionPaper).branch;
            print(model.br);
            yearController = TextEditingController(text:(model.doc as QuestionPaper).year);
            break;
          case Document.Links:
          case Document.Drawer:
          case Document.UploadLog:
          case Document.Report:
          case Document.None:
            break;
        }
        setState(() {});
      },
      builder: (
        BuildContext context,
        UploadLogEditViewModel model,
        Widget child,
      ) {
        return SafeArea(
          child: Scaffold(
            body:
            model.isBusy
            ?Container(child: Center(child:CircularProgressIndicator()),) 
            :Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "EDIT",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                TextSpan(text: '  '),
                                TextSpan(
                                    text: 'VIEW',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: App(context).appHeight(0.13),
                      width: App(context).appWidth(1) - 40,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      decoration: Constants.mdecoration.copyWith(
                        color: theme.scaffoldBackgroundColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Select Document Type",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: Container(
                              child: DropdownButton(
                                focusColor: Colors.transparent,
                                value: model.documentType,
                                items: model.dropdownofdocumentType,
                                onChanged: (_){
                                        model.changedDropDownItemOfdocumentType(_);
                                        setState(() {});
                                    },
                                style: theme.textTheme.subtitle1
                                    .copyWith(fontSize: 17),
                                dropdownColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      // decoration: Constants.mdecoration.copyWith(
                      //   color: theme.scaffoldBackgroundColor,
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            color: Colors.transparent,
                            child: Container(
                              decoration: Constants.kBoxDecorationStyle,
                              height: 60,
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: subjectNameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 15.0),
                                    prefixIcon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.blue,
                                    ),
                                    hintText: "Indian Constitution ...",
                                    hintStyle: Constants.kLabelStyle,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: -0.03,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return model.getSuggestions(pattern);
                                  // return ["s"];
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(fontSize: 15),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) {
                                  this.subjectNameController.text = suggestion;
                                },
                                errorBuilder:
                                    (BuildContext context, Object error) => Text(
                                  '$error',
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please select a subjectname';
                                  } else if (value.length < 3 ||
                                      !model.getAllSubjectsList().contains(value))
                                    return "Please enter a valid subject name";
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormFieldView(
                        heading: 'Title of Document',
                        hintText: 'Enter Title',
                        controller: titleController,
                        validator: (value) {
                          if (value.length < 6) return 'Min length-6';
                          return null;
                        },
                      ),
                    ),
                    if(model.documentEnum == Document.Notes)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormFieldView(
                        heading: 'Author of Document',
                        hintText: 'Enter author',
                        controller: authorController,
                        validator: (value) {
                          if (value.length < 6) return 'Min length-6';
                          return null;
                        },
                      ),
                    ),
                    if(model.documentEnum == Document.QuestionPapers || model.documentEnum == Document.Syllabus)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormFieldView(
                        heading: 'Select Year',
                        hintText: 'Enter year',
                        controller: yearController,
                        validator: (value) {
                          if (value.length < 6) return 'Min length-6';
                          return null;
                        },
                      ),
                    ),
                    if(model.documentEnum == Document.QuestionPapers || model.documentEnum == Document.Syllabus)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: App(context).appHeight(0.13),
                            width: App(context).appWidth(0.5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            decoration: Constants.mdecoration.copyWith(
                              color: theme.scaffoldBackgroundColor,
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Select Branch",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    child: DropdownButton(
                                      focusColor: Colors.transparent,
                                      value: model.br,
                                      items: model.dropdownofbr,
                                      onChanged:
                                          model.changedDropDownItemOfBranch,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 17),
                                      dropdownColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(model.documentEnum == Document.Syllabus)
                        Expanded(
                          child: Center(
                            child: Container(
                              height: App(context).appHeight(0.13),
                              width: App(context).appWidth(0.5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              decoration: Constants.mdecoration.copyWith(
                                  color: theme.scaffoldBackgroundColor),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Select Semester",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: DropdownButton(
                                        value: model.sem,
                                        items: model.dropdownofsem,
                                        onChanged: (_){
                                            model.changedDropDownItemOfSemester(_);
                                            setState(() {});
                                        },
                                        dropdownColor:
                                            theme.scaffoldBackgroundColor,
                                        style: theme.textTheme.subtitle1
                                            .copyWith(fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                     Align(
                            child: Container(
                              height: 45,
                              width: 180,
                              margin: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FlatButton(
                                  onPressed: () {
                                    model.onSubmit(
                                      subjectNameController,
                                      titleController,
                                      authorController,
                                      yearController,
                                    );
                                  },
                                  child: Text(
                                    "UPDATE",
                                    style: listTitleDefaultTextStyle.copyWith(
                                        fontSize: 18),
                                  ),
                                  color: primary,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
