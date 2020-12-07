import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_viewmodel.dart';
import 'package:FSOUNotes/ui/views/admin/user_stats/sem_bar_chart.dart';
import 'package:FSOUNotes/ui/views/admin/user_stats/college_horizontal_barchart.dart';
import 'package:FSOUNotes/ui/views/admin/user_stats/branch_pie_chart.dart';
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
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Semester",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Expanded(
                      child: SemVerticalBarLabelChart(
                        animate: false,
                        semesters: model.semesters,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "College",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Expanded(
                      child: CollegePieOutsideLabelChart(
                        animate: false,
                        college: model.colleges,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: model.colleges
                      .map(
                        (entry) => Text(
                            "${model.clgs[entry.collegeName]} : ${entry.noOfStudents}"),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Branch",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Expanded(
                      child: BranchPieOutsideLabelChart(
                        animate: false,
                        br: model.branches,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => UserStatsViewModel(),
    );
  }
}
