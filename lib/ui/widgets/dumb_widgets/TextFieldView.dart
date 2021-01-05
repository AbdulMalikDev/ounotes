import 'package:FSOUNotes/misc/constants.dart';
import 'package:flutter/material.dart';

class TextFieldView extends StatelessWidget {
  final String heading;
  final String labelText;
  final TextEditingController textFieldController;
  TextFieldView({this.heading, this.labelText, this.textFieldController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          heading,
          style: Constants.kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Card(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: Constants.kBoxDecorationStyle,
            height: 60,
            child: TextFormField(
              // maxLines:
              controller: textFieldController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
                letterSpacing: -0.03,
                fontFamily: 'Montserrat',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                ),
                hintText: labelText,
                // hintStyle: Constants.kHintTextStyle,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter $heading .';
                } else if (value.length < 3) {
                  return "Please enter valid $heading";
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
