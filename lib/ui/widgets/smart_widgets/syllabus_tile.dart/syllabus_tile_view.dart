import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/syllabus_tile.dart/syllabus_tile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

class SyllabusTileView extends StatefulWidget {
  final Syllabus syllabus;
  final Function openDoc;
  const SyllabusTileView({Key key,@required this.openDoc, this.syllabus})
      : super(key: key);

  @override
  _SyllabusTileViewState createState() => _SyllabusTileViewState();
}

class _SyllabusTileViewState extends State<SyllabusTileView> {
  Syllabus syllabus;

  @override
  void initState() {
    syllabus = widget.syllabus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = Theme.of(context).colorScheme.onPrimary;
    final String title = widget.syllabus.subjectName;
    final String semester = widget.syllabus.semester;
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    final String branch = widget.syllabus.branch?.toUpperCase() ?? "";
    return ViewModelBuilder<SyllabusTileViewModel>.reactive(
        builder: (context, model, child) => model.isBusy
            ? circularProgress()
            : ModalProgressHUD(
                inAsyncCall: model.isBusy,
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
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: AppStateNotifier.isDarkModeOn
                        ? Constants.mdecoration.copyWith(
                            color: Theme.of(context).colorScheme.background,
                            boxShadow: [],
                          )
                        : Constants.mdecoration.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
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
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                              fontSize: 15,
                                              letterSpacing: .3),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Branch : $branch",
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 15,
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
                                SizedBox(
                                  height: 10,
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
                                      widget.openDoc();
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
                                  onPressed: () {},
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
                                        "Syllabus Branch: ${syllabus.branch}\n\nSubject Name: ${syllabus.subjectName}\n\nLink:${syllabus.GDriveLink}\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                                        sharePositionOrigin:
                                            box.localToGlobal(Offset.zero) &
                                                box.size);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.share,
                                          color:
                                              Theme.of(context).primaryColor),
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
                                    model.reportNote(
                                      doc: syllabus,
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
                                  onPressed: () {},
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
                                        "Syllabus Branch: ${syllabus.branch}\n\nSubject Name: ${syllabus.subjectName}\n\nLink:${syllabus.GDriveLink}\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                                        sharePositionOrigin:
                                            box.localToGlobal(Offset.zero) &
                                                box.size);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.share,
                                          color:
                                              Theme.of(context).primaryColor),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    model.reportNote(doc: syllabus);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await model.navigateToEditView(
                                            widget.syllabus);
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
                                        await model.delete(widget.syllabus);
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
                    ),
                  ),
                ),
              ),
        viewModelBuilder: () => SyllabusTileViewModel());
  }
}
