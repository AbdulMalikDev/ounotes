import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/syllabus_tile.dart/syllabus_tile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/models/download.dart';

class SyllabusTileView extends StatelessWidget {
  final Syllabus syllabus;
  final int index;
  final List<Download> downloadedsyllabus;
  const SyllabusTileView(
      {Key key, this.syllabus, this.index, this.downloadedsyllabus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = Theme.of(context).colorScheme.onPrimary;
    final String title = syllabus.subjectName;
    final String semester = syllabus.semester;
    final String branch = syllabus.branch?.toUpperCase() ?? "";
    return ViewModelBuilder<SyllabusTileViewModel>.reactive(
        onModelReady: (model) =>
            model.checkIfSyllabusIsDownloaded(downloadedsyllabus, syllabus),
        builder: (context, model, child) => FractionallySizedBox(
              widthFactor: 0.99,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.16,
                // width: double.infinity,
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
                        Container(
                          margin: EdgeInsets.only(right: 20),
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
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 160,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            constraints: model
                                                    .isSyllabusdownloaded
                                                ? BoxConstraints(maxWidth: 140)
                                                : BoxConstraints(maxWidth: 160),
                                            child: Text(
                                              title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        MdiIcons.shareOutline,
                                        color: theme.primaryColor,
                                      ),
                                      onPressed: () {
                                        final RenderBox box =
                                            context.findRenderObject();
                                        Share.share(
                                            "Syllabus Branch: ${syllabus.branch}\n\nSubject Name: ${syllabus.subjectName}\n\nLink:${syllabus.GDriveLink}\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                                            sharePositionOrigin:
                                                box.localToGlobal(Offset.zero) &
                                                    box.size);
                                      },
                                    ),
                                    PopupMenuButton(
                                      onSelected: (Menu selectedValue) {
                                        if (selectedValue == Menu.Report) {
                                          model.reportNote(doc: syllabus);
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Semeter : $semester",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 13,
                                              letterSpacing: .3),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Branch : $branch",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 13,
                                              letterSpacing: .3),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13),
                                  ],
                                ),
                              ]),
                        )
                      ],
                    ),
                    model.isAdmin
                            ? 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: RaisedButton(
                                    child: Text("EDIT",
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.blue,
                                    onPressed: () async {
                                      await model.navigateToEditView(syllabus);
                                    },
                                  ),
                                ),
                                Container(
                                  child: RaisedButton(
                                    child: Text("DELETE",
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.red,
                                    onPressed: () async {
                                      await model.delete(syllabus);
                                    },
                                  ),
                                ),
                              ])
                            : Container(),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => SyllabusTileViewModel());
  }
}
