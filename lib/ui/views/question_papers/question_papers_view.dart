import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/question_paper_tile/question_paper_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestionPapersView extends StatefulWidget {
  final String subjectName;
  final String path;
  const QuestionPapersView({@required this.subjectName, this.path, Key key})
      : super(key: key);

  @override
  _QuestionPapersViewState createState() => _QuestionPapersViewState();
}

class _QuestionPapersViewState extends State<QuestionPapersView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<QuestionPapersViewModel>.reactive(
      onModelReady: (model) => model.fetchQuestionPapers(widget.subjectName),
      builder: (context, model, child) => SingleChildScrollView(
        child: Container(
          height: widget.path != null
              ? MediaQuery.of(context).size.height * 0.86
              : MediaQuery.of(context).size.height * 0.78,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: widget.path != null
                        ? MediaQuery.of(context).size.height * 0.86
                        : MediaQuery.of(context).size.height * 0.73,
                    width: double.infinity,
                    child: model.isBusy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : model.questionPapers.length == 0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/study5.jpg',
                                      alignment: Alignment.center,
                                      width: 300,
                                      height: 300,
                                    ),
                                    Text(
                                      "Question Papers are empty!",
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
                            : ListView.builder(
                                itemCount: model.questionPapers?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (model.questionPapers[index].GDriveLink ==
                                      null) {
                                    return Container();
                                  }
                                  QuestionPaper questionPaper =
                                      model.questionPapers[index];
                                  return InkWell(
                                    child: QuestionPaperTileView(
                                      ctx: context,
                                      note: questionPaper,
                                      index: index,
                                      downloadedQp: [],
                                    ),
                                    onTap: () {
                                      model.onTap(context, questionPaper);
                                    },
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
      viewModelBuilder: () => QuestionPapersViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
