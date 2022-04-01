import 'package:FSOUNotes/ui/views/upload/local_widgets/dropdownview.dart';
import 'package:flutter/material.dart';

import '../../../../misc/course_info.dart';
import '../../../shared/app_config.dart';

class YearFieldWidget extends StatefulWidget {
  final String typeofyear;
  final List<DropdownMenuItem<String>> dropdownofyear;
  final Function(String) changedDropDownItemOfYear;
  final TextEditingController controllerOfYear1;
  final TextEditingController controllerOfYear2;
  final Function onChangedYearField;

  const YearFieldWidget({
    Key key,
    this.typeofyear,
    this.dropdownofyear,
    this.changedDropDownItemOfYear,
    this.controllerOfYear1,
    this.controllerOfYear2,
    this.onChangedYearField,
  }) : super(key: key);

  @override
  State<YearFieldWidget> createState() => _YearFieldWidgetState();
}

class _YearFieldWidgetState extends State<YearFieldWidget> {
  @override
  Widget build(BuildContext context) {
    double wp = App(context).appWidth(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DropDownView(
          isExpanded: true,
          title: "Enter Year",
          value: widget.typeofyear,
          items: widget.dropdownofyear,
          onChanged: widget.changedDropDownItemOfYear,
        ),
        SizedBox(height: 10.0),
        Container(
          width: wp * 0.4,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: widget.typeofyear == CourseInfo.yeartype[0]
              ? TextFormField(
                  controller: widget.controllerOfYear1,
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
                  onChanged: widget.onChangedYearField,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          controller: widget.controllerOfYear1,
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
                          onChanged: widget.onChangedYearField,
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
                          controller: widget.controllerOfYear2,
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
                          onChanged: widget.onChangedYearField,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter year .';
                            } else if (widget.controllerOfYear1.text.isEmpty) {
                              return 'Enter start year';
                            } else if (value.length < 3 ||
                                int.parse(value) > DateTime.now().year ||
                                int.parse(value) < 2000 ||
                                int.parse(value) <=
                                    int.parse(widget.controllerOfYear1.text ??
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
        )
      ],
    );
  }
}
