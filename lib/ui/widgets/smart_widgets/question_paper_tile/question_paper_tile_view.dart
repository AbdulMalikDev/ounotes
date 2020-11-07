import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/question_paper_tile/question_paper_tile_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/models/download.dart';

class QuestionPaperTileView extends StatelessWidget {
  final QuestionPaper note;
  final int index;
  final BuildContext ctx;
  final List<Download> downloadedQp;

  const QuestionPaperTileView(
      {Key key, this.note, this.index, this.ctx, this.downloadedQp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    var theme = Theme.of(context);
    return ViewModelBuilder<QuestionPaperTileViewModel>.reactive(
        onModelReady: (model) =>
            model.checkIfQpIsDownloaded(downloadedQp, note),
        builder: (context, model, child) => FractionallySizedBox(
              widthFactor: 0.99,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
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
                child: model.isBusy
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ))
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
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 180,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                               constraints:
                                                  model.isQPdownloaded
                                                      ? BoxConstraints(
                                                          maxWidth: 150)
                                                      : BoxConstraints(
                                                          maxWidth: 180),
                                                child: Text(
                                                  "Year :${note.year} ${note.branch}",
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              model.isQPdownloaded
                                                  ? SizedBox(
                                                      width: 5,
                                                    )
                                                  : SizedBox(),
                                              model.isQPdownloaded
                                                  ? Icon(Icons.done_all,
                                                      color:
                                                          theme.iconTheme.color,
                                                      size: 18)
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton(
                                          onSelected: (Menu selectedValue) {
                                            if (selectedValue == Menu.Report) {
                                              model.reportNote(doc: note);
                                          
                                            }
                                          },
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (_) => [
                                            PopupMenuItem(
                                              child: Text('Report'),
                                              value: Menu.Report,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Question Paper",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 13,
                                              letterSpacing: .3),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          model.isAdmin
                              ? Container(
                                  child: RaisedButton(
                                  child: Text("DELETE",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: () async {
                                    await model.delete(note);
                                  },
                                ))
                              : Container(),
                        ],
                      ),
              ),
            ),
        viewModelBuilder: () => QuestionPaperTileViewModel());
  }
}
