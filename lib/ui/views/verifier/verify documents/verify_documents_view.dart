import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/ui/views/admin/AddEditSubject/textFormField.dart';
import 'package:FSOUNotes/ui/views/verifier/verify%20documents/verify_documents_viewmodel.dart';
import 'package:flutter/material.dart';
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
                                            FutureBuilder(
                                                future: model
                                                    .getUploadStatus(logItem),
                                                builder: (context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    return RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                'Upload Status : ',
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
                                                              text: snapshot
                                                                      .data ??
                                                                  "0"),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return Text("EMPTY");
                                                  }
                                                }),
                                            FutureBuilder(
                                                future:
                                                    model.getNotificationStatus(
                                                        logItem),
                                                builder: (context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    return RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                'Notification Status : ',
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
                                                              text: snapshot
                                                                      .data ??
                                                                  "NONE"),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return Text("EMPTY");
                                                  }
                                                }),
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
                                                    // model.accept(logItem);
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
                                                    // model.deny(logItem);
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
                                                    // model.ban(logItem);
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
     viewModelBuilder: () => VerifyDocumentsViewModel(),
   );
 }
}