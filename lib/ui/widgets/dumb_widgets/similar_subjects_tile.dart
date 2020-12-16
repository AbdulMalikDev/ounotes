import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/generic_subject_tile/generic_subject_tile_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_view.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class SimilarSubjectTile extends StatelessWidget {
  final List<Subject> similarSubjects;
  String title = "SIMILAR SUBJECTS";
  SimilarSubjectTile({@required this.similarSubjects});
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: AppStateNotifier.isDarkModeOn
          ? Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [],
            )
          : Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      child: ExpansionTileCard(
        elevation: 5,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        baseColor: Theme.of(context).colorScheme.background,
        expandedColor: AppStateNotifier.isDarkModeOn
            ? Theme.of(context).colorScheme.background
            : Colors.white.withOpacity(0.91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Text(
                  title,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GenericSubjectTileView(
                    similarSubjects: similarSubjects,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
