import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'user_stats_viewmodel.dart';

class SemVerticalBarLabelChart extends StatelessWidget {
  final List<Sem> semesters;
  final bool animate;

  SemVerticalBarLabelChart({this.animate, this.semesters});
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSampleData(semesters),
      animate: animate,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Sem, String>> _createSampleData(
      List<Sem> semesters) {
    return [
      new charts.Series<Sem, String>(
          id: 'sem',
          domainFn: (Sem sem, number) => 'sem ${number + 1}',
          measureFn: (Sem sem, _) => sem.noOfStudents,
          data: semesters,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (Sem sem, number) => '${sem.noOfStudents}')
    ];
  }
}
