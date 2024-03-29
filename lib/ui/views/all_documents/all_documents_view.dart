import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/ui/views/all_documents/all_documents_viewmodel.dart';
import 'package:FSOUNotes/ui/views/links/links_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_view.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_view.dart';
import 'package:FSOUNotes/ui/views/syllabus/syllabus_view.dart';
import 'package:FSOUNotes/ui/views/upload/upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class AllDocumentsView extends StatefulWidget {
  final String subjectName;
  final String path;
  final String newDocIDUploaded;
  AllDocumentsView(
      {@required this.subjectName, this.path, this.newDocIDUploaded});
  @override
  _AllDocumentsViewState createState() => _AllDocumentsViewState();
}

class _AllDocumentsViewState extends State<AllDocumentsView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;
  Intro intro;
  List<String> uploadPromptInfo;
  _AllDocumentsViewState() {
    if (OnboardingService.getNumberOfTimesDocumentViewOpened() % 25 == 0) {
      uploadPromptInfo = OnboardingService.getUploadPrompt();
      print(uploadPromptInfo[0]);
      intro = Intro(
        stepCount: 1,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        widgetBuilder: StepWidgetBuilder.useDefaultTheme(
          texts: [
            uploadPromptInfo[0],
          ],
          buttonTextBuilder: (curr, total) {
            return curr < total - 1 ? 'Next' : uploadPromptInfo[1];
          },
        ),
      );
    }
    OnboardingService.incrementNumberOfTimesDocumentViewOpened();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<AllDocumentsViewModel>.reactive(
        onModelReady: (model) async {
          model.subjectName = widget.subjectName;
          await model.handleStartup(context);
        },
        builder: (context, model, child) => DefaultTabController(
              length: 4,
              child: WillPopScope(
                onWillPop: () async {
                  if (intro != null) intro.dispose();
                  return true;
                },
                child: Scaffold(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  appBar: widget.path == "search"
                      ? null
                      : AppBar(
                          backgroundColor: theme.primaryColor,
                          iconTheme: IconThemeData(color: Colors.white),
                          bottom: TabBar(
                            controller: _tabController,
                            labelColor: Colors.amber,
                            indicatorColor: Theme.of(context).accentColor,
                            isScrollable: true,
                            unselectedLabelColor: Colors.white,
                            tabs: [
                              Tab(text: "NOTES", icon: Icon(Icons.description)),
                              Tab(
                                  text: "Question Papers",
                                  icon: Icon(Icons.note)),
                              Tab(
                                  text: "Syllabus",
                                  icon: Icon(Icons.event_note)),
                              Tab(
                                  text: "Resources",
                                  icon: Icon(Icons.library_books)),
                            ],
                          ),
                          title: RichText(
                            text: TextSpan(
                              text: model
                                  .getSubjectNameAcronym(widget.subjectName),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          actions: <Widget>[
                            // Container(
                            //   width: App(context).appWidth(0.24),
                            //   margin: EdgeInsets.symmetric(
                            //       horizontal: 5, vertical: 10),
                            //   child: RaisedButton(
                            //     color: Colors.amber,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20)),
                            //     child: FittedBox(
                            //       child: Text(
                            //         "Downloads",
                            //         style: TextStyle(
                            //           color: Colors.red,
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 12,
                            //         ),
                            //       ),
                            //     ),
                            //     onPressed: () {
                            //       model.navigateToDownloadScreen();
                            //     },
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              // width: App(context).appWidth(0.3),
                              child: ElevatedButton(
                                key: intro == null ? null : intro.keys[0],
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.red,
                                  highlightColor: Colors.white,
                                  child: FittedBox(
                                    child: Text(
                                      "UPLOAD DOCUMENT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UploadView(
                                        subjectName: widget.subjectName,
                                      ),
                                    ),
                                  );
                                  // model.onUploadButtonPressed();
                                },
                              ),
                            ),
                          ],
                          leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                  body: widget.path == "search"
                      ? Column(
                          // Column
                          children: <Widget>[
                            Container(
                              color: theme.primaryColor, // Tab Bar color change
                              child: TabBar(
                                // TabBar
                                controller: _tabController,
                                labelColor: Colors.amber,
                                indicatorColor: Theme.of(context).accentColor,
                                isScrollable: true,
                                unselectedLabelColor: Colors.white,
                                tabs: <Widget>[
                                  Tab(
                                      text: "NOTES",
                                      icon: Icon(Icons.description)),
                                  Tab(
                                      text: "Question Papers",
                                      icon: Icon(Icons.note)),
                                  Tab(
                                      text: "Syllabus",
                                      icon: Icon(Icons.event_note)),
                                  Tab(
                                      text: "Resources",
                                      icon: Icon(Icons.library_books)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  NotesView(
                                    subjectName: widget.subjectName,
                                  ),
                                  QuestionPapersView(
                                    subjectName: widget.subjectName,
                                  ),
                                  SyllabusView(
                                    subjectName: widget.subjectName,
                                  ),
                                  LinksView(
                                    subjectName: widget.subjectName,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            NotesView(
                              subjectName: widget.subjectName,
                              newDocIDUploaded: widget.newDocIDUploaded,
                            ),
                            QuestionPapersView(
                              subjectName: widget.subjectName,
                            ),
                            SyllabusView(
                              subjectName: widget.subjectName,
                            ),
                            LinksView(
                              subjectName: widget.subjectName,
                            ),
                          ],
                        ),
                ),
              ),
            ),
        viewModelBuilder: () => AllDocumentsViewModel());
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      intro?.start(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
