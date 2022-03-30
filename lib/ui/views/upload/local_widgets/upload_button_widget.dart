import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/SaveButtonView.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../shared/app_config.dart';

class UploadButtonWidget extends StatefulWidget {
  final UploadViewModel model;
  final GlobalKey<FormState> formKey;
  final Function handleUpload;
  const UploadButtonWidget({
    Key key,
    this.model,
    @required this.formKey,
    @required this.handleUpload,
  }) : super(key: key);

  @override
  State<UploadButtonWidget> createState() => _UploadButtonWidgetState();
}

class _UploadButtonWidgetState extends State<UploadButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // if (model.textFieldsMap != Constants.GDRIVELink)
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
              value: widget.model.isTermsAndConditionsChecked,
              onChanged: widget.model.changeCheckMark,
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
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 20,
                    child: TextButton(
                      onPressed: () {
                        widget.model.navigatetoPrivacyPolicy();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Text(
                        "Privacy policy",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 20,
                    child: TextButton(
                      onPressed: () {
                        widget.model.navigateToTermsAndConditionView();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Text(
                        'Terms and condition',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
        height: 30,
      ),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          height: App(context).appHeight(0.05),
          child: ElevatedButton(
            onPressed: () async {
              if (!widget.formKey.currentState.validate()) {
                // Invalid!
                return;
              }
              if (!widget.model.isTermsAndConditionsChecked) {
                Fluttertoast.showToast(
                    msg: "Please tick the box to Agree Terms and conditions ");
                return;
              }
              await widget.handleUpload();
            },
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
              primary: Colors.teal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: new Text(
              "Upload",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    ]);
  }
}
