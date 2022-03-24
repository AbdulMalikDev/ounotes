import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/question_paper_tile/question_paper_tile_viewmodel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/misc/constants.dart';

class QuestionPaperTileView extends StatelessWidget {
  final QuestionPaper questionPaper;
  final Function openDoc;

  const QuestionPaperTileView(
      {Key key, @required this.openDoc, this.questionPaper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    var theme = Theme.of(context);
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    return ViewModelBuilder<QuestionPaperTileViewModel>.reactive(
        builder: (context, model, child) => model.isBusy
            ? circularProgress()
            : ModalProgressHUD(
                inAsyncCall: model.isloading,
                progressIndicator: Center(
                  child: ValueListenableBuilder(
                    valueListenable: model.downloadProgress,
                    builder: (context, progress, child) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.all(10),
                      height: App(context).appHeight(0.17),
                      width: App(context).appWidth(0.87),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          circularProgress(),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(maxWidth: 180),
                                child: progress < 100
                                    ? Text(
                                        'Downloading...' +
                                            progress.toStringAsFixed(0) +
                                            '%',
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(fontSize: 15),
                                      )
                                    : Text(
                                        'Downloading...' + '100%',
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(fontSize: 15),
                                      ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 180),
                                child: Text(
                                  'Large files may take some time...',
                                  overflow: TextOverflow.clip,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 180),
                                child: Text(
                                  'Access downloads from Drawer > My Downloads',
                                  overflow: TextOverflow.clip,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.99,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    decoration: AppStateNotifier.isDarkModeOn
                        ? Constants.mdecoration.copyWith(
                            color: Theme.of(context).colorScheme.background,
                            boxShadow: [],
                          )
                        : Constants.mdecoration.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                    child: model.isBusy
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.16,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      //  color: Colors.yellow,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/pdf.png',
                                        ),
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),

                                        Container(
                                          width: wp * 0.55,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                constraints:
                                                    model.isQPdownloaded
                                                        ? BoxConstraints(
                                                            maxWidth: 140)
                                                        : BoxConstraints(
                                                            maxWidth: 160),
                                                child: Text(
                                                  "Year :${questionPaper.year} ${questionPaper.branch}",
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //     PopupMenuButton(
                                        //       onSelected: (Menu selectedValue) {
                                        //         if (selectedValue == Menu.Report) {
                                        //
                                        //         }
                                        //       },
                                        //       icon: Icon(Icons.more_vert),
                                        //       itemBuilder: (_) => [
                                        //         PopupMenuItem(
                                        //           child: Text('Report'),
                                        //           value: Menu.Report,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          width: wp * 0.6,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              openDoc();
                                            },
                                            child: Text(
                                              "Open",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: theme.colorScheme.onBackground,
                              ),
                              if (!model.isAdmin)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          model.download(questionPaper);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download,
                                              color: Colors.orange,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Download",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    color: Colors.orange,
                                                  ),
                                            )
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final RenderBox box =
                                              context.findRenderObject();
                                          Share.share(
                                              "Question Paper year: ${questionPaper.year}\n\nSubject Name: ${questionPaper.subjectName}\n\nLink:${questionPaper.GDriveLink}\n\n" +
                                                  "Find Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                                              sharePositionOrigin:
                                                  box.localToGlobal(
                                                          Offset.zero) &
                                                      box.size);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.share,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Share",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                            )
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          model.reportNote(doc: questionPaper);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.report,
                                                color: Colors.red),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Report",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (model.isAdmin)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          model.download(questionPaper);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final RenderBox box =
                                              context.findRenderObject();
                                          Share.share(
                                              "Question Paper year: ${questionPaper.year}\n\nSubject Name: ${questionPaper.subjectName}\n\nLink:${questionPaper.GDriveLink}\n\n" +
                                                  "Find Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                                              sharePositionOrigin:
                                                  box.localToGlobal(
                                                          Offset.zero) &
                                                      box.size);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.share,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          model.reportNote(doc: questionPaper);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.report,
                                                color: Colors.red),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              await model.navigateToEditView(
                                                  questionPaper);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.blue),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await model.delete(questionPaper);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
        viewModelBuilder: () => QuestionPaperTileViewModel());
  }
}
