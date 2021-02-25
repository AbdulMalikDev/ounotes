import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CollegePieOutsideLabelChart extends StatefulWidget {
  final bool animate;
  final List<College> college;

  CollegePieOutsideLabelChart({this.animate, this.college});

  @override
  _CollegePieOutsideLabelChartState createState() => _CollegePieOutsideLabelChartState();
}

class _CollegePieOutsideLabelChartState extends State<CollegePieOutsideLabelChart> {
  Map<String, String> clgs = {
    "Muffakham Jah College of Engineering and Technology": "MJCET",
    "Osmania University's College of Technology": "OU",
    "CBIT": "CBIT",
    "Vasavi": "VASAVI",
    "MVSR ": "MVSR",
    "Deccan College ": "DECCAN",
    "ISL Engineering College": "ISL",
    "Methodist ": "METHODIST",
    "Stanley College ": "STANLEY",
    "NGIT": "NGIT",
    "University College of Engineering": "UNIVERSITY",
    "Matrusri Engineering College": "MATRUSRI",
    "Swathi Institute of Technology & Science": "SWATHI",
    "JNTU Affiliated Colleges": "JNTU",
    "Other": "OTHER",
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SfCircularChart(
          legend: Legend(
              isVisible: true,
              // Overflowing legend content will be wraped
              overflowMode: LegendItemOverflowMode.wrap,

             ),
          series: <CircularSeries>[
            // Renders doughnut chart
            DoughnutSeries<College, String>(
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
              ),
              dataSource: widget.college,
              xValueMapper: (College data, _) => data.collegeName,
              yValueMapper: (College data, _) => data.noOfStudents,
            )
          ],
        ),
      ),
    );
  }
}
