import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_subjectdisplay/fd_subjectviewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/FilterSubjects_view/filtersubjects_view.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';

class FDSubjectView extends StatelessWidget {
  final String sem;
  final String br;
  final Document path;
  const FDSubjectView(
      {@required this.sem, @required this.br, @required this.path, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FDSubjectViewModel>.reactive(
      onModelReady: (model) => model.setListOfSubBySemAndBr(sem, br),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            title: Text("OU Notes"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(
                      'OU Notes is probably the an App to find all lastest Academic Material for Osmania University including\n 1. Notes (PDF , e-books etc.)\n 2. Syllabus\n 3. Previous Question Papers\n 4. Resources (helpful links for learning online)\n. Check it out on Google Play!\n https://play.google.com/store/apps/details?id=com.notes.ounotes',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
              )
            ],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          height: App(context).appScreenHeightWithOutSafeArea(0.88),
          child: FilterSubjectsView(
            path: path,
            data: model.subjectBySemAndBr,
          ),
        ),
      ),
      viewModelBuilder: () => FDSubjectViewModel(),
    );
  }
}
