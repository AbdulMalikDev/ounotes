import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputViewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FDInputView extends StatelessWidget {
  final Document path;
  const FDInputView({@required this.path, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<FDInputViewModel>.reactive(
      onModelReady: (model) => model.setTitleAccordingtoPath(path),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "OU Notes",
            style: theme.appBarTheme.textTheme.headline6,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width - 40,
                child: Center(
                  child: Text(
                    model.title,
                    style: theme.textTheme.subtitle1.copyWith(
                      decorationStyle: TextDecorationStyle.dashed,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  height: App(context).appHeight(0.13),
                  width: App(context).appWidth(1) - 40,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: Constants.mdecoration
                      .copyWith(color: theme.scaffoldBackgroundColor),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Select Semester",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Container(
                          child: DropdownButton(
                            value: model.sem,
                            items: model.dropdownofsem,
                            onChanged: model.changedDropDownItemOfSemester,
                            dropdownColor: theme.scaffoldBackgroundColor,
                            style: theme.textTheme.subtitle1
                                .copyWith(fontSize: 17),
                          ),
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
                height: App(context).appHeight(0.13),
                width: App(context).appHeight(1) - 40,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: Constants.mdecoration.copyWith(
                  color: theme.scaffoldBackgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Select Branch",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Container(
                        child: DropdownButton(
                          focusColor: Colors.transparent,
                          value: model.br,
                          items: model.dropdownofbr,
                          onChanged: model.changedDropDownItemOfBranch,
                          style:
                              theme.textTheme.subtitle1.copyWith(fontSize: 17),
                          dropdownColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: App(context).appScreenHeightWithOutSafeArea(0.1),
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  height: 55,
                  child: RaisedButton(
                    onPressed: () {
                      model.onTap(path);
                    },
                    textColor: Colors.white,
                    color: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: new Text(
                      "Search",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => FDInputViewModel(),
    );
  }
}
