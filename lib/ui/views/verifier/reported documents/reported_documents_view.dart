import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/admin/AddEditSubject/textFormField.dart';
import 'package:FSOUNotes/ui/views/verifier/reported%20documents/reported_documents_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class ReportedDocumentsView extends StatelessWidget {
 TextEditingController additionalInfoController = TextEditingController();

 @override
 Widget build(BuildContext context) {
   var theme = Theme.of(context);
   return ViewModelBuilder<ReportedDocumentsViewModel>.reactive(
     builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child:
          model.isBusy 
          ? Center(child:CircularProgressIndicator())
          : model.reports.value?.length == 0 ?? false
              ? Center(
                  child: Container(
                    child: Text(
                      "Reports are empty!",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                )
              : ModalProgressHUD(
                inAsyncCall: model.isloading,
            progressIndicator: _loadingWidget(model),
                              child: Container(
                    //color: Colors.yellow,
                    height: MediaQuery.of(context).size.height * 0.85,
                    // alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                          text:'DELETE : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this to DELETE document once you are sure it is useless.\n'),
                                      TextSpan(text:'\n'),
                                      TextSpan(
                                          text:'PASS : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this to forward this document to the admin. This is typically used when there is a confusion. Enter your query in the additional info input to voice your concern THAN press the button.\n'),
                                      TextSpan(text:'\n'),
                                      TextSpan(
                                          text:'USELESS REPORT : ',
                                          style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                      TextSpan(
                                        text: 'Press this when you think the document is acceptable and the user reported it for an invalid reason.This will delete the report but not the document.\n'),
                                      // TextSpan(text:'\n'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          model.isBusy
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ValueListenableBuilder(
                                valueListenable: model.reports,
                                builder: (context, reports ,child) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: reports.length,
                                      itemBuilder: (ctx, index) {
                                        Report report = reports[index];
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
                                                  Text("Report Reason from users : ",style: TextStyle(fontWeight: FontWeight.w600),),
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
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: RaisedButton(
                                                            color: Colors.blue[700],
                                                        child: FittedBox(child: Text("VIEW",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                        onPressed: () {
                                                          model.view(report);
                                                        },
                                                      ),
                                                          )),
                                                      Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: RaisedButton(
                                                            color: Colors.yellow[700],
                                                        child: FittedBox(child: Text("DELETE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                        onPressed: () {
                                                          model.delete(report,index);
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
                                                          model.pass(report,index,additionalInfoController);
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
                                                        child: FittedBox(child: Text("USELESS REPORT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                        onPressed: () {
                                                          model.uselessReport(report,index);
                                                        },
                                                      ),
                                                          )),
                                                          
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
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
                                                // await model.deleteReport(report);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                }
                              )
                        ],
                      ),
                    ),
                  ),
              ),
        ),
      ),
     viewModelBuilder: () => ReportedDocumentsViewModel(),
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