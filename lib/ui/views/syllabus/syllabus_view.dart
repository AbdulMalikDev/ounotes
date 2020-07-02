import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/views/syllabus/syllabus_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/syllabus_tile.dart/syllabus_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class SyllabusView extends StatefulWidget {
  final String subjectName;
  final String path;
  const SyllabusView({@required this.subjectName, this.path, Key key})
      : super(key: key);

  @override
  _SyllabusViewState createState() => _SyllabusViewState();
}

class _SyllabusViewState extends State<SyllabusView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<SyllabusViewModel>.reactive(
        onModelReady: (model) => model.fetchQuestionPapers(widget.subjectName),
        builder: (context, model, child) => ModalProgressHUD(
              inAsyncCall: model.isloading ? true : false,
              progressIndicator: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 80,
                  width: 230,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      circularProgress(),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(maxWidth: 180),
                            child: Text(
                              'Downloading...',
                              // model.progress.toStringAsFixed(0) +
                              // '%',
                              overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: widget.path != null
                      ? MediaQuery.of(context).size.height * 0.86
                      : MediaQuery.of(context).size.height * 0.78,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            height: widget.path != null
                                ? model.isloading
                                    ? MediaQuery.of(context).size.height *
                                        0.84 //chota
                                    : MediaQuery.of(context).size.height *
                                        0.86 //bada
                                : model.isloading
                                    ? MediaQuery.of(context).size.height *
                                        0.68 //chota
                                    : MediaQuery.of(context).size.height *
                                        0.73, //bada

                            width: double.infinity,
                            child: model.isBusy
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount: model.syllabus.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Syllabus syllabus = model.syllabus[index];
                                      return InkWell(
                                          child: SyllabusTileView(
                                            syllabus: syllabus,
                                            index: index,
                                            downloadedsyllabus: model
                                                .getListOfSyllabusInDownloads(
                                                    widget.subjectName),
                                          ),
                                          onTap: () {
                                            model.onTap(doc: syllabus);
                                          });
                                    }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => SyllabusViewModel());
  }

  @override
  bool get wantKeepAlive => true;
}
