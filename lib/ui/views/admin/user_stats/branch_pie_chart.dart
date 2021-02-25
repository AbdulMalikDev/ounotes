import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BranchPieOutsideLabelChart extends StatelessWidget {
  final bool animate;
  final List<Branch> br;

  BranchPieOutsideLabelChart({this.animate, this.br});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SfCircularChart(
          legend: Legend(
              isVisible: true,
              // Overflowing legend content will be wraped
              overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries<Branch, dynamic>>[
            // Render pie chart
            PieSeries<Branch, String>(
              dataSource: br,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
              ),
              xValueMapper: (Branch data, _) => data.br,
              yValueMapper: (Branch data, _) => data.noOfStudents,
            ),
          ],
        ),
      ),
    );
  }
}
