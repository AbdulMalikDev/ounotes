import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_card.dart';
import 'package:flutter/material.dart';

import '../../../../misc/course_info.dart';
import '../upload_viewmodel.dart';

class YearFieldWidget extends StatefulWidget {
  final UploadViewModel model;

  const YearFieldWidget({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  State<YearFieldWidget> createState() => _YearFieldWidgetState();
}

class _YearFieldWidgetState extends State<YearFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SelectionCard(
          isExpanded: true,
          title: "Enter Year",
          value: widget.model.typeofyear,
          items: widget.model.dropdownofyear,
          onChanged: widget.model.changedDropDownItemOfYear,
        ),
        SizedBox(height: 10.0),
        widget.model.typeofyear == CourseInfo.yeartype[0]
            ? TextFormField(
                key: ValueKey("year field"),
                controller: widget.model.controllerOfYear1,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  hintText: "2016",
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
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        key: ValueKey("year1 field"),
                        controller: widget.model.controllerOfYear1,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: "Start..",
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
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 120,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        key: ValueKey("year2 field"),
                        controller: widget.model.controllerOfYear2,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: -0.03,
                          fontFamily: 'Montserrat',
                        ),
                        decoration: InputDecoration(
                          hintText: "End..",
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter year .';
                          } else if (widget
                              .model.controllerOfYear1.text.isEmpty) {
                            return 'Enter start year';
                          } else if (value.length < 3 ||
                              int.parse(value) > DateTime.now().year ||
                              int.parse(value) < 2000 ||
                              int.parse(value) <=
                                  int.parse(
                                      widget.model.controllerOfYear1.text ??
                                          DateTime.now().year)) {
                            return "Enter valid year";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
