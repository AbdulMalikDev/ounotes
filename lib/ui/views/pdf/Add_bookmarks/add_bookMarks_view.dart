import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/pdf/Add_bookmarks/add_bookMarks_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookMarkBottomSheet extends StatefulWidget {
  final Note note;
  final bool isInitial;

  BookMarkBottomSheet({
    Key key,
    this.note,
    this.isInitial,
  }) : super(key: key);

  @override
  _BookMarkBottomSheetState createState() => _BookMarkBottomSheetState();
}

class _BookMarkBottomSheetState extends State<BookMarkBottomSheet> {
  TextEditingController controllerForUnit1;
  TextEditingController controllerForUnit2;
  TextEditingController controllerForUnit3;
  TextEditingController controllerForUnit4;
  TextEditingController controllerForUnit5;
  TextEditingController controllerForUnit1PageNo;
  TextEditingController controllerForUnit2PageNo;
  TextEditingController controllerForUnit3PageNo;
  TextEditingController controllerForUnit4PageNo;
  TextEditingController controllerForUnit5PageNo;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookMarkBottomSheetViewModel>.reactive(
      viewModelBuilder: () => BookMarkBottomSheetViewModel(),
      onModelReady: (model) async {
        model.setNote = widget.note;
        await model.initialize();
        model.init(widget.isInitial);
        controllerForUnit1 = TextEditingController(text: model.unitTitles[1]);
        controllerForUnit2 = TextEditingController(text: model.unitTitles[2]);
        controllerForUnit3 = TextEditingController(text: model.unitTitles[3]);
        controllerForUnit4 = TextEditingController(text: model.unitTitles[4]);
        controllerForUnit5 = TextEditingController(text: model.unitTitles[5]);
        controllerForUnit1PageNo =
            TextEditingController(text: model.unitPageNos[1]);
        controllerForUnit2PageNo =
            TextEditingController(text: model.unitPageNos[2]);
        controllerForUnit3PageNo =
            TextEditingController(text: model.unitPageNos[3]);
        controllerForUnit4PageNo =
            TextEditingController(text: model.unitPageNos[4]);
        controllerForUnit5PageNo =
            TextEditingController(text: model.unitPageNos[5]);
        model.saveDataLocally();
      },
      builder: (
        BuildContext context,
        BookMarkBottomSheetViewModel model,
        Widget child,
      ) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            height: !model.isNextPressed
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Add BookMarks",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      !model.isNextPressed
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 13.0),
                                  child: Text(
                                    "How many Units are there in this pdf?",
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
                                  onChanged: (dynamic newValue) {
                                    model.setSfValues = newValue;
                                  },
                                ),
                                SizedBox(height: 50),
                                Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FlatButton(
                                        onPressed: () {
                                          model.setIsNextPressed = true;
                                          model.saveDataLocally();
                                        },
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 13.0),
                                  child: Text(
                                    "Add book Marks for these units!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                model.units[1]
                                    ? bookMarkEntry(
                                        context,
                                        controllerForUnit1,
                                        (String val) {
                                          model.unitTitles[1] = val;
                                          model.saveDataLocally();
                                        },
                                        controllerForUnit1PageNo,
                                        (String val) {
                                          model.unitPageNos[1] = val;
                                          model.saveDataLocally();
                                        },
                                      )
                                    : Container(),
                                model.units[2]
                                    ? bookMarkEntry(
                                        context,
                                        controllerForUnit2,
                                        (String val) {
                                          print(val);
                                          model.setUnitTitles(2, val);
                                          model.saveDataLocally();
                                        },
                                        controllerForUnit2PageNo,
                                        (String val) {
                                          model.unitPageNos[2] = val;
                                          model.saveDataLocally();
                                        })
                                    : Container(),
                                model.units[3]
                                    ? bookMarkEntry(
                                        context,
                                        controllerForUnit3,
                                        (String val) {
                                          model.unitTitles[3] = val;
                                          model.saveDataLocally();
                                        },
                                        controllerForUnit3PageNo,
                                        (String val) {
                                          model.unitPageNos[3] = val;
                                          model.saveDataLocally();
                                        },
                                      )
                                    : Container(),
                                model.units[4]
                                    ? bookMarkEntry(
                                        context,
                                        controllerForUnit4,
                                        (String val) {
                                          model.unitTitles[4] = val;
                                          model.saveDataLocally();
                                        },
                                        controllerForUnit4PageNo,
                                        (String val) {
                                          model.unitPageNos[4] = val;
                                          model.saveDataLocally();
                                        },
                                      )
                                    : Container(),
                                model.units[5]
                                    ? bookMarkEntry(
                                        context,
                                        controllerForUnit5,
                                        (String val) {
                                          model.unitTitles[5] = val;
                                          model.saveDataLocally();
                                        },
                                        controllerForUnit5PageNo,
                                        (String val) {
                                          model.unitPageNos[5] = val;
                                          model.saveDataLocally();
                                        },
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: FlatButton(
                                        onPressed: () {
                                          var count = 0;
                                          Navigator.popUntil(
                                            context,
                                            (route) {
                                              return count++ == 2;
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Skip",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: FlatButton(
                                        onPressed: () {
                                          Map<String, int> bookMarks = {};
                                          for (int i = 1; i <= 5; i++) {
                                            if (model.units[i]) {
                                              bookMarks[model.unitTitles[i]] =
                                                  int.parse(
                                                      model.unitPageNos[i]);
                                            }
                                          }
                                          model.note.bookmarks = bookMarks;
                                          //TODO malik return back bookmarks to the screen ...
                                          var count = 0;
                                          Navigator.pop(
                                            context,
                                            (route) {
                                              return count++ == 2;
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Upload",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 400,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}

Widget bookMarkEntry(BuildContext context, TextEditingController controller1,
    Function onChange1, TextEditingController controller2, Function onChange2) {
  return Container(
    height: App(context).appHeight(0.09),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormFieldView(
            controller: controller1,
            onChanged: onChange1,
          ),
        ),
        Center(
          child: Text(":", style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        Expanded(
          child: TextFormFieldView(
            controller: controller2,
            onChanged: onChange2,
            textInputType: TextInputType.number,
          ),
        ),
      ],
    ),
  );
}

class TextFormFieldView extends StatelessWidget {
  final TextEditingController controller;
  final String Function(String) validator;
  final TextInputType textInputType;
  final Function onChanged;

  const TextFormFieldView({
    Key key,
    this.controller,
    this.validator,
    this.textInputType = TextInputType.emailAddress,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            decoration: InputDecoration(
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
            validator: validator,
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
