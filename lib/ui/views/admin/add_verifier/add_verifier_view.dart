import 'package:FSOUNotes/models/verifier.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/shared/strings.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/textFormField.dart';
import 'package:FSOUNotes/ui/views/admin/add_verifier/add_verifier_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/dumb_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class AddVerifierView extends StatelessWidget {
  final Verifier verifier;
  AddVerifierView({this.verifier});
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController collegeController = TextEditingController();

 @override
 Widget build(BuildContext context) {
   var theme = Theme.of(context);
   return ViewModelBuilder<AddVerifierViewModel>.reactive(
     onModelReady:(model) => model.init(verifier,emailController,nameController,branchController,semesterController,collegeController),
     builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: ModalProgressHUD(
            // inAsyncCall: model.isloading,
            inAsyncCall: false,
            progressIndicator: _progressIndicatorWithPercentage(model,context),
            child: Container(
              child: SingleChildScrollView(
                child: model.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    elevation: 10,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal:10),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 25),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: TextFormFieldView(
                                              heading: 'Email',
                                              hintText:
                                                  'Email...',
                                              controller:
                                                  emailController,
                                              validator: (value) {
                                                if (value.length < 3)
                                                  return 'Min length-6';
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            // margin: const EdgeInsets.only(top: 10),
                                            child: TextFormFieldView(
                                              isLargeTextField: true,
                                              textInputType:
                                                  TextInputType.multiline,
                                              heading: 'Name',
                                              hintText:
                                                  'Sharfu',
                                              controller:
                                                  nameController,
                                              validator: (value) {
                                                if (value.length < 3)
                                                  return 'Min length-6';
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            // margin: const EdgeInsets.only(top: 10),
                                            child: TextFormFieldView(
                                              isLargeTextField: true,
                                              textInputType:
                                                  TextInputType.multiline,
                                              heading: 'Branch',
                                              hintText:
                                                  'CSE',
                                              controller:
                                                  branchController,
                                              validator: (value) {
                                                if (value.length < 3)
                                                  return 'Min length-6';
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            // margin: const EdgeInsets.only(top: 10),
                                            child: TextFormFieldView(
                                              isLargeTextField: true,
                                              textInputType:
                                                  TextInputType.multiline,
                                              heading: 'Semester',
                                              hintText:
                                                  '5',
                                              controller:
                                                  semesterController,
                                              validator: (value) {
                                                if (value.length < 3)
                                                  return 'Min length-6';
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            // margin: const EdgeInsets.only(top: 10),
                                            child: TextFormFieldView(
                                              isLargeTextField: true,
                                              textInputType:
                                                  TextInputType.multiline,
                                              heading: 'College',
                                              hintText:
                                                  'MJCET',
                                              controller:
                                                  collegeController,
                                              validator: (value) {
                                                if (value.length < 3)
                                                  return 'Min length-6';
                                                return null;
                                              },
                                            ),
                                          ),
                                          // SizedBox(height:10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: RaisedButton(
                                                    color: Colors.teal,
                                                    child: Text(
                                                      "GET USER",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      model.getVerifierDetails();
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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: RaisedButton(
                                                    color: Colors.red,
                                                    child: Text(
                                                      "ADD VERIFIER",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () async {
                                                      await model.addVerifier();
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
      ),
     viewModelBuilder: () => AddVerifierViewModel(),
   );
 }

 Widget _progressIndicatorWithPercentage(model,context) {
   int progress = 0;
   return Center(
              child: Container(
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
            );
 }
}