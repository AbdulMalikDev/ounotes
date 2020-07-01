import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
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
                              : ListView.builder(
                                  itemCount: model.questionPapers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    QuestionPaper questionPaper =
                                        model.questionPapers[index];
                                    return InkWell(
                                        child: QuestionPaperTileView(
                                          ctx: context,
                                          note: questionPaper,
                                          index: index,
                                          downloadedQp: model.getListOfQpInDownloads(widget.subjectName),
                                        ),
                                        onTap: model.isBusy
                                          ? null
                                          : () {
                                          model.onTap(
                                            notesName: questionPaper.title,
                                            subName: questionPaper.subjectName,
                                            note: questionPaper,
                                            //! This is used so that spelling is not messed up while uploading
                                            type: Constants.questionPapers,
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
        viewModelBuilder: () => QuestionPapersViewModel());
  }

  @override
  bool get wantKeepAlive => true;
}
