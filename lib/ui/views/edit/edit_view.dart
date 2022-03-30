import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/ui/views/edit/edit_viewmodel.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/SaveButtonView.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/TextFieldView.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EditView extends StatefulWidget {
  final Map textFieldsMap;
  final Document path;
  // Here note indicates any document type
  final dynamic note;
  final String subjectName;
  final String title;

  EditView(
      {Key key,
      @required this.title,
      @required this.textFieldsMap,
      @required this.path,
      this.note,
      @required this.subjectName})
      : super(key: key);

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final TextEditingController textFieldController1 =
      TextEditingController(text: "1");
  final TextEditingController textFieldController2 =
      TextEditingController(text: "2");
  final TextEditingController textFieldController3 =
      TextEditingController(text: "3");
  final TextEditingController textFieldController4 =
      TextEditingController(text: "4");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textFieldController1.text = widget.title;
    if (widget.path == Document.Notes) {
      textFieldController2.text = widget.note.author;
      textFieldController3.text = widget.note.view.toString();
      textFieldController4.text = widget.note.votes.toString();
      print(widget.note.view.toString());
      print(widget.note.votes.toString());
    } else if (widget.path == Document.QuestionPapers) {
      textFieldController2.text = widget.note.branch;
    } else if (widget.path == Document.Syllabus) {
      textFieldController1.text = widget.note.semester;
      textFieldController2.text = widget.note.branch;
      textFieldController3.text = widget.note.year;
    } else if (widget.path == Document.Links) {
      textFieldController2.text = widget.note.description;
      textFieldController3.text = widget.note.linkUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("yo");
    return ViewModelBuilder<EditViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: model.isBusy
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Container(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF73AEF5),
                              Color(0xFF61A4F1),
                              Color(0xFF478DE0),
                              Color(0xFF398AE5),
                            ],
                            stops: [0.1, 0.4, 0.7, 0.9],
                          ),
                        ),
                      ),
                      model.isBusy
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(
                                    strokeWidth: 5,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "Please wait...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Large files may take some time...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Form(
                              key: _formKey,
                              child: Container(
                                height: double.infinity,
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40.0,
                                    vertical: 80.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 30),
                                      Text(
                                        "EDIT ${Constants.getConstantFromDoc(widget.path)}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: -0.03,
                                          fontFamily: 'Montserrat',
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 50.0),
                                      Column(
                                        children: <Widget>[
                                          TextFieldView(
                                              heading: widget.textFieldsMap[
                                                  "TextFieldHeading1"],
                                              labelText: widget.textFieldsMap[
                                                  "TextFieldHeadingLabel1"],
                                              textFieldController:
                                                  textFieldController1),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          if (widget.textFieldsMap[
                                                  "TextFieldHeading2"] !=
                                              null)
                                            TextFieldView(
                                                heading: widget.textFieldsMap[
                                                    "TextFieldHeading2"],
                                                labelText: widget.textFieldsMap[
                                                    "TextFieldHeadingLabel2"],
                                                textFieldController:
                                                    textFieldController2),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          if (widget.textFieldsMap[
                                                  "TextFieldHeading3"] !=
                                              null)
                                            TextFieldView(
                                                heading: widget.textFieldsMap[
                                                    "TextFieldHeading3"],
                                                labelText: widget.textFieldsMap[
                                                    "TextFieldHeadingLabel3"],
                                                textFieldController:
                                                    textFieldController3),
                                          if (widget.textFieldsMap[
                                                  "TextFieldHeading4"] !=
                                              null)
                                            TextFieldView(
                                                heading: widget.textFieldsMap[
                                                    "TextFieldHeading4"],
                                                labelText: widget.textFieldsMap[
                                                    "TextFieldHeadingLabel4"],
                                                textFieldController:
                                                    textFieldController4),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),
                                      // if (!widget.swipe)
                                      SaveButtonView(
                                        text: "UPDATE",
                                        onTap: () async {
                                          //Here i have access to all TextFieldControllers therfore
                                          //i can extract the text and perform my upload logic
                                          await model.handleUpdate(
                                            textFieldController1.text,
                                            textFieldController2.text,
                                            textFieldController3.text,
                                            textFieldController4.text,
                                            widget.path,
                                            widget.subjectName,
                                            context,
                                            widget.note,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
      ),
      viewModelBuilder: () => EditViewModel(),
    );
  }
}
