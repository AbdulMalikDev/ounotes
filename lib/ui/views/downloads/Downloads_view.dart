import 'package:FSOUNotes/ui/views/downloads/Downloads_viewmodel.dart';
import 'package:FSOUNotes/ui/views/downloads/QuestionPapers/Downloadedqp_view.dart';
import 'package:FSOUNotes/ui/views/downloads/Syllabus/Downloadedsyllabus_view.dart';
import 'package:FSOUNotes/ui/views/downloads/notes/Downloadednotes_view.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownLoadViewModel>.reactive(
      onModelReady: (model) => model.fetchListOfDownloads(),
      builder: (context, model, child) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text('My Downloads',
                style: Theme.of(context).appBarTheme.textTheme.headline6),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicatorColor: Theme.of(context).accentColor,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  text: "NOTES",
                  icon: Icon(Icons.description),
                ),
                Tab(
                  text: "Question Papers",
                  icon: Icon(Icons.note),
                ),
                Tab(
                  text: "Syllabus",
                  icon: Icon(Icons.event_note),
                ),
              ],
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: model.isBusy
              ? circularProgress()
              : model.downloadList.length == 0
                  ? TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        noDownloadsOverlay(context),
                        noDownloadsOverlay(context),
                        noDownloadsOverlay(context),
                      ],
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        DownloadedNotesView(),
                        DownloadedQuestionPaperView(),
                        DownloadedSyllabusView(),
                      ],
                    ),
        ),
      ),
      viewModelBuilder: () => DownLoadViewModel(),
    );
  }
}

Widget noDownloadsOverlay(BuildContext context) {
  return Center(
    child: Text(
      "Your downloads will appear here",
      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
    ),
  );
}
