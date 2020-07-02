import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UploadLogView extends StatefulWidget {
  const UploadLogView({Key key}) : super(key: key);

  @override
  _UploadLogViewState createState() => _UploadLogViewState();
}

class _UploadLogViewState extends State<UploadLogView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = Theme.of(context);
    return ViewModelBuilder<UploadLogViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          //color: Colors.yellow,
          height: MediaQuery.of(context).size.height * 0.8,
          // alignment: Alignment.center,
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
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
                        itemCount: model.logs.length,
                        itemBuilder: (ctx, index) {
                          UploadLog logItem = model.logs[index];
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
                                      "File Name : " + logItem.fileName,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "FileType : " + logItem.type,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "Subject Name :" + logItem.subjectName,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "Email of Uploader : " + logItem.email,
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "UploadedAt : " + logItem.date.toString(),
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      "Size : " + logItem.size ?? "0",
                                      style: theme.textTheme.subtitle1
                                          .copyWith(fontSize: 18),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await model.deleteLogItem(logItem);
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
      viewModelBuilder: () => UploadLogViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
