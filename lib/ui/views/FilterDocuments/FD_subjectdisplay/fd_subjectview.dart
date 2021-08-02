import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_subjectdisplay/fd_subjectviewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/FilterSubjects_view/filtersubjects_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

class FDSubjectView extends StatelessWidget {
  final String sem;
  final String br;
  final Document path;
  const FDSubjectView(
      {@required this.sem, @required this.br, @required this.path, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FDSubjectViewModel>.reactive(
      onModelReady: (model) => model.setListOfSubBySemAndBr(sem, br),
      builder: (context, model, child) => Scaffold(
        appBar: BackIconAppBar(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          child: FilterSubjectsView(
            path: path,
            data: model.subjectBySemAndBr,
          ),
        ),
      ),
      viewModelBuilder: () => FDSubjectViewModel(),
    );
  }
}
