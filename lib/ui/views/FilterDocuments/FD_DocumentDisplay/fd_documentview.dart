import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_DocumentDisplay/fd_documentviewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_app_bar.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_title_appbar.dart';
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
      onModelReady: (model) => model.setScreen(path, subjectName),
      builder: (context, model, child) => Scaffold(
        appBar: BackIconTitleAppBar(
          title: subjectName,
        ),
        body: model.screen,
      ),
      viewModelBuilder: () => FDDocumentDisplayViewModel(),
    );
  }
}
