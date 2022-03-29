import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../misc/constants.dart';

class NoteAndLinkFields extends StatefulWidget {
  final UploadViewModel model;
  const NoteAndLinkFields({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  State<NoteAndLinkFields> createState() => _NoteAndLinkFieldsState();
}

class _NoteAndLinkFieldsState extends State<NoteAndLinkFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        if (widget.model.textFieldsMap == Constants.Notes)
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text(
                  "Number of Units",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              SfRangeSliderTheme(
                data: SfRangeSliderThemeData(
                  activeLabelStyle: Theme.of(context).textTheme.subtitle1,
                  inactiveLabelStyle: Theme.of(context).textTheme.subtitle1,
                ),
                child: SfRangeSlider(
                  min: 1.0,
                  max: 5.0,
                  interval: 1,
                  stepSize: 1,
                  showTicks: true,
                  showLabels: true,
                  values: widget.model.sfValues,
                  enableTooltip: true,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).colorScheme.onSurface,
                  onChanged: (dynamic newValue) {
                    widget.model.setSfValues = newValue;
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
      ],
    );
  }
}
