import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/ui/views/upload/upload_selection/upload_selection_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/SaveButtonView.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../misc/constants.dart';

class UploadSelectionView extends StatelessWidget {
  final String subjectName;
  final bool isFromMainScreen;

  UploadSelectionView(
      {key, this.subjectName = "", this.isFromMainScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadSelectionViewModel>.reactive(
        onModelReady: (model) {
          model.subjectName = subjectName;
        },
        builder: (context, model, child) => Scaffold(
              body: isFromMainScreen
                  ? Container(
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              height: double.infinity,
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text("Select Upload Type",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SaveButtonMainView(
                                      onTap: model.navigateToNotes,
                                      text: "NOTES",
                                    ),
                                    SaveButtonMainView(
                                      onTap: model.navigateToQuestionPapers,
                                      text: "QUESTION PAPERS",
                                    ),
                                    SaveButtonMainView(
                                      onTap: model.navigateToSyllabus,
                                      text: "SYLLABUS",
                                    ),
                                    SaveButtonMainView(
                                      onTap: model.navigateToLinks,
                                      text: "LINKS",
                                    ),
                                    // SaveButtonMainView(
                                    //   onTap: model.navigateToGDRIVELinks,
                                    //   text: "GDRIVE LINK",
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF73AEF5),
                                    Color(0xFF61A4F1),
                                    Color(0xFF478DE0),
                                    Color(0xFF398AE5),
                                  ],
                                  stops: [0.1, 0.4, 0.7, 0.9],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                  vertical: 10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 30),
                                    Text(
                                      "UPLOAD DOCUMENT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 30.0),
                                    SaveButtonView(
                                      onTap: model.navigateToNotes,
                                      text: "NOTES",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SaveButtonView(
                                      onTap: model.navigateToQuestionPapers,
                                      text: "QUESTION PAPERS",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SaveButtonView(
                                      onTap: model.navigateToSyllabus,
                                      text: "SYLLABUS",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SaveButtonView(
                                      onTap: model.navigateToLinks,
                                      text: "LINKS",
                                    ),
                                    SaveButtonView(
                                      onTap: model.navigateToGDRIVELinks,
                                      text: "GDRIVE LINK",
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
        viewModelBuilder: () => UploadSelectionViewModel());
  }
}

class SaveButtonMainView extends StatelessWidget {
  final Function onTap;
  final String text;
  const SaveButtonMainView({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: AppStateNotifier.isDarkModeOn
              ? Constants.mdecoration.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [],
                )
              : Constants.mdecoration.copyWith(
                  color: Theme.of(context).colorScheme.background,
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  text ?? 'NEXT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onBackground,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
