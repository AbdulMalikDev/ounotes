import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'recently_opened_notes_tile.dart';
import 'recently_added_notes_viewmodel.dart';

class RecentlyAddedNotesView extends StatefulWidget {
  const RecentlyAddedNotesView({Key key}) : super(key: key);
  @override
  _RecentlyAddedNotesViewState createState() => _RecentlyAddedNotesViewState();
}

class _RecentlyAddedNotesViewState extends State<RecentlyAddedNotesView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecentlyAddedNotesViewModel>.nonReactive(
      viewModelBuilder: () => RecentlyAddedNotesViewModel(),
      builder: (
        BuildContext context,
        RecentlyAddedNotesViewModel model,
        Widget child,
      ) {
        return Scaffold(
          appBar: BackIconAppBar(),
          body: ValueListenableBuilder(
            valueListenable:
                Hive.box<RecentlyOpenedNotes>(Constants.recentlyOpenedNotes)
                    .listenable(),
            builder: (context, Box<RecentlyOpenedNotes> recentlyOpenedNotesBox,
                widget) {
              if (recentlyOpenedNotesBox.isEmpty) {
                return Container();
              }
              return Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      for (int i = recentlyOpenedNotesBox.length - 1;
                          i >= 0;
                          i--)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: AppStateNotifier.isDarkModeOn
                                ? Constants.mdecoration.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    boxShadow: [],
                                  )
                                : Constants.mdecoration.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                            child: RecentlyOpenedNotesTile(
                              recentlyOpenedNotes:
                                  recentlyOpenedNotesBox.getAt(i),
                              index: i,
                              showLargeTitle: true,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
