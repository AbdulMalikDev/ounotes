import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/drop_down_button_view.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
      onModelReady: (model) {
        model.fetchQuestionPapers(widget.subjectName);
        model.init();
      },
      builder: (context, model, child) => SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10),
          child: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.questionPapers.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: App(context).appHeight(0.1),
                          ),
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Sort by ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          fontSize: 15,
                                        ),
                                  ),
                                  Flexible(
                                    child: DropDownButtonView(
                                      selectedItem: model.selectedSortingMethod,
                                      dropDownMenuItems:
                                          model.dropdownofsortingmethods,
                                      changedDropDownItem: model
                                          .changedDropDownItemOfQuestionSortType,
                                      dropDownColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                MdiIcons.filterVariant,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: model.questionPaperTiles,
                        ),
                        SizedBox(
                          height: 50,
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
