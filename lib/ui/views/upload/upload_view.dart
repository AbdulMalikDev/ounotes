import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/notes_links_fields.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/question_paper_fields.dart';
import 'package:FSOUNotes/ui/views/upload/local_widgets/subject_name_field.dart';
import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../shared/app_config.dart';
import 'local_widgets/document_type_selectionView.dart';
import 'local_widgets/syllabus_fields.dart';
import 'local_widgets/upload_button_widget.dart';

class UploadView extends StatefulWidget {
  final String subjectName;
  final Document uploadType;
  UploadView({
    key,
    this.subjectName = "",
    this.uploadType = Document.Notes,
  }) : super(key: key);

  @override
  _UploadViewState createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("calling build function");
    return ViewModelBuilder<UploadViewModel>.reactive(
      onModelReady: (model) {
        model.initialise(widget.uploadType, widget.subjectName);
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          //TODO change this after testing is done
          // return !model.isBusy;
          return true;
        },
        child: Scaffold(
          appBar: BackIconTitleAppBar(
              title: widget.uploadType != null
                  ? "UPLOAD ${Constants.getDocumentNameFromEnum(model.documentType).toUpperCase()}"
                  : "Upload Document"),
          body: model.isBusy
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Please wait...",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Large files may take some time...",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                )
              : Form(
                  key: this._formKey,
                  child: Container(
                    child: SingleChildScrollView(
                      // physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (widget.uploadType == null)
                            DocumentTypeSelectionView(model: model),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SubjectNameField(
                                  key: ValueKey("Subject field"),
                                  model: model,
                                ),
                                model.textFieldsMap == Constants.Syllabus
                                    ? SyllabusFields(
                                        key: ValueKey("Syllabus field"),
                                        model: model,
                                      )
                                    : model.textFieldsMap ==
                                            Constants.QuestionPaper
                                        ? QuestionPaperFields(
                                            key: ValueKey(
                                                "Question paper field"),
                                            model: model,
                                          )
                                        : NoteAndLinkFields(
                                            key: ValueKey(
                                                "Question paper field"),
                                            model: model,
                                          ),
                                SizedBox(
                                  height: 20,
                                ),
                                UploadButtonWidget(
                                  model: model,
                                  formKey: this._formKey,
                                  handleUpload: () async {
                                    //Here I have access to all TextFieldControllers therfore
                                    //I can extract the text and perform my upload logic
                                    model.typeofyear == CourseInfo.yeartype[0]
                                        ? model.setYear =
                                            model.controllerOfYear1.text
                                        : model.setYear =
                                            model.controllerOfYear1.text +
                                                '-' +
                                                model.controllerOfYear2.text;
                                    await model.handleUpload(
                                      model.textFieldController1.text,
                                      model.textFieldController2.text,
                                      model.textFieldController3.text,
                                      model.controllerOfSub.text,
                                      context,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: App(context).appHeight(0.1),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
      viewModelBuilder: () => UploadViewModel(),
    );
  }
}
