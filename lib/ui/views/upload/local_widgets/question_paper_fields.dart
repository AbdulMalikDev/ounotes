import 'package:FSOUNotes/ui/views/upload/local_widgets/year_widget.dart';
import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_card.dart';
import 'package:flutter/material.dart';

class QuestionPaperFields extends StatefulWidget {
  final UploadViewModel model;

  const QuestionPaperFields({Key key, this.model}) : super(key: key);

  @override
  State<QuestionPaperFields> createState() => _QuestionPaperFieldsState();
}

class _QuestionPaperFieldsState extends State<QuestionPaperFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        YearFieldWidget(
          model: widget.model,
        ),
        SizedBox(
          height: 30.0,
        ),
        SelectionCard(
          isExpanded: true,
          title: "Select Branch",
          value: widget.model.br,
          items: widget.model.dropdownofbr,
          onChanged: widget.model.changedDropDownItemOfBranch,
        ),
      ],
    );
  }
}
