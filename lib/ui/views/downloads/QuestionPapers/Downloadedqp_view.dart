import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/ui/views/downloads/QuestionPapers/Downloadedqp_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DownloadedQuestionPaperView extends StatelessWidget {
  const DownloadedQuestionPaperView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    var theme = Theme.of(context);
    return ViewModelBuilder<DownloadedQPViewModel>.reactive(
      onModelReady: (model) =>
          model.fetchAndSetListOfQuestionPapersInDownloads(),
      builder: (context, model, child) => Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: model.isBusy
            ? circularProgress()
            : ListView.builder(
                itemCount: model.questionPapers.length,
                itemBuilder: (context, index) {
                  final item = model.questionPapers[index].subjectName+model.questionPapers[index].year;
                  return InkWell(
                    onTap: () {
                      model.onTap(
                          PDFpath: model.questionPapers[index].path,
                          notesName: "Document");
                    },
                    child: FractionallySizedBox(
                      widthFactor: 0.99,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            model.removeQpFromDownloads(
                                model.questionPapers[index].path);
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
                                margin: EdgeInsets.only(right: 20),
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 200),
                                        child: Text(
                                          model.questionPapers[index].subjectName,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                          "Year :${model.questionPapers[index].year}",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 13,
                                              letterSpacing: .3)),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      viewModelBuilder: () => DownloadedQPViewModel(),
    );
  }
}

void showSnackBar(
  BuildContext context,
  String item,
) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Text("Removed $item",style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),),
          SizedBox(
            width: 40,
          ),
        ],
      ),
      duration: Duration(seconds: 1),
    ),
  );
}
