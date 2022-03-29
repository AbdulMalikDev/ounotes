import 'package:FSOUNotes/misc/constants.dart';
import 'package:flutter/material.dart';

class TextFormFieldView extends StatelessWidget {
  final String heading;
  final String hintText;
  final Key textFieldUniqueKey;
  final bool isLargeTextField;
  final TextEditingController controller;
  final String Function(String) validator;
  final TextInputType textInputType;
  final Function onChanged;
  final String initialValue;

  const TextFormFieldView({
    Key key,
    @required this.heading,
    @required this.hintText,
    this.controller,
    this.validator,
    this.textInputType = TextInputType.emailAddress,
    this.onChanged,
    this.initialValue,
    this.isLargeTextField = false,
    this.textFieldUniqueKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            heading,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: TextFormField(
            key: textFieldUniqueKey,
            maxLines: isLargeTextField ? null : 1,
            initialValue: initialValue,
            controller: controller,
            keyboardType: textInputType,
            decoration: InputDecoration(
              hintText: hintText,
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
            validator: validator != null
                ? validator
                : (value) {
                    if (value.isEmpty) {
                      return 'Please enter $heading .';
                    } else if (value.length < 3) {
                      return "Please enter valid $heading";
                    }
                    return null;
                  },
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}