import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/ui/shared/strings.dart';
import 'package:FSOUNotes/ui/views/admin/AddEditSubject/textFormField.dart';
import 'package:FSOUNotes/ui/views/admin/upload_log/upload_log_detail/upload_log_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UploadLogDetailView extends StatelessWidget {
  final UploadLog logItem;
  TextEditingController notificationTitleController = TextEditingController();
  TextEditingController notificationBodyController= TextEditingController();
  UploadLogDetailView({this.logItem});
  bool isBanned = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<UploadLogDetailViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: 
              model.isBusy 
              ? Center(child:CircularProgressIndicator())
              : Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50,),
                  model.isBusy
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
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
                                      RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: 'File Name : ',style: theme.textTheme.subtitle1
                                            .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                              TextSpan(text: logItem.fileName ?? "null",style: theme.textTheme.subtitle1),
                                            ],
                                          ),
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: 'FileType : ',style: theme.textTheme.subtitle1
                                            .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                              TextSpan(text: logItem.type ?? "null",style: theme.textTheme.subtitle1),
                                            ],
                                          ),
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'Subject Name : ',style: theme.textTheme.subtitle1
                                              .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                TextSpan(text: logItem.subjectName ?? "null",style: theme.textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                      SizedBox(height: 10),
                                      RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'Email of Uploader : ',style: theme.textTheme.subtitle1
                                              .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                TextSpan(text: logItem.email ?? "null",style: theme.textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                      SizedBox(height: 10),
                                      RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'UploadedAt : ',style: theme.textTheme.subtitle1
                                              .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                TextSpan(text: logItem.date.toString() ?? "null",style: theme.textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                      SizedBox(height: 10),
                                      RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'Size : ',style: theme.textTheme.subtitle1
                                              .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                TextSpan(text: logItem.size ?? "0" ?? "null",style: theme.textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                      SizedBox(height: 10),
                                      FutureBuilder(
                                        future: model.getUploadStatus(logItem),
                                        builder: (context, AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData)
                                          {
                                            return RichText(
                                              text: TextSpan(
                                                style: DefaultTextStyle.of(context).style,
                                                children: <TextSpan>[
                                                  TextSpan(text: 'Upload Status : ',style: theme.textTheme.subtitle1
                                                .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                  TextSpan(text: snapshot.data ?? "0"),
                                                ],
                                              ),
                                            );
                                          }else{
                                            return Text("EMPTY");
                                          }
                                        }
                                      ),
                                      SizedBox(height: 10),
                                      FutureBuilder(
                                        future: model.getNotificationStatus(logItem),
                                        builder: (context, AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData)
                                          {
                                            return RichText(
                                                text: TextSpan(
                                                  style: DefaultTextStyle.of(context).style,
                                                  children: <TextSpan>[
                                                    TextSpan(text: 'Notification Status : ',style: theme.textTheme.subtitle1
                                                  .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                    TextSpan(text: snapshot.data ?? "NONE"),
                                                  ],
                                                ),
                                            );
                                          }else{
                                            return Text("EMPTY");
                                          }
                                        }
                                      ),
                                      SizedBox(height: 10),
                                      FutureBuilder(
                                        future: model.getUser(logItem.uploader_id),
                                        builder: (context, AsyncSnapshot<User> snapshot) {
                                          if (snapshot.hasData)
                                          {
                                            User user =  snapshot.data;
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style,
                                                    children: <TextSpan>[
                                                      TextSpan(text: 'Uploads : ',style: theme.textTheme.subtitle1
                                                    .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                      TextSpan(text: user?.numOfUploads?.toString() ?? "NONE"),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                RichText(
                                                    text: TextSpan(
                                                      style: DefaultTextStyle.of(context).style,
                                                      children: <TextSpan>[
                                                        TextSpan(text: 'Accepted Uploads : ',style: theme.textTheme.subtitle1
                                                      .copyWith(fontSize: 18,fontWeight: FontWeight.bold),),
                                                        TextSpan(text: user?.numOfAcceptedUploads?.toString() ?? "NONE"),
                                                      ],
                                                    ),
                                                  ),
                                              ],
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
                                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                child: RaisedButton(
                                                color: Colors.teal,
                                                child: Text("EDIT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  model.navigateToEditScreen(logItem);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.teal,
                                            child: Text("VIEW",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            onPressed: ()async {
                                              await model.viewDocument(logItem);
                                            },
                                          ),
                                              ),),
                                          Expanded(
                                            child: FittedBox(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                  color: Colors.blue[700],
                                            child: Text("UPLOAD",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            onPressed: () async {
                                                await model.uploadDocument(logItem);
                                            },
                                          ),
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                color: Colors.red,
                                            child: FittedBox(child: Text("DELETE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
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
                                              print(Strings.upload_log_accept_notification_title(logItem));
                                              notificationTitleController.text = Strings.upload_log_accept_notification_title(logItem);
                                              notificationBodyController.text = Strings.upload_log_accept_notification_body(logItem);
                                              // model.sendNotification(logItem,notificationTitleController.text,);
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
                                              notificationTitleController.text = Strings.upload_log_deny_notification_title(logItem);
                                              notificationBodyController.text = Strings.upload_log_deny_notification_body(logItem);
                                              // model.deny(logItem);
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
                                              notificationTitleController.text = Strings.upload_log_ban_notification_title;
                                              notificationBodyController.text = Strings.upload_log_ban_notification_body;
                                              isBanned = true;
                                              // model.ban(logItem);
                                            },
                                          ),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                child: RaisedButton(
                                                color: Colors.teal,
                                                child: Text("MESSAGE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  notificationTitleController.text = Strings.upload_log_adminmsg_notification_title;
                                                  notificationBodyController.text = Strings.upload_log_adminmsg_notification_body;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 25),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: TextFormFieldView(
                                          
                                          heading: 'Notification Title',
                                          hintText: 'Enter Notification Title',
                                          controller: notificationTitleController,
                                          validator: (value) {
                                            if (value.length < 3) return 'Min length-6';
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        // margin: const EdgeInsets.only(top: 10),
                                        child: TextFormFieldView(
                                          isLargeTextField: true,
                                          textInputType: TextInputType.multiline,
                                          heading: 'Notification Body',
                                          hintText: 'Enter Notification Body',
                                          controller: notificationBodyController,
                                          validator: (value) {
                                            if (value.length < 3) return 'Min length-6';
                                            return null;
                                          },
                                        ),
                                      ),
                                      // SizedBox(height:10),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                child: RaisedButton(
                                                color: Colors.teal,
                                                child: Text("SEND",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  model.sendNotification(logItem,notificationTitleController.text,notificationBodyController.text,isBanned: isBanned);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                child: RaisedButton(
                                                color: Colors.red,
                                                child: Text("DELETE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                onPressed: () async {
                                                  await model.deleteLogItem(logItem);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
      viewModelBuilder:() => UploadLogDetailViewModel(),
    );
  }

}