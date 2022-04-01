import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/pdfWeb.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../enums/constants.dart';
import '../../../shared/app_config.dart';
import '../local_widgets/notes_fields.dart';
import '../local_widgets/question_paper_fields.dart';
import '../local_widgets/syllabus_fields.dart';
import 'web_document_edit_viewmodel.dart';

class WebDocumentEditView extends StatefulWidget {
  final List<PdfWeb> files;
  final AbstractDocument document;
  final Map textFieldsMap;
  const WebDocumentEditView(
      {Key key, this.files, this.textFieldsMap, this.document})
      : super(key: key);
  @override
  _WebDocumentEditViewState createState() => _WebDocumentEditViewState();
}

class _WebDocumentEditViewState extends State<WebDocumentEditView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print(widget.textFieldsMap);
    return ViewModelBuilder<WebDocumentEditViewModel>.reactive(
      viewModelBuilder: () => WebDocumentEditViewModel(),
      onModelReady: (model) {
        model.init(
          widget.files,
          widget.textFieldsMap,
          widget.document,
        );
      },
      builder: (
        BuildContext context,
        WebDocumentEditViewModel model,
        Widget child,
      ) {
        return Scaffold(
          appBar: BackIconTitleAppBar(title: "Upload Documents"),
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
                  key: _formKey,
                  child: Container(
                    // margin: EdgeInsets.symmetric(
                    //     horizontal: App(context).appHeight(0.2)),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < widget.files.length; i++)
                           widget.document.type == Constants.notes
                                ? NoteFields(
                                    index: i,
                                    model: model,
                                  )
                                :   widget.document.type == Constants.syllabus
                                    ? SyllabusFields(
                                        model: model,
                                        index: i,
                                      )
                                    :  widget.document.type == Constants.questionPapers
                                        ? QuestionPaperFields(
                                            index: i,
                                            model: model,
                                          )
                                        : Container(),
                          FractionallySizedBox(
                            widthFactor: 0.3,
                            child: Container(
                              height: App(context).appHeight(0.06),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!_formKey.currentState.validate()) {
                                    // Invalid!
                                    return;
                                  }
                                  await model.handleUpload();
                                },
                                style: ElevatedButton.styleFrom(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white),
                                  primary: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: new Text(
                                  "Upload",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
