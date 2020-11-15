import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/ui/views/downloads/Syllabus/Downloadedsyllabus_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DownloadedSyllabusView extends StatelessWidget {
  const DownloadedSyllabusView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    var theme = Theme.of(context);

    return ViewModelBuilder<DownloadedSyllabusViewModel>.reactive(
      onModelReady: (model) => model.fetchAndSetListOfSyllabusInDownloads(),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: model.syllabus.length,
            itemBuilder: (context, index) {
              final item = model.syllabus[index].subjectName;
              return InkWell(
                onTap: () {
                  model.onTap(
                      PDFpath: model.syllabus[index].path,
                      notesName: "Document");
                },
                child: FractionallySizedBox(
                  widthFactor: 0.99,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        model.removeSyllabusFromDownloads(
                            model.syllabus[index].path);
                        // Then show a snackbar.
                        showSnackBar(context, item);
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: MediaQuery.of(context).size.width * 0.2,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              //  color: Colors.yellow,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/pdf.png',
                                ),
                                // colorFilter: ColorFilter.mode(
                                //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: FittedBox(
                                    child: Text(
                                      item,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text("Semeter :${model.syllabus[index].sem}",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 13,
                                        letterSpacing: .3)),
                                SizedBox(
                                  height: 6,
                                ),
                                Text("Branch :${model.syllabus[index].branch}",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 13,
                                        letterSpacing: .3)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      viewModelBuilder: () => DownloadedSyllabusViewModel(),
    );
  }
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
