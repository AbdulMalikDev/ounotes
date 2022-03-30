import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/textFormField.dart';
import 'package:FSOUNotes/ui/views/verifier/verify%20documents/verify_documents_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class VerifyDocumentsView extends StatelessWidget {
  TextEditingController additionalInfoController = TextEditingController();
 @override
 Widget build(BuildContext context) {
   var theme = Theme.of(context);
   return ViewModelBuilder<VerifyDocumentsViewModel>.reactive(
     builder: (context, model, child) => Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0.0,
        //   automaticallyImplyLeading: false,
        // ),
        body: SafeArea(
          child: ModalProgressHUD(
             inAsyncCall: model.isloading,
            progressIndicator: _loadingWidget(model),
                      child: Container(
              //color: Colors.yellow,
              // height: MediaQuery.of(context).size.height * 0.75,
              // alignment: Alignment.center,
              child: SingleChildScrollView(
                child: model.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if(model.isAdmin)
                          Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Colors.teal,
                                  child: FittedBox(
                                    child: Text(
                                      "📤  ALL DOCS",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await model.verifyAll();
                                  },
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: RaisedButton(
                            //       color: Colors.teal,
                            //       child: FittedBox(
                            //         child: Text(
                            //           "📤  SELECTED DOCS",
                            //           style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //       onPressed: () async {
                            //         // await model.uploadSelectedDocuments();
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                          decoration: AppStateNotifier.isDarkModeOn
                              ? Constants.mdecoration.copyWith(
                                  color: Theme.of(context).colorScheme.background,
                                  boxShadow: [],
                                )
                              : Constants.mdecoration.copyWith(
                                  color: Theme.of(context).colorScheme.background,
                                ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Note:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: primary),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(),
                                child: RichText(
                                  text: TextSpan(

                                    style: AppStateNotifier.isDarkModeOn
                                    ? Theme.of(context).textTheme.bodyText1
                                    : Theme.of(context).textTheme.bodyText2,
                                    children: [
                                      TextSpan(text:'\n'),
                                      TextSpan(
                                          text:'VIEW : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this to view documents\n'),
                                      TextSpan(text:'\n'),
                                      TextSpan(
                                          text:'VERIFY : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this to verify document after you have checked\n'),
                                      TextSpan(text:'\n'),
                                      TextSpan(
                                          text:'PASS : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this to forward this document to the admin. This is typically used when there is a confusion. Enter your query in the additional info input to voice your concern THAN press the button.\n'),
                                      TextSpan(text:'\n'),
                                      TextSpan(
                                          text:'USELESS UPLOAD : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this when you think the document is useless. Pressing this button will delete the document.\n'),
                                      // TextSpan(text:'\n'),
                                      // TextSpan(text:'\n'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: 5,
                          ),
                          model.isBusy
                              ? Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ValueListenableBuilder(
                                valueListenable: model.logs,
                                builder: (context, logs , child) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: logs.length,
                                      itemBuilder: (ctx, index) {
                                        UploadLog logItem = logs[index];
                                        if(logItem.isVerifierVerified)return Container();
                                        return Container(
                                          //height: 300,
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
                                                  // Text(
                                                  //   "File Name : " + logItem.fileName,
                                                  //   style: theme.textTheme.subtitle1
                                                  //       .copyWith(fontSize: 18),
                                                  // ),
                                                  RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'File Name : ',
                                                  style: theme
                                                      .textTheme.subtitle1
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: logItem.fileName ??
                                                        "null",
                                                    style: theme
                                                        .textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                                    text: TextSpan(
                                                      style:
                                                          DefaultTextStyle.of(context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'FileType : ',
                                                          style: theme
                                                              .textTheme.subtitle1
                                                              .copyWith(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        TextSpan(
                                                            text: logItem.type ??
                                                                "null",
                                                            style: theme
                                                                .textTheme.subtitle1),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      style:
                                                          DefaultTextStyle.of(context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Subject Name : ',
                                                          style: theme
                                                              .textTheme.subtitle1
                                                              .copyWith(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                logItem.subjectName ??
                                                                    "null",
                                                            style: theme
                                                                .textTheme.subtitle1),
                                                      ],
                                                    ),
                                                  ),
                                          // SizedBox(height: 10),
                                          RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Email of Uploader : ',
                                                  style: theme
                                                      .textTheme.subtitle1
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text:
                                                        logItem.email ?? "null",
                                                    style: theme
                                                        .textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'UploadedAt : ',
                                                  style: theme
                                                      .textTheme.subtitle1
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: logItem.date
                                                            .toString() ??
                                                        "null",
                                                    style: theme
                                                        .textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Size : ',
                                                  style: theme
                                                      .textTheme.subtitle1
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text: logItem.size ??
                                                        "0" ??
                                                        "null",
                                                    style: theme
                                                        .textTheme.subtitle1),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder(
                                              future: model
                                                  .getUser(logItem.uploader_id),
                                              builder: (context,
                                                  AsyncSnapshot<User>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  User user = snapshot.data;
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  'Uploads : ',
                                                              style: theme
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                            TextSpan(
                                                                text: user
                                                                        ?.numOfUploads
                                                                        ?.toString() ??
                                                                    "NONE"),
                                                          ],
                                                        ),
                                                      ),
                                                      // SizedBox(height: 10),
                                                      RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  'Accepted Uploads : ',
                                                              style: theme
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                            TextSpan(
                                                                text: user
                                                                        ?.numOfAcceptedUploads
                                                                        ?.toString() ??
                                                                    "NONE"),
                                                          ],
                                                        ),
                                                      ),
                                                      // Text(""),
                                                      // Text("Verifier Additional Info : ",style: TextStyle(fontWeight: FontWeight.w600),),
                                                      // logItem?.additionalInfoFromVerifiers == null
                                                      // ? Container()
                                                      // : Column(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .start,
                                                      //     children: logItem
                                                      //         .additionalInfoFromVerifiers
                                                      //         .map((text) =>
                                                      //             Text(text))
                                                      //         .toList(),
                                                      //   ),
                                                  // Text(""),
                                                    ],
                                                  );
                                                } else {
                                                  return Text("EMPTY");
                                                }
                                              }),
                                                  
                                                  // Text(
                                                  //   "Email of Uploader : " + logItem.email,
                                                  //   style: theme.textTheme.subtitle1
                                                  //       .copyWith(fontSize: 18),
                                                  // ),
                                                  // Text(
                                                  //   "UploadedAt : " + logItem.date.toString(),
                                                  //   style: theme.textTheme.subtitle1
                                                  //       .copyWith(fontSize: 18),
                                                  // ),
                                                  // Text(
                                                  //   "Size : " + logItem.size ?? "0",
                                                  //   style: theme.textTheme.subtitle1
                                                  //       .copyWith(fontSize: 18),
                                                  // ),
                                                  // FutureBuilder(
                                                  //     future: model
                                                  //         .getUploadStatus(logItem),
                                                  //     builder: (context,
                                                  //         AsyncSnapshot<String>
                                                  //             snapshot) {
                                                  //       if (snapshot.hasData) {
                                                  //         return RichText(
                                                  //           text: TextSpan(
                                                  //             style:
                                                  //                 DefaultTextStyle.of(
                                                  //                         context)
                                                  //                     .style,
                                                  //             children: <TextSpan>[
                                                  //               TextSpan(
                                                  //                 text:
                                                  //                     'Upload Status : ',
                                                  //                 style: theme
                                                  //                     .textTheme
                                                  //                     .subtitle1
                                                  //                     .copyWith(
                                                  //                         fontSize:
                                                  //                             18,
                                                  //                         fontWeight:
                                                  //                             FontWeight
                                                  //                                 .bold),
                                                  //               ),
                                                  //               TextSpan(
                                                  //                   text: snapshot
                                                  //                           .data ??
                                                  //                       "0"),
                                                  //             ],
                                                  //           ),
                                                  //         );
                                                  //       } else {
                                                  //         return Text("EMPTY");
                                                  //       }
                                                  //     }),
                                                  // FutureBuilder(
                                                  //     future:
                                                  //         model.getNotificationStatus(
                                                  //             logItem),
                                                  //     builder: (context,
                                                  //         AsyncSnapshot<String>
                                                  //             snapshot) {
                                                  //       if (snapshot.hasData) {
                                                  //         return RichText(
                                                  //           text: TextSpan(
                                                  //             style:
                                                  //                 DefaultTextStyle.of(
                                                  //                         context)
                                                  //                     .style,
                                                  //             children: <TextSpan>[
                                                  //               TextSpan(
                                                  //                 text:
                                                  //                     'Notification Status : ',
                                                  //                 style: theme
                                                  //                     .textTheme
                                                  //                     .subtitle1
                                                  //                     .copyWith(
                                                  //                         fontSize:
                                                  //                             18,
                                                  //                         fontWeight:
                                                  //                             FontWeight
                                                  //                                 .bold),
                                                  //               ),
                                                  //               TextSpan(
                                                  //                   text: snapshot
                                                  //                           .data ??
                                                  //                       "NONE"),
                                                  //             ],
                                                  //           ),
                                                  //         );
                                                  //       } else {
                                                  //         return Text("EMPTY");
                                                  //       }
                                                  //     }),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: RaisedButton(
                                                            color: Colors.blue[700],
                                                        child: FittedBox(child: Text("VIEW",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                        onPressed: () {
                                                          model.view(logItem);
                                                        },
                                                      ),
                                                          )),
                                                      Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: RaisedButton(
                                                            color: Colors.teal,
                                                        child: Text("VERIFY",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                        onPressed: () {
                                                          model.verify(logItem,index);
                                                        },
                                                      ),
                                                          )),
                                                      Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: RaisedButton(
                                                            color: Colors.red,
                                                        child: FittedBox(child: Text("PASS",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                        onPressed: () {
                                                          model.pass(logItem,additionalInfoController,index);
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
                                                            color: Colors.grey[700],
                                                        child: FittedBox(child: Text("USELESS UPLOAD",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                        onPressed: () {
                                                          model.uselessUpload(logItem,index);
                                                        },
                                                      ),
                                                          )),
                                                          
                                                    ],
                                                  ),
                                                  SizedBox(height: 3,),
                                                   Container(
                                                  margin: const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                                  alignment: Alignment.centerLeft,
                                                  child: TextFormFieldView(
                                                    heading: 'Additional Info',
                                                    hintText:
                                                        'Additional Info for Admin',
                                                    controller:
                                                        additionalInfoController,
                                                    validator: (value) {
                                                      if (value.length < 3)
                                                        return 'Min length-6';
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                ],
                                              ),
                                              onTap: () async {
                                                // await model
                                                //     .navigateToUploadLogDetailView(
                                                //         logItem);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                }
                              ),
                          // SizedBox(
                          //   height: 170,
                          // ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
     viewModelBuilder: () => VerifyDocumentsViewModel(),
   );
 }

 Widget _loadingWidget(model) {
   return Center(
              child: ValueListenableBuilder(
                valueListenable: model.downloadProgress,
                builder: (context, progress, child) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(10),
                  height: App(context).appHeight(0.17),
                  width: App(context).appWidth(0.87),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      circularProgress(),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(maxWidth: 180),
                            child: progress < 100
                                ? Text(
                                    'Downloading...' +
                                        progress.toStringAsFixed(0) +
                                        '%',
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontSize: 15),
                                  )
                                : Text(
                                    'Downloading...' + '100%',
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontSize: 15),
                                  ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 180),
                            child: Text(
                              'Large files may take some time...',
                              overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 180),
                            child: Text(
                              'Access downloads from Drawer > My Downloads',
                              overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
 }
}