import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/admin/AddEditSubject/addEditSubject_view.dart';
import 'package:FSOUNotes/ui/views/admin/subject_list/subject_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AdminSubjectListView extends StatefulWidget {
  @override
  _AdminSubjectListViewState createState() => _AdminSubjectListViewState();
}

class _AdminSubjectListViewState extends State<AdminSubjectListView> {
  TextEditingController _textEditingController = TextEditingController();
  String searchKeyWord = "";
  @override
  Widget build(BuildContext context) {
    // var theme=Theme.of
    return ViewModelBuilder<AdminSubjectListViewModel>.reactive(
      viewModelBuilder: () => AdminSubjectListViewModel(),
      builder: (
        BuildContext context,
        AdminSubjectListViewModel model,
        Widget child,
      ) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEditSubjectView()));
                },
                child: const Icon(Icons.add),
                backgroundColor: Theme.of(context).accentColor,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Text(
                        "Subject List",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: SizedBox(
                      height: 0.07 * MediaQuery.of(context).size.height,
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.background,
                          filled: true,
                          hintText: "Search Subject",
                          hintStyle: TextStyle(fontFamily: "Montserrat"),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 20),
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
                    height: App(context).appScreenHeightWithOutSafeArea(0.8),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: model.allSubjects.length,
                      itemBuilder: (context, index) {
                        Subject subject = model.allSubjects[index];
                        String subjectName = subject.name.toLowerCase();
                        List<String> firstLetters =
                            subjectName.split(" ").map((word) {
                          if (word.isNotEmpty) return word[0];
                        }).toList();
                        //handling edge case where subject name may have extra space
                        firstLetters.removeWhere((letter) => letter == null);
                        int lettersMatched = 0;
                        searchKeyWord.split("").forEach((letter) {
                          if (firstLetters.contains(letter)) lettersMatched++;
                        });
                        double matchingPercentage =
                            (lettersMatched / searchKeyWord.length) * 100;
                        bool subjectMatched = searchKeyWord.trim().isEmpty ||
                            matchingPercentage > 90 ||
                            subjectName.contains(searchKeyWord);
                        if (!subjectMatched) return Container();
                        return Container(
                          height: App(context)
                              .appScreenHeightWithOutSafeArea(0.086),
                          width: App(context).appScreenWidthWithOutSafeArea(1) -
                              40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 0.3, color: Colors.black26),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.black,
                                spreadRadius: -10,
                                blurRadius: 14,
                              )
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          alignment: Alignment.center,
                          child: ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditSubjectView(
                                          subject: subject,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    Helper.showDeleteConfirmDialog(
                                      context: context,
                                      onDeletePressed:
                                          model.deleteSubject(subject.id),
                                    );
                                  },
                                ),
                              ],
                            ),
                            title: SubstringHighlight(
                              text: subject.name
                                  .toUpperCase(), // each string needing highlighting
                              term: searchKeyWord
                                  .toUpperCase(), // user typed "m4a"
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                              textStyleHighlight: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
