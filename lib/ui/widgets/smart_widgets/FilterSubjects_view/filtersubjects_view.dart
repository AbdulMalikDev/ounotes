import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/FilterSubjects_view/filtersubjects_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FilterSubjectsView extends StatelessWidget {
  final Document path;
  final List<Subject> data;
  const FilterSubjectsView({@required this.path, @required this.data, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<FilterSubjectsViewModel>.reactive(
        builder: (context, model, child) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: data.length,
                  // separatorBuilder: (context, index) => Divider(
                  //   color: Colors.black45,
                  // ),
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.background,
                        boxShadow: AppStateNotifier.isDarkModeOn
                            ? []
                            : [
                                BoxShadow(
                                    offset: Offset(10, 10),
                                    color: theme.cardTheme.shadowColor,
                                    blurRadius: 25),
                                BoxShadow(
                                    offset: Offset(-10, -10),
                                    color: theme.cardTheme.color,
                                    blurRadius: 25)
                              ],
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 80,
                        child: ListTile(
                          title: Text(data[index].name,
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              data[index]
                                  .name
                                  .toUpperCase()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: theme.appBarTheme.textTheme.headline6
                                  .copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                          onTap: () {
                            model.onTap(data[index].name, path);
                          },
                        ),
                      ),
                    );
                  }),
            ),
        viewModelBuilder: () => FilterSubjectsViewModel());
  }
}
