import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import '../../../enums/constants.dart';

class DownLoadView extends StatefulWidget {
  const DownLoadView({Key key}) : super(key: key);

  @override
  _DownLoadViewState createState() => _DownLoadViewState();
}

class _DownLoadViewState extends State<DownLoadView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<DownLoadViewModel>.reactive(
      onModelReady: (model) {
        // model.getUser();
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Container(
              color: theme.colorScheme.background,
              child: TabBar(
                // TabBar
                controller: _tabController,
                labelColor: Colors.amber,
                indicatorColor: Theme.of(context).accentColor,
                unselectedLabelColor: theme.appBarTheme.iconTheme.color,
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white, fontSize: 13),
                tabs: <Widget>[
                  Tab(
                    text: "NOTES",
                  ),
                  Tab(
                    text: "Question Papers",
                  ),
                  Tab(
                    text: "Syllabus",
                  ),
                ],
              ),
            ),
            model.isBusy
                ? CircularProgressIndicator()
                : Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildDownloadList(
                            model: model,
                            boxName: Constants.notesDownloads,
                            type: Constants.notes),
                        buildDownloadList(
                          model: model,
                          boxName: Constants.questionPaperDownloads,
                          type: Constants.questionPapers,
                        ),
                        buildDownloadList(
                            model: model,
                            boxName: Constants.syllabusDownloads,
                            type: Constants.syllabus),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      viewModelBuilder: () => DownLoadViewModel(),
    );
  }

  Widget buildDownloadList(
      {DownLoadViewModel model, String boxName, String type}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Download>(boxName).listenable(),
            builder: (context, donwloadsBox, widget) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: donwloadsBox.length + 1,
                        itemBuilder: (context, index) {
                          bool isLastElem = index == donwloadsBox.length;
                          final download = isLastElem
                              ? null
                              : donwloadsBox.getAt(index) as Download;
                          return isLastElem
                              ? SizedBox(height: 60)
                              : GestureDetector(
                                  onTap: () {
                                    model.navigateToPDFScreen(download);
                                  },
                                  child: FractionallySizedBox(
                                    widthFactor: 0.99,
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
                                      child: DownloadListTile(
                                        type: type,
                                        download: download,
                                        index: index,
                                        onDeletePressed: () {
                                          model.deleteDownload(
                                            index: index,
                                            path: download.path,
                                            downloadBoxName: boxName,
                                            context: context,
                                            type: type,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget noDownloadsOverlay(BuildContext context) {
  return Stack(
    children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: Lottie.asset('assets/lottie/learn.json'),
      ),
      Positioned(
        top: App(context).appHeight(0.55),
        left: 60,
        right: 50,
        child: Text(
          "Your downloads will appear here",
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
        ),
      ),
    ],
  );
}

class DownloadListTile extends StatelessWidget {
  final Download download;
  final int index;
  final Function onDeletePressed;
  final String type;

  const DownloadListTile(
      {Key key,
      this.download,
      this.index,
      this.onDeletePressed,
      String this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.onPrimary;
    final secondary = Theme.of(context).colorScheme.secondary;
    String title = "";
    if (type == Constants.questionPapers) {
      title = download.year;
    } else if (type == Constants.syllabus) {
      title = "Semester ${download.semester} ${download.branch}";
    } else {
      title = download.title != null ? download.title.toUpperCase() : "title";
    }
    final String author = download.author != null ? download.author : "Admin";
    final String subjectName =
        download.subjectName != null ? download.subjectName : "";
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            height: App(context).appScreenHeightWithOutSafeArea(0.05),
            width: App(context).appScreenWidthWithOutSafeArea(0.15),
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                if (type == Constants.notes)
                  Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Text(
                          "Author: $author",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: Text(
                    "Subject: $subjectName",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.delete,
                size: 30,
                color: theme.primaryColor,
              ),
              onPressed: onDeletePressed,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

//legacy code

// Container(
//   margin: const EdgeInsets.symmetric(
//       horizontal: 15, vertical: 10),
//   decoration: BoxDecoration(),
//   child: Text(
//     "Notes which have been opened in the app will be shown here. If you have downloaded the notes by pressing the download icon, you can find them in your Internal Storage > Downloads folder of your mobile",
//     style: Theme.of(context)
//         .textTheme
//         .subtitle1
//         .copyWith(color: primary),
//   ),
// ),
// Container(
//   height: 40,
//   margin: const EdgeInsets.all(10),
//   width: App(context).appWidth(0.45),
//   child: RaisedButton(
//     textColor: Colors.white,
//     color: Colors.teal.shade500,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(30),
//     ),
//     onPressed: () {
//       model.buyPremium();
//     },
//     child: Row(
//       children: [
//         Text("Buy Premium"),
//         SizedBox(
//           width: 10,
//         ),
//         Icon(
//           MdiIcons.crown,
//           color: Colors.amber,
//         ),
//       ],
//     ),
//   ),
// ),

 // Container(
                      //   decoration: AppStateNotifier.isDarkModeOn
                      //       ? Constants.mdecoration.copyWith(
                      //           color: Theme.of(context).colorScheme.background,
                      //           boxShadow: [],
                      //         )
                      //       : Constants.mdecoration.copyWith(
                      //           color: Theme.of(context).colorScheme.background,
                      //         ),
                      //   padding: const EdgeInsets.all(10),
                      //   margin: const EdgeInsets.all(10),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         margin:
                      //             const EdgeInsets.symmetric(horizontal: 15),
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           "Note:",
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .headline6
                      //               .copyWith(color: primary),
                      //         ),
                      //       ),
                      //       Container(
                      //         margin: const EdgeInsets.symmetric(
                      //             horizontal: 15, vertical: 10),
                      //         decoration: BoxDecoration(),
                      //         child: RichText(
                      //           text: TextSpan(
                      //             style: Theme.of(context).textTheme.bodyText2,
                      //             children: [
                      //               TextSpan(
                      //                   text:
                      //                       'Notes which have been opened in the app will be shown here. If you have downloaded the notes by pressing the download icon '),
                      //               WidgetSpan(
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 2.0),
                      //                   child:
                      //                       Icon(Icons.file_download, size: 18),
                      //                 ),
                      //               ),
                      //               TextSpan(
                      //                   text: ' you can find them in your '),
                      //               TextSpan(
                      //                   text: 'Internal Storage > Downloads',
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold)),
                      //               TextSpan(text: ' folder of your mobile'),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
