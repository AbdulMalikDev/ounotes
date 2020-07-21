import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/search/search_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SubjectsDialogView extends StatelessWidget {
  const SubjectsDialogView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubjectsDialogViewModel>.reactive(
        builder: (context, model, child) => Container(
          color: Colors.transparent,
              child: Padding(
                padding:EdgeInsets.only(top:180),
                child:Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        )),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Add Subjects",
                                style: Theme.of(context)
                                    .appBarTheme
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onPressed: () async {
                                  await showSearch(
                                      context: context,
                                      delegate: SearchView(path: Path.Dialog));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 30),
                          Container(
                            height:
                                App(context).appScreenHeightWithOutSafeArea(0.52),
                            child: ValueListenableBuilder(
                                valueListenable: model.allSubjects,
                                builder: (context, allSubjects, child) {
                                  List<Subject> allSubjectsAltered =
                                      model.alter(allSubjects);
                                  return ListView.builder(
                                    itemCount: allSubjectsAltered.length,
                                    itemBuilder: (context, index) {
                                      Subject subject = allSubjectsAltered[index];
                                      return GestureDetector(
                                        onTap: () {
                                          model.onSubjectSelected(subject);
                                        },
                                        child: Container(
                                          height: App(context)
                                              .appScreenHeightWithOutSafeArea(
                                                  0.086),
                                          width: App(context)
                                                  .appScreenWidthWithOutSafeArea(
                                                      1) -
                                              40,
                                          //padding:EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          //margin:EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                                          alignment: Alignment.center,

                                          child: ListTile(
                                            leading: IconButton(
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: subject.userSubject
                                                    ? Colors.green
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                model.onSubjectSelected(subject);
                                              },
                                            ),
                                            title: Text(
                                              subject.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                          SizedBox(
                            height: App(context)
                                .appScreenHeightWithOutSafeArea(0.001),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            height:
                                App(context).appScreenHeightWithOutSafeArea(0.07),
                            child: FlatButton(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          
        viewModelBuilder: () => SubjectsDialogViewModel());
  }
}
