import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputViewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/document_type_card.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_card.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FDInputView extends StatelessWidget {
  const FDInputView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ViewModelBuilder<FDInputViewModel>.reactive(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width - 40,
                child: Center(
                  child: Text(
                    model.titleOfNotes ?? "",
                    style: theme.textTheme.subtitle1.copyWith(
                      decorationStyle: TextDecorationStyle.dashed,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Wrap(
                    children: [
                      DocumentTypeCard(
                        title: "Notes",
                        icon: Icon(
                          Icons.description,
                          color: model.documentType == Document.Notes
                              ? Colors.white
                              : Colors.black,
                        ),
                        isSelected: model.documentType == Document.Notes,
                        onPressed: () {
                          model.setDocumentType = Document.Notes;
                        },
                      ),
                      DocumentTypeCard(
                        title: "Question Papers",
                        icon: Icon(
                          Icons.help_center,
                          color: model.documentType == Document.QuestionPapers
                              ? Colors.white
                              : Colors.black,
                        ),
                        isQuestionPaper: true,
                        isSelected:
                            model.documentType == Document.QuestionPapers,
                        onPressed: () {
                          model.setDocumentType = Document.QuestionPapers;
                        },
                      ),
                      DocumentTypeCard(
                        title: "Syllabus",
                        icon: Icon(
                          Icons.event_note,
                          color: model.documentType == Document.Syllabus
                              ? Colors.white
                              : Colors.black,
                        ),
                        isSelected: model.documentType == Document.Syllabus,
                        onPressed: () {
                          model.setDocumentType = Document.Syllabus;
                        },
                      ),
                      DocumentTypeCard(
                        title: "Links",
                        icon: Icon(
                          Icons.link,
                          color: model.documentType == Document.Links
                              ? Colors.white
                              : Colors.black,
                        ),
                        isSelected: model.documentType == Document.Links,
                        onPressed: () {
                          model.setDocumentType = Document.Links;
                        },
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SelectionCard(
                      isExpanded: true,
                      title: "Select Branch",
                      value: model.br,
                      items: model.dropdownofbr,
                      onChanged: model.changedDropDownItemOfBranch,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SelectionCard(
                      isExpanded: true,
                      title: "Select Semester",
                      value: model.sem,
                      items: model.dropdownofsem,
                      onChanged: model.changedDropDownItemOfSemester,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: App(context).appScreenHeightWithOutSafeArea(0.06),
              ),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Container(
                  height: App(context).appHeight(0.05),
                  child: ElevatedButton(
                    onPressed: () {
                      model.onSearchButtonPressed();
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
                      "Search",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: App(context).appHeight(0.15),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => FDInputViewModel(),
    );
  }
}
