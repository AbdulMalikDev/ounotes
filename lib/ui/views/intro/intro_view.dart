import 'dart:io';
import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/course_info.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/Intro/intro_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key key}) : super(key: key);

  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView>
    with SingleTickerProviderStateMixin {
      
  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  Icon _getDropdownIcon() {
    return Icon(
      Icons.unfold_more,
      color: Colors.blueAccent,
    );
  }

  BoxDecoration _getShadowDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black.withOpacity(0.06),
          spreadRadius: 4,
          offset: new Offset(0.0, 0.0),
          blurRadius: 15.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titletheme = theme.textTheme.headline6
        .copyWith(fontSize: 20, fontWeight: FontWeight.w400);
    var dropdowntitletheme = theme.textTheme.headline6
        .copyWith(fontSize: 18, fontWeight: FontWeight.w400);
    return ViewModelBuilder<IntroViewModel>.reactive(
      onModelReady: (model) {
        model.initialise();
      },
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
                title: Text("Welcome To OU Notes",
                    style: theme.appBarTheme.textTheme.headline6),
                centerTitle: true,
              ),
              body: DirectSelectContainer(
                child: Container(
                  //  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height:
                              App(context).appScreenHeightWithOutSafeArea(0.24),
                          width:
                              App(context).appScreenWidthWithOutSafeArea(0.4),
                          child: Lottie.asset(
                            'assets/lottie/book.json',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Container(
                            decoration: _getShadowDecoration(),
                            child: Card(
                                child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    child: DirectSelectList<String>(
                                      values: CourseInfo.semesters,
                                      defaultItemIndex: 0,
                                      itemBuilder: (String value) =>
                                          getDropDownMenuItem(value),
                                      focusedItemDecoration:
                                          _getDslDecoration(),
                                    ),
                                    padding: EdgeInsets.only(left: 12),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: _getDropdownIcon(),
                                )
                              ],
                            )),
                          ),
                        ),
                        // Center(
                        //   child: Container(
                        //     height:
                        //         App(context).appScreenHeightWithOutSafeArea(0.13),
                        //     width:
                        //         App(context).appScreenHeightWithOutSafeArea(1) -
                        //             40,
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        //     margin:
                        //         EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(16),
                        //       color: theme.colorScheme.background,
                        //     ),
                        //     child: Column(
                        //       children: <Widget>[
                        //         Text(
                        //           "Select Semester",
                        //           style: dropdowntitletheme,
                        //         ),
                        //         SizedBox(
                        //           height: 3,
                        //         ),
                        //         Expanded(
                        //           child: Container(
                        //             height: App(context)
                        //                 .appScreenHeightWithOutSafeArea(0.075),
                        //             child: DropdownButton(
                        //               dropdownColor:
                        //                   theme.scaffoldBackgroundColor,
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .subtitle1
                        //                   .copyWith(fontSize: 17),
                        //               value: model.sem,
                        //               items: model.dropdownofsem,
                        //               onChanged:
                        //                   model.changedDropDownItemOfSemester,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height:
                              App(context).appScreenHeightWithOutSafeArea(0.13),
                          width: App(context).appScreenWidthWithOutSafeArea(1) -
                              40,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: theme.colorScheme.background,
                            // boxShadow: AppStateNotifier.isDarkModeOn
                            //     ? []
                            //     : [
                            //         BoxShadow(
                            //             offset: Offset(10, 10),
                            //             color: theme.cardTheme.shadowColor,
                            //             blurRadius: 25),
                            //         BoxShadow(
                            //             offset: Offset(-10, -10),
                            //             color: theme.cardTheme.color,
                            //             blurRadius: 25)
                            //       ],
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
                                    dropdownColor:
                                        theme.scaffoldBackgroundColor,
                                    focusColor: Colors.transparent,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontSize: 17),
                                    value: model.br,
                                    items: model.dropdownofbr,
                                    onChanged:
                                        model.changedDropDownItemOfBranch,
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
                          width: App(context).appScreenWidthWithOutSafeArea(1) -
                              40,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: theme.colorScheme.background,
                            // boxShadow: AppStateNotifier.isDarkModeOn
                            //     ? []
                            //     : [
                            //         BoxShadow(
                            //             offset: Offset(10, 10),
                            //             color: theme.cardTheme.shadowColor,
                            //             blurRadius: 25),
                            //         BoxShadow(
                            //             offset: Offset(-10, -10),
                            //             color: theme.cardTheme.color,
                            //             blurRadius: 25)
                            //       ],
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
                            height: App(context)
                                .appScreenHeightWithOutSafeArea(0.08),
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
          ),
        );
      },
      viewModelBuilder: () => IntroViewModel(),
    );
  }
}
