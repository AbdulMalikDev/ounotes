import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/subjects_dialog/subjects_dialog_viewmodel.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SubjectsDialogView extends StatefulWidget {
  const SubjectsDialogView({Key key}) : super(key: key);

  @override
  _SubjectsDialogViewState createState() => _SubjectsDialogViewState();
}

class _SubjectsDialogViewState extends State<SubjectsDialogView> {
  TextEditingController _textEditingController = TextEditingController();
  String searchKeyWord = "";
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubjectsDialogViewModel>.reactive(
        onModelReady: (model) {
          model.alter();
        },
        builder: (context, model, child) => Container(
              height: MediaQuery.of(context).size.height * 0.82,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
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
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: SizedBox(
                          height: 0.07 * MediaQuery.of(context).size.height,
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              fillColor:
                                  Theme.of(context).colorScheme.background,
                              filled: true,
                              hintText: "Search Subject",
                              hintStyle: TextStyle(fontFamily: "Montserrat"),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(05),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            style: Theme.of(context).textTheme.headline5,
                            onChanged: (value) {
                              setState(() {
                                searchKeyWord = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        height:
                            App(context).appScreenHeightWithOutSafeArea(0.6),
                        child: ValueListenableBuilder(
                            valueListenable: model.allSubjects,
                            builder: (context, allSubjects, child) {
                              // List<Subject> allSubjectsAltered =
                              //     model.alter(allSubjects);

                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: allSubjects.length,
                                itemBuilder: (context, index) {
                                  Subject subject = allSubjects[index];

                                  if (!(searchKeyWord.trim() == "" ||
                                      subject.name
                                          .toLowerCase()
                                          .contains(searchKeyWord)))
                                    return Container();
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
                                        title: RichText(
                                          text: TextSpan(
                                            text: subject.name.substring(
                                                0, searchKeyWord.length),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: subject.name.substring(
                                                    searchKeyWord.length),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                      // SizedBox(
                      //   height:
                      //       App(context).appScreenHeightWithOutSafeArea(0.001),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => SubjectsDialogViewModel());
  }
}
