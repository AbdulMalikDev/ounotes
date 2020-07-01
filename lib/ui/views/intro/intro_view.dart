import 'dart:io';

import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/course_info.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/shared/ui_helper.dart';
import 'package:FSOUNotes/ui/views/Intro/intro_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/expantion_list.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key key}) : super(key: key);

  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titletheme = theme.textTheme.headline6
        .copyWith(fontSize: 20, fontWeight: FontWeight.w400);
    var dropdowntitletheme = theme.textTheme.headline6
        .copyWith(fontSize: 18, fontWeight: FontWeight.w400);
    return ViewModelBuilder<IntroViewModel>.reactive(
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return ModalProgressHUD(
          inAsyncCall: model.isBusy ? true : false,
          opacity: 0.5,
          progressIndicator: circularProgress(),
          child: WillPopScope(
            onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                backgroundColor: theme.scaffoldBackgroundColor,
                title: Row(
                  children: <Widget>[
                    Icon(Icons.warning),
                    Text(
                      'Warning',
                      style: theme.textTheme.headline6,
                    ),
                  ],
                ),
                content: Text(
                  'Do you really want to exit',
                  style: theme.textTheme.headline6.copyWith(fontSize: 18),
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      'No',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 17),
                    ),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  FlatButton(
                    child: Text(
                      'Yes',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 17),
                    ),
                    onPressed: () => exit(0),
                  ),
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("Welcome",
                    style: theme.appBarTheme.textTheme.headline6),
              ),
              body: Container(
                //  height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height:
                            App(context).appScreenHeightWithOutSafeArea(0.16),
                        width: App(context).appScreenWidthWithOutSafeArea(0.4),
                        child: Image.asset("assets/images/apnaicon.png"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('OU Notes', style: titletheme),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height:
                              App(context).appScreenHeightWithOutSafeArea(0.13),
                          width:
                              App(context).appScreenHeightWithOutSafeArea(1) -
                                  40,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: theme.colorScheme.background,
                            boxShadow: AppStateNotifier.isDarkModeOn
                                ? []
                                : [
                                    BoxShadow(
                                        offset: Offset(10, 10),
                                        color: theme.cardTheme.shadowColor,
                                        blurRadius: 25),
                                    BoxShadow(
                                        offset: Offset(-10, -10),
                                        color: theme.cardTheme.color,
                                        blurRadius: 25)
                                  ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Select Semester",
                                style: dropdowntitletheme,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Expanded(
                                child: Container(
                                  height: App(context)
                                      .appScreenHeightWithOutSafeArea(0.075),
                                  child: DropdownButton(
                                    dropdownColor:
                                        theme.scaffoldBackgroundColor,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontSize: 17),
                                    value: model.sem,
                                    items: model.dropdownofsem,
                                    onChanged:
                                        model.changedDropDownItemOfSemester,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height:
                            App(context).appScreenHeightWithOutSafeArea(0.13),
                        width:
                            App(context).appScreenWidthWithOutSafeArea(1) - 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: theme.colorScheme.background,
                          boxShadow: AppStateNotifier.isDarkModeOn
                              ? []
                              : [
                                  BoxShadow(
                                      offset: Offset(10, 10),
                                      color: theme.cardTheme.shadowColor,
                                      blurRadius: 25),
                                  BoxShadow(
                                      offset: Offset(-10, -10),
                                      color: theme.cardTheme.color,
                                      blurRadius: 25)
                                ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Select Branch",
                              style: dropdowntitletheme,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Flexible(
                              child: Container(
                                height: App(context)
                                    .appScreenHeightWithOutSafeArea(0.075),
                                child: DropdownButton(
                                  dropdownColor: theme.scaffoldBackgroundColor,
                                  focusColor: Colors.transparent,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 17),
                                  value: model.br,
                                  items: model.dropdownofbr,
                                  onChanged: model.changedDropDownItemOfBranch,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height:
                            App(context).appScreenHeightWithOutSafeArea(0.15),
                        width:
                            App(context).appScreenWidthWithOutSafeArea(1) - 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: theme.colorScheme.background,
                          boxShadow: AppStateNotifier.isDarkModeOn
                              ? []
                              : [
                                  BoxShadow(
                                      offset: Offset(10, 10),
                                      color: theme.cardTheme.shadowColor,
                                      blurRadius: 25),
                                  BoxShadow(
                                      offset: Offset(-10, -10),
                                      color: theme.cardTheme.color,
                                      blurRadius: 25)
                                ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Select College",
                              style: dropdowntitletheme,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Expanded(
                              child: DropdownButton(
                                dropdownColor: theme.scaffoldBackgroundColor,
                                focusColor: Colors.transparent,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 17),
                                isExpanded: true,
                                value: model.clg,
                                items: model.dropdownofclg,
                                onChanged: model.changedDropDownItemOfCollege,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Container(
                          height:
                              App(context).appScreenHeightWithOutSafeArea(0.08),
                          //width: screenWidthWithoutSafeArea - ,
                          child: GoogleSignInButton(
                              borderRadius: 10,
                              onPressed: () {
                                model.handleSignUp();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => IntroViewModel(),
    );
  }
}
