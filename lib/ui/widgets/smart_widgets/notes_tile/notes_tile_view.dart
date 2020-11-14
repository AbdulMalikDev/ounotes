import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class NotesTileView extends StatelessWidget {
  final Note note;
  final List<Vote> votes;
  final int index;
  final BuildContext ctx;
  final List<Download> downloadedNotes;

  const NotesTileView(
      {Key key,
      this.note,
      this.votes,
      this.index,
      this.ctx,
      this.downloadedNotes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final String title =
        note.title != null ? note.title.toUpperCase() : "title";
    final String author =
        note.author != null ? note.author.toUpperCase() : "author";
    final date = note.uploadDate;
    var format = new DateFormat("dd/MM/yy");
    var dateString = format.format(date);
    final int view = note.view;
    final String size = note.size.toString();
    var theme = Theme.of(context);

    return ViewModelBuilder<NotesTileViewModel>.reactive(
        createNewModelOnInsert: true,
        onModelReady: (model) => model.checkIfUserVotedAndDownloadedNote(
            votes, downloadedNotes, note),
        builder: (context, model, child) {
          return FractionallySizedBox(
            widthFactor: 0.99,
            child: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 25),
                                  height: App(context)
                                      .appScreenHeightWithOutSafeArea(0.11),
                                  width: App(context)
                                      .appScreenWidthWithOutSafeArea(0.2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/pdf.png',
                                      ),
                                      // colorFilter: ColorFilter.mode(
                                      //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 180,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              constraints:
                                                  model.isnotedownloaded
                                                      ? BoxConstraints(
                                                          maxWidth: 150)
                                                      : BoxConstraints(
                                                          maxWidth: 180),
                                              child: Text(
                                                title,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            model.isnotedownloaded
                                                ? SizedBox(
                                                    width: 10,
                                                  )
                                                : SizedBox(),
                                            model.isnotedownloaded
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
                                            model.reportNote(
                                              doc: note,
                                              id: note.id,
                                              subjectName: note.subjectName,
                                              title: note.title,
                                              type: Constants.notes,
                                            );
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
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Author :$author",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 13,
                                              letterSpacing: .3)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Upload Date :$dateString",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 13,
                                              letterSpacing: .3)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: secondary,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        view.toString(),
                                        style: TextStyle(
                                            color: primary,
                                            fontSize: 13,
                                            letterSpacing: .3),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        size,
                                        style: TextStyle(
                                            color: primary,
                                            fontSize: 13,
                                            letterSpacing: .3),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          model.handleVotes(model.vote,
                                              Constants.upvote, note);
                                        },
                                        child: Container(
                                          width: 30,
                                          child: IconButton(
                                              padding: EdgeInsets.all(0.0),
                                              icon: FaIcon(FontAwesomeIcons
                                                  .longArrowAltUp),
                                              color:
                                                  model.vote == Constants.upvote
                                                      ? Colors.green
                                                      : Colors.white,
                                              iconSize: 30,
                                              onPressed: () {
                                                model.handleVotes(model.vote,
                                                    Constants.upvote, note);
                                              }),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          model.handleVotes(model.vote,
                                              Constants.downvote, note);
                                        },
                                        child: Container(
                                          width: 30,
                                          child: IconButton(
                                              icon: FaIcon(FontAwesomeIcons
                                                  .longArrowAltDown),
                                              color: model.vote ==
                                                      Constants.downvote
                                                  ? Colors.red
                                                  : Colors.white,
                                              iconSize: 30,
                                              onPressed: () {
                                                model.handleVotes(model.vote,
                                                    Constants.downvote, note);
                                              }),
                                        ),
                                      ),
                                      model.isBusy
                                          ? circularProgress()
                                          : Container(
                                              height: 20,
                                              width: 20,
                                              child: StreamBuilder(
                                                  stream: model
                                                      .getSnapShotOfVotes(note),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return CircularProgressIndicator();
                                                    }
                                                    return FittedBox(
                                                      child:
                                                          snapshot.data.data ==
                                                                  null
                                                              ? Text("")
                                                              : Text(
                                                                  snapshot
                                                                          .data
                                                                          .data[
                                                                              "votes"]
                                                                          ?.toString() ??
                                                                      "",
                                                                  style: theme
                                                                      .textTheme
                                                                      .subtitle1
                                                                      .copyWith(
                                                                          fontSize:
                                                                              18),
                                                                ),
                                                    );
                                                  }),
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        model.isAdmin
                            ? Container(
                                child: RaisedButton(
                                  child: Text("DELETE",
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.red,
                                  onPressed: () async {
                                    await model.deleteFromGdrive(note);
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
          );
        },
        viewModelBuilder: () => NotesTileViewModel());
  }
}
