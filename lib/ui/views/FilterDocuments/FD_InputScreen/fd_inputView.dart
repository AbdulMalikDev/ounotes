import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputViewmodel.dart';
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
              Center(
                child: Container(
                  height: App(context).appHeight(0.13),
                  width: App(context).appWidth(1) - 40,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: AppStateNotifier.isDarkModeOn
                      ? Constants.mdecoration.copyWith(
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [],
                        )
                      : Constants.mdecoration
                          .copyWith(color: theme.scaffoldBackgroundColor),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Select Semester",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Container(
                          child: DropdownButton(
                            value: model.sem,
                            items: model.dropdownofsem,
                            onChanged: model.changedDropDownItemOfSemester,
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
                height: 20,
              ),
              Container(
                height: App(context).appHeight(0.13),
                width: App(context).appHeight(1) - 40,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: AppStateNotifier.isDarkModeOn
                    ? Constants.mdecoration.copyWith(
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [],
                      )
                    : Constants.mdecoration
                        .copyWith(color: theme.scaffoldBackgroundColor),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Select Branch",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 20),
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
                          onChanged: model.changedDropDownItemOfBranch,
                          style:
                              theme.textTheme.subtitle1.copyWith(fontSize: 17),
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: App(context).appScreenHeightWithOutSafeArea(0.06),
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  height: 55,
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
                          horizontal: 25.0, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: new Text(
                      "Search",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => FDInputViewModel(),
    );
  }
}

class DocumentTypeCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool isQuestionPaper;
  final bool isSelected;
  final Function onPressed;
  const DocumentTypeCard(
      {Key key,
      this.icon,
      this.title,
      this.isQuestionPaper = false,
      this.isSelected = false,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subtitle1 = Theme.of(context).textTheme.subtitle1.copyWith(
          fontSize: isQuestionPaper ? 12 : 16,
          color: (AppStateNotifier.isDarkModeOn || isSelected)
              ? Colors.white
              : Colors.black,
        );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.background,
        ),
        width: App(context).appWidth(0.4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                title,
                style: subtitle1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
