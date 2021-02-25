import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/similar_subjects_tile.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

import 'notes_viewmodel.dart';

class NotesView extends StatefulWidget {
  final String subjectName;
  final String path;
  final String newDocIDUploaded;
  const NotesView(
      {@required this.subjectName, this.path, this.newDocIDUploaded, Key key})
      : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<NotesViewModel>.reactive(
      onModelReady: (model) {
        model.initialize();
        _initState(model);
        model.newDocIDUploaded = widget.newDocIDUploaded;
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.navigateBack();
          return Future.value(false);
        },
        child: ModalProgressHUD(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: model.isBusy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : model.notes.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SimilarSubjectTile(
                                  similarSubjects: model
                                      .getSimilarSubjects(widget.subjectName),
                                ),
                                Image.asset(
                                  'assets/images/student_reading.jpg',
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 300,
                                ),
                                Text(
                                  "Notes are empty!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "why don't you upload some?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          : ValueListenableBuilder(
                              valueListenable: model.notesTiles,
                              builder: (BuildContext context,
                                  List<Widget> value, Widget child) {
                                return Column(
                                  children: value +
                                      [
                                        SimilarSubjectTile(
                                          similarSubjects:
                                              model.getSimilarSubjects(
                                                  widget.subjectName),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => NotesViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _initState(NotesViewModel model) async {
    model.fetchNotesAndVotes(widget.subjectName);
    try {
      model.admobService.shouldAdBeShown();
    } catch (e) {
      print(e.toString());
    }
  }
}
