import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_DocumentDisplay/fd_documentviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FDDocumentView extends StatelessWidget {
  final String subjectName;
  final Document path;
  const FDDocumentView({@required this.subjectName, this.path, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FDDocumentDisplayViewModel>.reactive(
      onModelReady: (model)=>model.setScreen(path, subjectName),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(subjectName,style: Theme.of(context).appBarTheme.textTheme.headline6,),
        ),
        body: model.screen,
      ),
      viewModelBuilder: () => FDDocumentDisplayViewModel(),
    );
  }
}
