import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'links_tile_viewmodel.dart';

class LinksTileView extends StatelessWidget {
  final Link link;
  final int index;

  const LinksTileView({Key key, this.link, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = link.title.toUpperCase();
    final String url = link.linkUrl;
    final String description = link.description;
    final String subjectName = link.subjectName;

    return ViewModelBuilder<LinksTileViewModel>.reactive(
        builder: (context, model, child) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
              child: ExpansionTileCard(
                elevation: 5,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                baseColor:Theme.of(context).colorScheme.background,
                expandedColor: AppStateNotifier.isDarkModeOn
                    ? Theme.of(context).colorScheme.background
                    : Colors.white,
                leading: CircleAvatar(
                  child: Text(
                    title.substring(0, 1),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 16),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          title,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (Menu selectedValue) {
                        if (selectedValue == Menu.Report) {
                          model.reportNote(doc: link);
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
                subtitle: Text(
                  'Tap to see more!',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12),
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
                          Text(
                            'Subject: $subjectName',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Description: $description',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                'Open Link',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.white),
                              ),
                              onPressed: () {
                                model.openLink(url);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
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
                                      await model.navigateToEditView(link);
                                    },
                                  ),
                                ),
                                Container(
                                  child: RaisedButton(
                                    child: Text("DELETE",
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.red,
                                    onPressed: () async {
                                      await model.delete(link);
                                    },
                                  ),
                                ),
                              ])
                            : Container(),
                ],
              ),
            ),
        viewModelBuilder: () => LinksTileViewModel());
  }
}
