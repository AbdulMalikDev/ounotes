import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../misc/constants.dart';
import '../web_upload_document/web_document_edit_viewmodel.dart';

class LinkFields extends StatefulWidget {
  final UploadViewModel model;
  const LinkFields({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  State<LinkFields> createState() => _LinkFieldsState();
}

class _LinkFieldsState extends State<LinkFields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          if (widget.model.textFieldsMap != Constants.Notes)
            TextFormFieldView(
              textFieldUniqueKey:
                  ValueKey(widget.model.textFieldsMap["TextFieldHeading1"]),
              heading: widget.model.textFieldsMap["TextFieldHeading1"],
              hintText: widget.model.textFieldsMap["TextFieldHeadingLabel1"],
              controller: widget.model.textFieldController1,
            ),
          if (widget.model.textFieldsMap["TextFieldHeading2"] != null)
            TextFormFieldView(
              textFieldUniqueKey:
                  ValueKey(widget.model.textFieldsMap["TextFieldHeading2"]),
              heading: widget.model.textFieldsMap["TextFieldHeading2"],
              hintText: widget.model.textFieldsMap["TextFieldHeadingLabel2"],
              controller: widget.model.textFieldController2,
            ),
          if (widget.model.textFieldsMap["TextFieldHeading3"] != null)
            TextFormFieldView(
              textFieldUniqueKey:
                  ValueKey(widget.model.textFieldsMap["TextFieldHeading3"]),
              heading: widget.model.textFieldsMap["TextFieldHeading3"],
              hintText: widget.model.textFieldsMap["TextFieldHeadingLabel3"],
              controller: widget.model.textFieldController3,
            ),
        ],
      ),
    );
  }
}
