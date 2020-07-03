import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/shared/ui_helper.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserSubjectListView extends StatelessWidget {
  const UserSubjectListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<UserSubjectListViewModel>.reactive(
      builder: (context, model, child) => ValueListenableBuilder(
          valueListenable: model.userSubjects,
          builder: (context, userSubjects, child) {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              height: App(context).appScreenHeightWithOutSafeArea(0.84),
              width: App(context).appScreenWidthWithOutSafeArea(1),
              child: ReorderableListView(
                scrollDirection: Axis.vertical,
                onReorder: (int oldIndex, int newIndex) {
                  model.updateMyItems(oldIndex, newIndex);
                },
                children: List.generate(
                  userSubjects.length,
                  (index) {
                    Subject subject = userSubjects[index];
                    return Container(
                      key: ValueKey('value$index'),
                      height: App(context).appScreenHeightWithOutSafeArea(0.13),
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      alignment: Alignment.bottomCenter,
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
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          model.removeSubject(subject);

                          showSnackBar(
                            context,
                            subject.name,
                          );
                        },
                        background: Container(
                          //margin: EdgeInsets.symmetric(horizontal:10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerStart,
                          child: Icon(
                            Icons.block,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          //margin: EdgeInsets.symmetric(horizontal:10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(
                            Icons.block,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 0,
                            top: 10,
                          ),
                          //color: Colors.yellow,
                          height: 80,
                          child: ListTile(
                            title: Container(
                              //color: Colors.blue,
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(subject.name,
                                  overflow: TextOverflow.clip,
                                  style: theme.textTheme.subtitle1
                                      .copyWith(fontSize: 17)),
                            ),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 8,
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  child: Icon(
                                    Icons.more_vert,
                                    color: theme.colorScheme.onBackground,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  margin: EdgeInsets.all(0),
                                  child: Icon(
                                    Icons.more_vert,
                                    color:theme.colorScheme.onBackground,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    subject.name.substring(0, 1).toUpperCase(),
                                    style: theme.appBarTheme.textTheme.headline6
                                        .copyWith(
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              model.onTap(subject.name);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
      viewModelBuilder: () => UserSubjectListViewModel(),
    );
  }

  void showSnackBar(
    BuildContext context,
    String item,
  ) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Container(
          constraints: BoxConstraints(maxWidth: 300),
          child: Text(
            "REMOVED $item",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontSize: 15, color: Colors.black),
          ),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
