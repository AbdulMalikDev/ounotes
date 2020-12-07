import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserStatsView extends StatelessWidget {
  const UserStatsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserStatsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(child: ListView(children: model.colleges.entries.map((entry) => Text("${entry.key} : ${entry.value}")).toList())),
              Expanded(child: ListView(children: model.branches.entries.map((entry) => Text("${entry.key} : ${entry.value}")).toList())),
              Expanded(child: ListView(children: model.semesters.entries.map((entry) => Text("${entry.key} : ${entry.value}")).toList())),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => UserStatsViewModel(),
    );
  }
}
