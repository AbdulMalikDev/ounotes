import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/recently_open_notes.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentlyOpenedNotesTile extends StatelessWidget {
  final RecentlyOpenedNotes recentlyOpenedNotes;
  final int index;
  final bool showLargeTitle;

  const RecentlyOpenedNotesTile({
    Key key,
    this.recentlyOpenedNotes,
    this.index,
    this.showLargeTitle = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final String title = recentlyOpenedNotes.title != null
        ? recentlyOpenedNotes.title.toUpperCase()
        : "title";
    final String author = recentlyOpenedNotes.author != null
        ? recentlyOpenedNotes.author.toUpperCase()
        : "author";
    final date = recentlyOpenedNotes.uploadDate;
    var format = new DateFormat("dd/MM/yy");
    var dateString = format.format(date);
    final int view = recentlyOpenedNotes.view;
    final String size = recentlyOpenedNotes.size.toString();
    var theme = Theme.of(context);
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    return InkWell(
      onTap: () {
        Helper.launchURL(recentlyOpenedNotes.url);
      },
      child: Container(
        height: App(context).appHeight(0.15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: App(context).appScreenHeightWithOutSafeArea(0.11),
                      width: App(context).appScreenWidthWithOutSafeArea(0.2),
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
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        showLargeTitle ? wp * 0.6 : wp * 0.4,
                                  ),
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
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
                          Text(
                            "Author :$author",
                            style: TextStyle(
                                color: primary,
                                fontSize: 13,
                                letterSpacing: .3),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 10,
                          ),
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
                          SizedBox(
                            width: 10,
                          ),
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
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
