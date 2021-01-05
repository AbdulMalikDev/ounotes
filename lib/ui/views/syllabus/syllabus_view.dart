import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/views/syllabus/syllabus_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/syllabus_tile.dart/syllabus_tile_view.dart';
import 'package:flutter/material.dart';
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
      onModelReady: (model) => model.fetchSyllabus(widget.subjectName),
      builder: (context, model, child) => SingleChildScrollView(
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
                        ? MediaQuery.of(context).size.height * 0.86
                        : MediaQuery.of(context).size.height * 0.73,
                    width: double.infinity,
                    child: model.isBusy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : model.syllabus.length == 0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/study3.jpg',
                                      alignment: Alignment.center,
                                      width: 300,
                                      height: 300,
                                    ),
                                    Text(
                                      "Syllabus is empty!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "why don't you upload some?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: model.syllabus.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Syllabus syllabus = model.syllabus[index];
                                  if (model.syllabus[index].GDriveLink ==
                                      null) {
                                    return Container();
                                  }
                                  return InkWell(
                                      child: SyllabusTileView(
                                        syllabus: syllabus,
                                        index: index,
                                      ),
                                      onTap: () {
                                        model.openDoc(context, syllabus);
                                      });
                                }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SyllabusViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
