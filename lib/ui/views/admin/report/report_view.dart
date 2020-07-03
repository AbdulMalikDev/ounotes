import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/ui/views/admin/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key key}) : super(key: key);

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    super.build(context);
    return ViewModelBuilder<ReportViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          //color: Colors.yellow,
          height: MediaQuery.of(context).size.height * 0.85,
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                model.isBusy
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.reports.length,
                        itemBuilder: (ctx, index) {
                          Report report = model.reports[index];
                          print(model.data);
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Card(
                              color: Theme.of(context).colorScheme.background,
                              elevation: 10,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(15),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "File Name : " + report.title,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(""),
                                    Text(
                                      "FileType : " + report.type,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(""),
                                    Text(
                                      "Subject Name :" + report.subjectName,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(""),
                                    Text(
                                      "Email of Reporter : " + report.email,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(""),
                                    Text(
                                      "Reports : " + report.reports.toString(),
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(""),
                                    Text(
                                      "Date : " + report.date.toString(),
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await model.deleteReport(report);
                                },
                              ),
                            ),
                          );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ReportViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
