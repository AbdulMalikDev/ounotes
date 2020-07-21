import 'dart:io';

import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/home/home_viewmodel.dart';
import 'package:FSOUNotes/ui/views/search/search_view.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/no_subjects_overlay.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/drawer/drawer_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.showIntroDialog(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            content: Text('Are you sure you want to quit OU Notes',
                style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
            actions: [
              FlatButton(
                child: Text('No',
                    style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
                onPressed: () => Navigator.pop(c, false),
              ),
              FlatButton(
                child: Text('Yes',
                    style: theme.textTheme.subtitle1.copyWith(fontSize: 17)),
                onPressed: () => exit(0),
              ),
            ],
          ),
        ),
        child: Scaffold(
          drawer: DrawerView(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text(
              'My Subjects',
              style: theme.appBarTheme.textTheme.headline6,
            ),
            backgroundColor: theme.appBarTheme.color,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchView(path: Path.Appbar));
                },
              ),
            ],
          ),

          body: ValueListenableBuilder(
              valueListenable: model.userSubjects,
              builder: (context, userSubjects, child) {
                return Column(
                  children: [
                    model.userSubjects.value.length == 0
                        ? NoSubjectsOverlay()
                        : UserSubjectListView(),
                  ],
                );
              }),

          //drawer: GetDrawer(),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Add Subjects');
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) => SubjectsDialogView());
              },
              child: const Icon(Icons.add),
              backgroundColor: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
