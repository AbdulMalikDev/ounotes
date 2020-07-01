import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/vote.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

import 'notes_viewmodel.dart';

class NotesView extends StatefulWidget {
  final String subjectName;
  final String path;
  const NotesView({@required this.subjectName, this.path, Key key})
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
        onModelReady: (model) => model.fetchNotesAndVotes(widget.subjectName),
        builder: (context, model, child) => SingleChildScrollView(
              child: Container(
                height: widget.path != null
                    ? MediaQuery.of(context).size.height * 0.86
                    : MediaQuery.of(context).size.height * 0.78,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    model.isloading
                        ? linearProgress()
                        : SizedBox(height: 0, width: 0),
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: widget.path != null
                              ? model.isloading
                                  ? MediaQuery.of(context).size.height *
                                      0.84 //chota
                                  : MediaQuery.of(context).size.height *
                                      0.86 //bada
                              : model.isloading
                                  ? MediaQuery.of(context).size.height *
                                      0.68 //chota
                                  : MediaQuery.of(context).size.height *
                                      0.73, //bada
                          width: double.infinity,
                          child: model.isBusy
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : model.notes.length == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Notes are empty!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                      color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                    fontWeight:
                                                        FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: model.notes.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Note note = model.notes[index];
                                        return InkWell(
                                            child: NotesTileView(
                                              ctx: context,
                                              note: note,
                                              index: index,
                                              votes: model.getListOfVoteBySub(
                                                  widget.subjectName),
                                              downloadedNotes: model
                                                  .getListOfNotesInDownloads(
                                                      widget.subjectName),
                                              //votes: v.getListOfVoteBySub(
                                              //  notes[index].subjectName),
                                            ),
                                            onTap: () {
                                              model.onTap(
                                                notesName: note.title,
                                                subName: note.subjectName,
                                                note: note,
                                                //! This is used so that spelling is not messed up while uploading
                                                type: Constants.notes,
                                              );
                                            });
                                      }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => NotesViewModel());
  }

  @override
  bool get wantKeepAlive => true;
}
