import 'package:flutter/material.dart';
import 'user_stats_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SemVerticalBarLabelChart extends StatelessWidget {
  final List<Sem> semesters;
  final bool animate;

  SemVerticalBarLabelChart({this.animate, this.semesters});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          decimalPlaces: 0,
          header: "Semester",
        ),
        series: <ChartSeries>[
          ColumnSeries<Sem, String>(
              dataSource: semesters,
              // pointColorMapper: (College data, _) => data.color,
              enableTooltip: true,
              xValueMapper: (Sem data, _) =>
                  data.sem.substring(0, 3) + data.sem[data.sem.length - 1],
              yValueMapper: (Sem data, _) => data.noOfStudents,
            
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              width: 0.8, // Width of the columns
              spacing: 0.2 // Spacing between the columns
              ),
        ],
      ),
    );
  }
}
