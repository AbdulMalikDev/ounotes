import 'dart:math' as math;

import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_viewmodel.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class NotesTileView extends StatelessWidget {
  final Note note;
  final bool notification;
  final bool isPinned;
  final Function refresh;
  final Function onTap;
  final Function({Note note}) onDownloadCallback;

  const NotesTileView({
    Key key,
    this.note,
    this.notification = false,
    this.isPinned = false,
    this.refresh,
    this.onDownloadCallback,
    @required this.onTap,
  }) : super(key: key);

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
        builder: (context, model, child) {
          return Container(
            child: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: AppStateNotifier.isDarkModeOn
                        ? Constants.mdecoration.copyWith(
                            color: Theme.of(context).colorScheme.background,
                            boxShadow: [],
                          )
                        : Constants.mdecoration.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                    child: notification
                        ? Shimmer.fromColors(
                            baseColor: Colors.teal,
                            highlightColor: Colors.white,
                            child: NotesColumnWidget(
                              refresh: refresh,
                              title: title,
                              primary: primary,
                              theme: theme,
                              note: note,
                              secondary: secondary,
                              author: author,
                              dateString: dateString,
                              view: view,
                              size: size,
                              model: model,
                              isPinned: isPinned,
                              onDownloadCallback: onDownloadCallback,
                              openDoc: onTap,
                            ),
                          )
                        : NotesColumnWidget(
                            refresh: refresh,
                            title: title,
                            primary: primary,
                            theme: theme,
                            note: note,
                            secondary: secondary,
                            author: author,
                            dateString: dateString,
                            view: view,
                            size: size,
                            model: model,
                            isPinned: isPinned,
                            onDownloadCallback: onDownloadCallback,
                            openDoc: onTap,
                          ),
                  ),
          );
        },
        viewModelBuilder: () => NotesTileViewModel());
  }
}

class NotesColumnWidget extends StatelessWidget {
  const NotesColumnWidget({
    Key key,
    @required this.title,
    @required this.primary,
    @required this.theme,
    @required this.note,
    @required this.secondary,
    @required this.author,
    @required this.dateString,
    @required this.view,
    @required this.size,
    @required this.model,
    @required this.isPinned,
    @required this.refresh,
    @required this.openDoc,
    this.onDownloadCallback,
  }) : super(key: key);

  final String title;
  final Color primary;
  final ThemeData theme;
  final Note note;
  final Color secondary;
  final String author;
  final String dateString;
  final int view;
  final String size;
  final NotesTileViewModel model;
  final bool isPinned;
  final Function refresh;
  final Function openDoc;
  final Function({Note note}) onDownloadCallback;

  @override
  Widget build(BuildContext context) {
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);

    log.e(note.toJson());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: [
                    // Icon(
                    //   Icons.file_present,
                    //   color: secondary,
                    //   size: 20,
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    Text(
                      size,
                      style: TextStyle(
                        color: primary,
                        fontSize: 10,
                        letterSpacing: .3,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: App(context).appScreenHeightWithOutSafeArea(0.1),
                  width: App(context).appScreenWidthWithOutSafeArea(0.2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/pdf.png',
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            color: primary, fontSize: 13, letterSpacing: .3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: wp * 0.58,
                        child: Row(
                          children: <Widget>[
                            Container(
                              constraints: model.isnotedownloaded
                                  ? BoxConstraints(maxWidth: 150)
                                  : BoxConstraints(maxWidth: 180),
                              child: Text(
                                title,
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            isPinned
                                ? Transform.rotate(
                                    angle: math.pi / 4,
                                    child: Icon(
                                      MdiIcons.pin,
                                      color: theme.iconTheme.color,
                                      size: 18,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Flexible(
                        child: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          onSelected: (Menu selectedValue) {
                            if (selectedValue == Menu.Pin) {
                              if (isPinned) {
                                model.unpinNotes(note, refresh);
                              } else {
                                model.pinNotes(note, refresh);
                              }
                            }
                          },
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: isPinned
                                  ? Text('Un-Pin Notes')
                                  : Text('Pin Notes'),
                              value: Menu.Pin,
                            ),
                          ],
                        ),
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
                              color: primary, fontSize: 13, letterSpacing: .3)),
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
                              color: primary, fontSize: 13, letterSpacing: .3)),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: wp * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: theme.colorScheme.onBackground,
        ),
        if (!model.isAdmin)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    onDownloadCallback(note: note);
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
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.orange,
                            ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(
                        "Notes Name: ${note.title}\n\nSubject Name: ${note.subjectName}\n\nLink:${note.GDriveLink}\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Theme.of(context).primaryColor),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Share",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    model.reportNote(
                      doc: note,
                      id: note.id,
                      subjectName: note.subjectName,
                      title: note.title,
                      type: Constants.notes,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.report, color: Colors.red),
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
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    onDownloadCallback(note: note);
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
                    model.thankUser(note);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.celebration_outlined,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(
                        "Notes Name: ${note.title}\n\nSubject Name: ${note.subjectName}\n\nLink:${note.GDriveLink}\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Theme.of(context).primaryColor),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    model.reportNote(
                      doc: note,
                      id: note.id,
                      subjectName: note.subjectName,
                      title: note.title,
                      type: Constants.notes,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.report, color: Colors.red),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await model.navigateToEditView(note);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await model.deleteFromGdrive(note);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
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
    );
  }
}
