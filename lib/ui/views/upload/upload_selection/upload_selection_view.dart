import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/upload/upload_selection/upload_selection_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/SaveButtonView.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UploadSelectionView extends StatelessWidget {
  final String subjectName;
  final Document path;
  UploadSelectionView({this.subjectName, this.path});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadSelectionViewModel>.reactive(
        onModelReady: (model) {
          model.path = path;
          model.subjectName = subjectName;
        },
        builder: (context, model, child) => Scaffold(
              body: Container(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF73AEF5),
                              Color(0xFF61A4F1),
                              Color(0xFF478DE0),
                              Color(0xFF398AE5),
                            ],
                            stops: [0.1, 0.4, 0.7, 0.9],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 30),
                              Text(
                                "UPLOAD DOCUMENT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              // SizedBox(
                              //   height: 30.0,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // if (!widget.swipe)
                              SaveButtonView(
                                onTap: model.navigateToNotes,
                                text: "NOTES",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // if (!widget.swipe)
                              SaveButtonView(
                                onTap: model.navigateToQuestionPapers,
                                text: "QUESTION PAPERS",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // if (!widget.swipe)
                              SaveButtonView(
                                onTap: model.navigateToSyllabus,
                                text: "SYLLABUS",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // if (!widget.swipe)
                              SaveButtonView(
                                onTap: model.navigateToLinks,
                                text: "LINKS",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => UploadSelectionViewModel());
  }
}
