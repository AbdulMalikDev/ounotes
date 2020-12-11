import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_view.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
      onModelReady: (model) => _initState(model, context),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.admobService.hideNotesViewBanner();
          model.navigateBack();
          return Future.value(false);
        },
        child: ModalProgressHUD(
          inAsyncCall: model.isloading ? true : false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: widget.path != null
                          ? MediaQuery.of(context).size.height * 0.88
                          : MediaQuery.of(context).size.height * 0.75,
                      width: double.infinity,
                      child: model.isBusy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : model.notes.length == 0
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/study1.jpg',
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
                                  ),
                                )
                              : ValueListenableBuilder(
                                  valueListenable: model.userVotesBySub,
                                  builder: (BuildContext context, dynamic value,
                                      Widget child) {
                                    return ListView(
                                      padding: EdgeInsets.only(bottom: 150),
                                      children: model.notesTiles,
                                    );
                                  },
                                ),
                    )
                  ],
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

  _initState(NotesViewModel model, BuildContext context) async {
    model.fetchNotesAndVotes(widget.subjectName, context);
    try {
      FirebaseAdMob.instance.initialize(appId: model.admobService.ADMOB_APP_ID);
      model.admobService.showNotesViewBanner();
      if (model.admobService.shouldAdBeShown()) {
        model.admobService.showNotesViewInterstitialAd();
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}

// Legacy code

// progressIndicator: Center(
//   child: Container(
//     padding: EdgeInsets.all(10),
//     height: 100,
//     width: 300,
//     color: Theme.of(context).scaffoldBackgroundColor,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         circularProgress(),
//         SizedBox(
//           width: 20,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               constraints: BoxConstraints(maxWidth: 180),
//               child: Text(
//                   'Downloading...' +
//                       model.progress.toStringAsFixed(0) +
//                       '%',
//                   overflow: TextOverflow.clip,
//                   style: Theme.of(context)
//                       .textTheme
//                       .subtitle1
//                       .copyWith(fontSize: 18)),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               constraints: BoxConstraints(maxWidth: 180),
//               child: Text(
//                 'Large files may take some time...',
//                 overflow: TextOverflow.clip,
//                 style: Theme.of(context)
//                     .textTheme
//                     .subtitle1
//                     .copyWith(fontSize: 14),
//               ),
//             )
//           ],
//         ),
//       ],
//     ),
//   ),
// ),
