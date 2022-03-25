import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/SaveButtonView.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/TextFieldView.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/drop_down_button_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class UploadView extends StatefulWidget {
  final Map textFieldsMap;
  //used to know whether user selected notes,syllabus,question paper or  links after opening upload selection view
  final Document uploadType;
  final String subjectName;
  UploadView({this.textFieldsMap, @required this.subjectName, @required this.uploadType});

  @override
  _UploadViewState createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final TextEditingController textFieldController3 = TextEditingController();
  TextEditingController controllerOfSub = TextEditingController();
  final TextEditingController controllerOfYear = TextEditingController();
  final TextEditingController controllerOfYear2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controllerOfSub = TextEditingController(text: widget.subjectName);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadViewModel>.reactive(
      onModelReady: (model) {
        model.initialise(widget.uploadType);
        print(widget.uploadType);
        if (widget.subjectName != null) {
          controllerOfSub.text = widget.subjectName;
        }
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          //TODO change this after testing is done
          // return !model.isBusy;
          return true;
        },
        child: Scaffold(
          body: Container(
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
                          key: this._formKey,
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
                                    "UPLOAD ${model.document.toUpperCase()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: -0.03,
                                      fontFamily: 'Montserrat',
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 50.0),
                                  if (widget.textFieldsMap !=
                                      Constants.GDRIVELink)
                                    subjectNameField(model),
                                  widget.textFieldsMap == Constants.Syllabus
                                      ? buildSyllabusEntries(model)
                                      : widget.textFieldsMap ==
                                              Constants.QuestionPaper
                                          ? buildQuestionPaperEntries(model)
                                          : buildLinkAndNotesEntries(
                                              model, widget.textFieldsMap),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  uploadButtonWidget(model)
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
      ),
      viewModelBuilder: () => UploadViewModel(),
    );
  }

  Widget subjectNameField(UploadViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Enter Subject Name",
          style: Constants.kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Card(
          color: Colors.transparent,
          child: Container(
            decoration: Constants.kBoxDecorationStyle,
            height: 60,
            child: TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controllerOfSub,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 15.0),
                  prefixIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                  ),
                  hintText: "Indian Constitution ...",
                  hintStyle: Constants.kLabelStyle,
                ),
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: -0.03,
                  fontFamily: 'Montserrat',
                ),
              ),
              suggestionsCallback: (pattern) {
                return model.getSuggestions(pattern);
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
                this.controllerOfSub.text = suggestion;
              },
              errorBuilder: (BuildContext context, Object error) => Text(
                '$error',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select a subjectname';
                } else if (value.length < 3 ||
                    !model.getAllSubjectsList().contains(value))
                  return "Please enter a valid subject name";
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget buildSyllabusEntries(UploadViewModel model) {
    return Column(
      children: <Widget>[
        Center(
          child: Container(
            decoration: Constants.kBoxDecorationStyle,
            height: App(context).appHeight(0.12),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                Text(
                  "Select Semester",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: 3,
                ),
                Expanded(
                  child: Container(
                    child: DropdownButton(
                        elevation: 15,
                        iconEnabledColor: Colors.black,
                        value: model.sem,
                        items: model.dropdownofsem,
                        onChanged: model.changedDropDownItemOfSemester,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        dropdownColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: Constants.kBoxDecorationStyle,
          height: App(context).appHeight(0.12),
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Text(
                "Select Branch",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(
                height: 3,
              ),
              Expanded(
                child: Container(
                  child: DropdownButton(
                      iconEnabledColor: Colors.black,
                      focusColor: Colors.transparent,
                      value: model.br,
                      items: model.dropdownofbr,
                      onChanged: model.changedDropDownItemOfBranch,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      dropdownColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        buildYearWidget(model.typeofyear, model.dropdownofyear,
            model.changedDropDownItemOfYear),
      ],
    );
  }

  Widget buildQuestionPaperEntries(UploadViewModel model) {
    return Column(
      children: <Widget>[
        buildYearWidget(model.typeofyear, model.dropdownofyear,
            model.changedDropDownItemOfYear),
        SizedBox(
          height: 30.0,
        ),
        Container(
          decoration: Constants.kBoxDecorationStyle,
          height: App(context).appHeight(0.12),
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Text(
                "Select Branch",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(
                height: 3,
              ),
              Expanded(
                child: Container(
                  height: App(context).appScreenHeightWithOutSafeArea(0.085),
                  child: DropdownButton(
                      iconEnabledColor: Colors.black,
                      focusColor: Colors.transparent,
                      value: model.br,
                      items: model.dropdownofbr,
                      onChanged: model.changedDropDownItemOfBranch,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      dropdownColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLinkAndNotesEntries(UploadViewModel model, Map textFieldsMap) {
    return Column(
      children: <Widget>[
        if (textFieldsMap == Constants.GDRIVELink)
          Container(
            decoration: Constants.mdecoration.copyWith(
                color: Theme.of(context).colorScheme.background, boxShadow: []),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Note:",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: primary),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      children: [
                        //TODO add note Malik
                        TextSpan(text: 'TODO add note'),
                        // WidgetSpan(
                        //   child: Padding(
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 2.0),
                        //     child: Icon(Icons.file_download, size: 18),
                        //   ),
                        // ),
                        // TextSpan(text: ' you can find them in your '),
                        // TextSpan(
                        //     text: 'Internal Storage > Downloads',
                        //     style: TextStyle(fontWeight: FontWeight.bold)),
                        // TextSpan(text: ' folder of your mobile'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (textFieldsMap != Constants.GDRIVELink)
          TextFieldView(
              heading: widget.textFieldsMap["TextFieldHeading1"],
              labelText: widget.textFieldsMap["TextFieldHeadingLabel1"],
              textFieldController: textFieldController1),
        SizedBox(
          height: 30.0,
        ),
        if (widget.textFieldsMap["TextFieldHeading2"] != null)
          TextFieldView(
              heading: widget.textFieldsMap["TextFieldHeading2"],
              labelText: widget.textFieldsMap["TextFieldHeadingLabel2"],
              textFieldController: textFieldController2),
        SizedBox(
          height: 30.0,
        ),
        if (widget.textFieldsMap["TextFieldHeading3"] != null)
          TextFieldView(
              heading: widget.textFieldsMap["TextFieldHeading3"],
              labelText: widget.textFieldsMap["TextFieldHeadingLabel3"],
              textFieldController: textFieldController3),
        if (textFieldsMap == Constants.Notes)
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Text(
                  "Number of Units",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SfRangeSlider(
                min: 1.0,
                max: 5.0,
                interval: 1,
                stepSize: 1,
                showTicks: true,
                showLabels: true,
                values: model.sfValues,
                enableTooltip: true,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.white,
                onChanged: (dynamic newValue) {
                  model.setSfValues = newValue;
                },
              ),
              SizedBox(height: 20),
            ],
          ),
      ],
    );
  }

  Widget uploadButtonWidget(UploadViewModel model) {
    return Column(children: [
      // if (widget.textFieldsMap != Constants.GDRIVELink)
      //   Row(
      //     children: [
      //       Container(
      //         child: Checkbox(
      //           value: model.canUseUploaderUserName,
      //           onChanged: model.changeCheckMark2,
      //           activeColor: Colors.amber,
      //         ),
      //       ),
      //       //TODO malik add dummy string here
      //       Flexible(
      //         child: Text(
      //           "Hey, ${model.user.username}...can we show your name as uploader below this note?",
      //           style: TextStyle(color: Colors.white, fontSize: 15),
      //         ),
      //       )
      //     ],
      //   ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: <Widget>[
          Container(
            child: Checkbox(
              value: model.isTermsAndConditionsChecked,
              onChanged: model.changeCheckMark,
              activeColor: Colors.amber,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'I agree to OU Notes ',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Container(
                    height: 20,
                    child: TextButton(
                      onPressed: () {
                        model.navigatetoPrivacyPolicy();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Text(
                        "Privacy policy",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'and  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: 20,
                    child: TextButton(
                      onPressed: () {
                        model.navigateToTermsAndConditionView();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Text(
                        'Terms and condition',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: 10,
      ),
      SaveButtonView(
        onTap: () async {
          if (!_formKey.currentState.validate()) {
            // Invalid!
            return;
          }
          if (!model.isTermsAndConditionsChecked) {
            Fluttertoast.showToast(
                msg: "Please tick the box to Agree Terms and conditions ");
            return;
          }
          //Here I have access to all TextFieldControllers therfore
          //I can extract the text and perform my upload logic
          model.typeofyear == CourseInfo.yeartype[0]
              ? model.setYear = controllerOfYear.text
              : model.setYear =
                  controllerOfYear.text + '-' + controllerOfYear2.text;
          await model.handleUpload(
            textFieldController1.text,
            textFieldController2.text,
            textFieldController3.text,
            widget.uploadType,
            controllerOfSub.text,
            context,
          );
        },
      ),
    ]);
  }

  Widget buildYearWidget(typeofyear, dropdownofyear,
      void Function(dynamic) changedropdownitemofyear) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Enter Year",
          style: Constants.kLabelStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          // padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(5),
          height: App(context).appHeight(0.05),
          width: App(context).appWidth(0.4),
          child: DropDownButtonView(
            selectedItem: typeofyear,
            dropDownColor: Colors.white,
            changedDropDownItem: changedropdownitemofyear,
            dropDownMenuItems: dropdownofyear,
            width: App(context).appWidth(0.35),
            // focusColor: Colors.transparent,
            // value: ,
            // items: ,
            // onChanged: ,
            // style: TextStyle(color: Colors.black, fontSize: 20),
            // dropdownColor: ,
            // iconEnabledColor: Colors.black,
          ),
        ),
        SizedBox(height: 10.0),
        typeofyear == CourseInfo.yeartype[0]
            ? Card(
                color: Colors.transparent,
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: Constants.kBoxDecorationStyle,
                  height: 60,
                  child: TextFormField(
                    controller: controllerOfYear,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: -0.03,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 25.0),
                        prefixIcon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue,
                        ),
                        hintText: '2016',
                        hintStyle: Constants.kHintTextStyle),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter year.';
                      } else if (value.length < 3 ||
                          int.parse(value) > DateTime.now().year ||
                          int.parse(value) < 2000) {
                        return "Please enter valid year";
                      }
                      return null;
                    },
                  ),
                ),
              )
            : Row(
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Card(
                      color: Colors.transparent,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: Constants.kBoxDecorationStyle,
                        height: 60,
                        child: TextFormField(
                          controller: controllerOfYear,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: -0.03,
                            fontFamily: 'Montserrat',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 30.0),
                            prefixIcon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                            hintText: 'Start..',
                            hintStyle: Constants.kHintTextStyle,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter year.';
                            } else if (value.length < 3 ||
                                int.parse(value) > DateTime.now().year ||
                                int.parse(value) < 2000) {
                              return "Enter valid year";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 120,
                    child: Card(
                      color: Colors.transparent,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: Constants.kBoxDecorationStyle,
                        height: 60,
                        child: TextFormField(
                          controller: controllerOfYear2,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: -0.03,
                            fontFamily: 'Montserrat',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 30.0),
                            prefixIcon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                            hintText: 'End..',
                            hintStyle: Constants.kHintTextStyle,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter year .';
                            } else if (controllerOfYear.text.isEmpty) {
                              return 'Enter start year';
                            } else if (value.length < 3 ||
                                int.parse(value) > DateTime.now().year ||
                                int.parse(value) < 2000 ||
                                int.parse(value) <=
                                    int.parse(controllerOfYear.text ??
                                        DateTime.now().year)) {
                              return "Enter valid year";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
