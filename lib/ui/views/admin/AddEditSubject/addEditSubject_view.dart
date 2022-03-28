import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/admin/AddEditSubject/addEditSubject_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddEditSubjectView extends StatefulWidget {
  final Subject subject;

  const AddEditSubjectView({Key key, this.subject}) : super(key: key);
  @override
  _AddEditSubjectViewState createState() => _AddEditSubjectViewState();
}

class _AddEditSubjectViewState extends State<AddEditSubjectView> {
  TextEditingController controllerForSubjectName;
  TextEditingController controllerForSubjectID;
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<AddEditSubjectViewModel>.reactive(
      onModelReady: (model) {
        controllerForSubjectName =
            TextEditingController(text: widget.subject?.name ?? "");
        controllerForSubjectID =
            TextEditingController(text: widget.subject?.id?.toString() ?? "");
        model.init();
        model.createBranchToSemList(widget.subject?.branchToSem ?? {}, context);
        if (widget.subject != null) {
          model.updateCourseAndSubjectType(
            widget.subject?.courseType?.toString(),
            widget.subject?.subjectType?.toString(),
          );
        }
      },
      viewModelBuilder: () => AddEditSubjectViewModel(),
      builder: (
        BuildContext context,
        AddEditSubjectViewModel model,
        Widget child,
      ) {
        return SafeArea(
          child: Scaffold(
            body: Form(
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
                                  text: widget.subject != null ? 'Edit' : 'Add',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                TextSpan(text: '  '),
                                TextSpan(
                                    text: 'Subject',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 10),
                    //   child: TextFormFieldView(
                    //     heading: 'Subject ID',
                    //     hintText: 'Enter subject ID',
                    //     controller: controllerForSubjectID,
                    //     validator: (value) {
                    //       if (value.length < 6) return 'Min length-6';
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormFieldView(
                        heading: 'Subject Name',
                        hintText: 'Enter subject Name',
                        controller: controllerForSubjectName,
                        validator: (value) {
                          if (value.length < 6) return 'Min length-6';
                          return null;
                        },
                      ),
                    ),
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
                            "Select CourseType",
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
                                value: model.courseType,
                                items: model.dropdownofcourseType,
                                onChanged:
                                    model.changedDropDownItemOfCourseType,
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
                    Center(
                      child: Container(
                        height: App(context).appHeight(0.13),
                        width: App(context).appWidth(1) - 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: Constants.mdecoration
                            .copyWith(color: theme.scaffoldBackgroundColor),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Select SubjectType",
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
                                  value: model.subType,
                                  items: model.dropdownofsubjectType,
                                  onChanged:
                                      model.changedDropDownItemOfSubjecType,
                                  dropdownColor: theme.scaffoldBackgroundColor,
                                  style: theme.textTheme.subtitle1
                                      .copyWith(fontSize: 17),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Map of Branch to sem",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    model.isBusy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            margin: const EdgeInsets.all(10),
                            child: model.children.length == 0
                                ? Center(
                                    child: Text("List is empty..."),
                                  )
                                : Column(children: model.children),
                          ),
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
                                        onChanged:
                                            model.changedDropDownItemOfSemester,
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
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 30,
                        width: 100,
                        margin: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: FlatButton(
                            onPressed: () {
                              model.addBranchToSemEntry(
                                  context, model.br, model.sem);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Add",
                                  style: listTitleDefaultTextStyle.copyWith(
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    widget.subject != null
                        ? Align(
                            child: Container(
                              height: 45,
                              width: 180,
                              margin: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FlatButton(
                                  onPressed: () {
                                    model.editSubject(widget.subject,controllerForSubjectName.text.trim().toUpperCase());
                                  },
                                  child: Text(
                                    "Edit Subject",
                                    style: listTitleDefaultTextStyle.copyWith(
                                        fontSize: 15),
                                  ),
                                  color: primary,
                                ),
                              ),
                            ),
                          )
                        : Align(
                            child: Container(
                              height: 45,
                              width: 180,
                              margin: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FlatButton(
                                  onPressed: () {
                                    model.addSubject(subName: controllerForSubjectName.text.trim().toUpperCase());
                                  },
                                  child: Text(
                                    "Add Subject",
                                    style: listTitleDefaultTextStyle.copyWith(
                                        fontSize: 15),
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
