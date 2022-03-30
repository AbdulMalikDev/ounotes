import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../misc/constants.dart';

class SubjectNameField extends StatefulWidget {
  final UploadViewModel model;
  const SubjectNameField({Key key, this.model}) : super(key: key);

  @override
  State<SubjectNameField> createState() => _SubjectNameFieldState();
}

class _SubjectNameFieldState extends State<SubjectNameField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            "Subject Name",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),   
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: TypeAheadFormField(
            key: ValueKey("SubjectField"),
            textFieldConfiguration: TextFieldConfiguration(
              controller: widget.model.controllerOfSub,
              decoration: InputDecoration(
                hintText: "PHYSICS...",
                labelStyle: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: primary),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                contentPadding: EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            suggestionsCallback: (pattern) {
              return widget.model.getSuggestions(pattern);
              // return ["s"];
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 15),
                ),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              this.widget.model.controllerOfSub.text = suggestion;
            },
            errorBuilder: (BuildContext context, Object error) => Text(
              '$error',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please select a subjectname';
              } else if (value.length < 3 ||
                  !widget.model.getAllSubjectsList().contains(value))
                return "Please enter a valid subject name";
              return null;
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
