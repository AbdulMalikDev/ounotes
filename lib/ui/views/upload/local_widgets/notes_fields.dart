import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../misc/constants.dart';
import '../../../shared/app_config.dart';
import '../web_upload_document/web_document_edit_viewmodel.dart';

class NoteFields extends StatefulWidget {
  final WebDocumentEditViewModel model;
  final int index;
  const NoteFields({
    Key key,
    this.model,
    this.index,
  }) : super(key: key);

  @override
  State<NoteFields> createState() => _NoteFieldsState();
}

class _NoteFieldsState extends State<NoteFields> {
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController2 = TextEditingController();
  Note doc;

  SfRangeValues sfValues = SfRangeValues(2.0, 4.0);

  set setSfValues(SfRangeValues values) {
    setState(() {
      sfValues = values;
      //TODO use slider values
    });
  }

  @override
  void initState() {
    super.initState();
    doc = widget.model.documents[widget.index];
    print(widget.model.textFieldsMap);
  }

  void updateDocument() {
    widget.model.documents[widget.index] = doc;
    print("updated document with index ${widget.index}");
    Note n = widget.model.documents[widget.index];
    print(n.author);
    print(n.title);
  }

  @override
  Widget build(BuildContext context) {
    double wp = App(context).appWidth(1);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: App(context).appWidth(0.2), vertical: 20),
      decoration: AppStateNotifier.isDarkModeOn
          ? Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
              boxShadow: [],
            )
          : Constants.mdecoration.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              "File Name : ${widget.model.files[widget.index].name}",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: App(context).appScreenHeightWithOutSafeArea(0.15),
                    width: App(context).appScreenWidthWithOutSafeArea(0.1),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pdf.png',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Open",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: wp * 0.4,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormFieldView(
                        textFieldUniqueKey: ValueKey(
                            widget.model.textFieldsMap["TextFieldHeading1"]),
                        heading:
                            widget.model.textFieldsMap["TextFieldHeading1"],
                        hintText: widget
                            .model.textFieldsMap["TextFieldHeadingLabel1"],
                        controller: textFieldController1,
                        onChanged: (String value) {
                          doc.title = textFieldController1.text;
                          updateDocument();
                        },
                      ),
                      TextFormFieldView(
                        textFieldUniqueKey: ValueKey(
                            widget.model.textFieldsMap["TextFieldHeading2"]),
                        heading:
                            widget.model.textFieldsMap["TextFieldHeading2"],
                        hintText: widget
                            .model.textFieldsMap["TextFieldHeadingLabel2"],
                        controller: textFieldController2,
                        onChanged: (String value) {
                          doc.author = textFieldController2.text;
                          updateDocument();
                        },
                      ),
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
