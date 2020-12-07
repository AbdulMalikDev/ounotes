import 'package:FSOUNotes/ui/views/admin/user_stats/user_stats_viewmodel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CollegePieOutsideLabelChart extends StatelessWidget {
  final bool animate;
  final List<College> college;

  CollegePieOutsideLabelChart({this.animate, this.college});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      _createSampleData(college),
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
  static List<charts.Series<College, String>> _createSampleData(
      List<College> br) {
    Map<String, String> clgs = {
      "Muffakham Jah College of Engineering and Technology": "MJCET",
      "Osmania University's College of Technology": "Osmania",
      "CBIT": "CBIT",
      "Vasavi": "VASAVI",
      "MVSR ": "MVSR",
      "Deccan College ": "DECCAN",
      "ISL Engineering College": "ISL",
      "Methodist": "METHODIST",
      "Stanley College ": "STANLEY",
      "NGIT": "NGIT",
      "University College of Engineering": "UNIVERSITY",
      "Matrusri Engineering College": "MATRUSRI",
      "Swathi Institute of Technology & Science": "SWATHI",
      "JNTU Affiliated Colleges": "JNTU",
      "Other": "OTHER",
    };

    return [
      new charts.Series<College, String>(
        id: 'College',
        domainFn: (College clg, _) => clg.collegeName,
        measureFn: (College clg, _) => clg.noOfStudents,
        data: br,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (College row, _) =>
            '${clgs[row.collegeName]}: ${row.noOfStudents}',
      )
    ];
  }
}
