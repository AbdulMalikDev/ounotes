import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserSubjectListView extends StatelessWidget {
  final bool isEditPressed;
  const UserSubjectListView({Key key, this.isEditPressed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<UserSubjectListViewModel>.reactive(
      builder: (context, model, child) => ValueListenableBuilder(
          valueListenable: model.userSubjects,
          builder: (context, userSubjects, child) {
            if (isEditPressed) {
              return ValueListenableBuilder(
                valueListenable: model.userSelectedSubjects,
                builder: (context, userSelectedSubjects, child) =>
                    ListView.builder(
                  itemCount: userSubjects.length,
                  itemBuilder: (context, idx) {
                    Subject subject = userSubjects[idx];
                    bool isSubjectSelected = false;
                    if (userSelectedSubjects.firstWhere(
                            (element) =>
                                element.name.toLowerCase() ==
                                subject.name.toLowerCase(),
                            orElse: () => null) !=
                        null) {
                      print("subject is selected");
                      isSubjectSelected = true;
                    }
                    return GestureDetector(
                      onTap: () {
                        model.updateUserSelectedSubjects(subject);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: isSubjectSelected
                                  ? Colors.green
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                // width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              key: ValueKey('value$idx'),
                              height: App(context).appHeight(0.09),
                              width: App(context).appWidth(0.7),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: theme.colorScheme.background,
                              ),
                              child: Center(
                                child: ListTile(
                                  title: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            subject.name,
                                            overflow: TextOverflow.clip,
                                            style: theme.textTheme.subtitle1
                                                .copyWith(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text(
                                          subject.name
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: theme
                                              .appBarTheme.textTheme.headline6
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    model.updateUserSelectedSubjects(subject);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return ReorderableListView(
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
                    height: App(context).appHeight(0.09),
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.background,
                    ),
                    child: Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        model.removeSubject(subject);
                      },
                      background: Container(
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
                      child: Center(
                        child: ListTile(
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Text(
                                    subject.name,
                                    overflow: TextOverflow.clip,
                                    style: theme.textTheme.subtitle1
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: theme.colorScheme.onBackground,
                                  size: 20,
                                ),
                              ],
                            ),
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
                                  color: theme.colorScheme.onBackground,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Container(
          constraints: BoxConstraints(maxWidth: 300),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Text(
            "REMOVED $item",
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontSize: 15,
                ),
          ),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
