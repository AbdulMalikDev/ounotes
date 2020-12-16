import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/generic_subject_tile/generic_subject_tile_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/user_subject_list/user_subject_list_viewmodel.dart';
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
      builder: (context, model, child) => 
      similarSubjects.length==0
      ?Container() 
      :Column(
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
                  //  padding: const EdgeInsets.all(10),
                  // color: Colors.yellow,
                  child: Center(
                    child: ListTile(
                      title: Container(
                        //color: Colors.blue,
                        // constraints: BoxConstraints(maxWidth: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      // leading: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Container(
                      //       width: 8,
                      //       padding: EdgeInsets.all(0),
                      //       margin: EdgeInsets.all(0),
                      //       child: Icon(
                      //         Icons.more_vert,
                      //         color: theme.colorScheme.onBackground,
                      //       ),
                      //     ),
                      //     Container(
                      //       padding: EdgeInsets.all(0),
                      //       margin: EdgeInsets.all(0),
                      //       child: Icon(
                      //         Icons.more_vert,
                      //         color: theme.colorScheme.onBackground,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     CircleAvatar(
                      //       backgroundColor: Theme.of(context).primaryColor,
                      //       child: Text(
                      //         subject.name.substring(0, 1).toUpperCase(),
                      //         style: theme.appBarTheme.textTheme.headline6
                      //             .copyWith(
                      //                 fontSize: 17,
                      //                 fontWeight: FontWeight.normal),
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
