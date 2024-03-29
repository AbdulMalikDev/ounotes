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
        body: SafeArea(
          child: model.reports?.length == 0 ?? false
              ? Center(
                  child: Container(
                    child: Text(
                      "Reports are empty!",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                )
              :Container(
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
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: model.reports.length,
                                itemBuilder: (ctx, index) {
                                  Report report = model.reports[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      elevation: 10,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(15),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              "Subject Name :" +
                                                  report.subjectName,
                                              style: theme.textTheme.subtitle1
                                                  .copyWith(fontSize: 18),
                                            ),
                                            Text(""),
                                            report.reportReasons == null
                                                ? Container()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: report
                                                        .reportReasons
                                                        .map((text) =>
                                                            Text(text))
                                                        .toList(),
                                                  ),
                                            Text(""),
                                            Text(
                                              "Email of Reporter : " +
                                                  report.email,
                                              style: theme.textTheme.subtitle1
                                                  .copyWith(fontSize: 18),
                                            ),
                                            Text(""),
                                            Text(
                                              "Reports : " +
                                                  report.reports.toString(),
                                              style: theme.textTheme.subtitle1
                                                  .copyWith(fontSize: 18),
                                            ),
                                            Text(""),
                                            Text(
                                              "Date : " +
                                                  report.date.toString(),
                                              style: theme.textTheme.subtitle1
                                                  .copyWith(fontSize: 18),
                                            ),
                                            Text(""),
                                            FutureBuilder(
                                                future:
                                                    model.getNotificationStatus(
                                                        report),
                                                builder: (context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                      "Notification Status : " +
                                                              snapshot.data ??
                                                          "NONE",
                                                      style: theme
                                                          .textTheme.subtitle1
                                                          .copyWith(
                                                              fontSize: 18),
                                                    );
                                                  } else {
                                                    return Text("EMPTY");
                                                  }
                                                }),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Colors.teal,
                                                    child: FittedBox(
                                                        child: Text(
                                                      "VIEW",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    onPressed: () {
                                                      model
                                                          .viewDocument(report);
                                                    },
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Colors.red,
                                                    child: FittedBox(
                                                        child: Text(
                                                      "DELETE",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    onPressed: () {
                                                      model.ban(report);
                                                    },
                                                  ),
                                                )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Colors.teal,
                                                    child: FittedBox(
                                                        child: Text(
                                                      "ACCEPT",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    onPressed: () {
                                                      model.accept(report);
                                                    },
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Colors.blue[700],
                                                    child: Text(
                                                      "DENY",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      model.deny(report);
                                                    },
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Colors.red,
                                                    child: FittedBox(
                                                        child: Text(
                                                      "BAN",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    onPressed: () {
                                                      model.ban(report);
                                                    },
                                                  ),
                                                )),
                                              ],
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
      ),
      viewModelBuilder: () => ReportViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
