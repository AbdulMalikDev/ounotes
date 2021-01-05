import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/generic_subject_tile/generic_subject_tile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GenericSubjectTileView extends StatelessWidget {
  final List<Subject> similarSubjects;
  const GenericSubjectTileView({Key key, @required this.similarSubjects})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    similarSubjects.map((e) => print(e.name));
    return ViewModelBuilder<GenericSubjectTileViewModel>.reactive(
      builder: (context, model, child) => similarSubjects.length == 0
          ? Center(
              child: Text("No Similar Subjects !"),
            )
          : Column(
              children: List.generate(
                similarSubjects.length,
                (index) {
                  Subject subject = similarSubjects[index];
                  return Container(
                    height: App(context).appHeight(0.09),
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.background,
                    ),
                    child: Center(
                      child: Container(
                        child: Center(
                          child: ListTile(
                            title: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Text(
                                      subject.name,
                                      overflow: TextOverflow.clip,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 15),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: theme.colorScheme.onBackground,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              model.onTap(subject.name);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      viewModelBuilder: () => GenericSubjectTileViewModel(),
    );
  }
}
