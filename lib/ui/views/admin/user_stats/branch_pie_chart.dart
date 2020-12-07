import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_viewmodel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BranchPieOutsideLabelChart extends StatelessWidget {
  final bool animate;
  final List<Branch> br;

  BranchPieOutsideLabelChart({this.animate, this.br});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      _createSampleData(br),
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Branch, String>> _createSampleData(
      List<Branch> br) {
    return [
      new charts.Series<Branch, String>(
        id: 'Branch',
        domainFn: (Branch branch, _) => branch.br,
        measureFn: (Branch branch, _) => branch.noOfStudents,
        data: br,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Branch row, _) => '${row.br}: ${row.noOfStudents}',
      )
    ];
  }
}
