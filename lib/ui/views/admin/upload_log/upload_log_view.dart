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
        body: SafeArea(
          child: Container(
            //color: Colors.yellow,
            // height: MediaQuery.of(context).size.height * 0.75,
            // alignment: Alignment.center,
            child: SingleChildScrollView(
              child: 
              model.isBusy ? Center(child:CircularProgressIndicator())
              : Column(
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
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.logs.length,
                          itemBuilder: (ctx, index) {
                            UploadLog logItem = model.logs[index];
                            return Container(
                              //height: 300,
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
                                      FutureBuilder(
                                        future: model.getUploadStatus(logItem),
                                        builder: (context, AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData)
                                          {
                                          return Text(
                                            "Upload Status : " + snapshot.data ?? "0",
                                            style: theme.textTheme.subtitle1
                                                .copyWith(fontSize: 18),
                                          );
                                          }else{
                                            return Text("EMPTY");
                                          }
                                        }
                                      ),
                                      FutureBuilder(
                                        future: model.getNotificationStatus(logItem),
                                        builder: (context, AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData)
                                          {
                                          return Text(
                                            "Notification Status : " + snapshot.data ?? "NONE",
                                            style: theme.textTheme.subtitle1
                                                .copyWith(fontSize: 18),
                                          );
                                          }else{
                                            return Text("EMPTY");
                                          }
                                        }
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.teal,
                                            child: Text("View",style: TextStyle(color: Colors.white),),
                                            onPressed: () {
                                              model.viewDocument(logItem);
                                            },
                                          ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.blue[700],
                                            child: Text("Upload",style: TextStyle(color: Colors.white),),
                                            onPressed: () {
                                              model.uploadDocument(logItem);
                                            },
                                          ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.red,
                                            child: FittedBox(child: Text("DELETE",style: TextStyle(color: Colors.white),)),
                                            onPressed: () {
                                              model.deleteDocument(logItem);
                                            },
                                          ),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.teal,
                                            child: FittedBox(child: Text("ACCEPT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                            onPressed: () {
                                              model.accept(logItem);
                                            },
                                          ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.blue[700],
                                            child: Text("DENY",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            onPressed: () {
                                              model.deny(logItem);
                                            },
                                          ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.red,
                                            child: FittedBox(child: Text("BAN",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                            onPressed: () {
                                              model.ban(logItem);
                                            },
                                          ),
                                              )),
                                        ],
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
                        ),
                  SizedBox(
                    height: 170,
                  ),
                ],
              ),
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
