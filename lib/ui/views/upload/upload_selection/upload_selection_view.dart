import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/upload/upload_selection/upload_selection_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../misc/constants.dart';

class UploadSelectionView extends StatelessWidget {
  UploadSelectionView({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadSelectionViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              body: Container(
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
                                  style: Theme.of(context).textTheme.headline6),
                              SizedBox(
                                height: 18,
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
        margin: EdgeInsets.symmetric(vertical: 10),
        height: App(context).appScreenWidthWithOutSafeArea(0.23),
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
