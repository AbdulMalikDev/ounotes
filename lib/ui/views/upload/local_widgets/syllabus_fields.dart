import 'package:FSOUNotes/ui/views/upload/local_widgets/year_widget.dart';
import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../widgets/dumb_widgets/selection_card.dart';

class SyllabusFields extends StatefulWidget {
  final UploadViewModel model;
  const SyllabusFields({Key key, this.model}) : super(key: key);

  @override
  State<SyllabusFields> createState() => _SyllabusFieldsState();
}

class _SyllabusFieldsState extends State<SyllabusFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SelectionCard(
          isExpanded: true,
          title: "Select Semester",
          value: widget.model.sem,
          items: widget.model.dropdownofsem,
          onChanged: widget.model.changedDropDownItemOfSemester,
        ),
        SizedBox(
          height: 10,
        ),
        SelectionCard(
          isExpanded: true,
          title: "Select Branch",
          value: widget.model.br,
          items: widget.model.dropdownofbr,
          onChanged: widget.model.changedDropDownItemOfBranch,
        ),
        SizedBox(
          height: 10,
        ),
        YearFieldWidget(
          model: widget.model,
        ),
      ],
    );
  }
}
