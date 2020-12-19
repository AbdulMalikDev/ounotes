import 'dart:async';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/ui/views/web_view/web_view_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  final Note note;
  final QuestionPaper questionPaper;
  final Syllabus syllabus;
  final String url;
  WebViewWidget({this.note, Key key, this.questionPaper, this.syllabus,this.url})
      : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  final _history = [];

  WebViewModel localModel;

  String subjectName;
  String title;
  String url;
  String br;
  String year;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
    _screenshotDisable(true);
    if (widget.note != null) {
      subjectName = widget.note.subjectName;
      title = widget.note.title;
      url = widget.note.GDriveLink;
    } else if (widget.questionPaper != null) {
      subjectName = widget.questionPaper.subjectName;
      year = widget.questionPaper.year;
      br = widget.questionPaper.branch;
      url = widget.questionPaper.GDriveLink;
    } else if(widget.syllabus != null) {
      subjectName = widget.syllabus.subjectName;
      year = widget.syllabus.year;
      br = widget.syllabus.branch;
      url = widget.syllabus.GDriveLink;
    }

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if ((url.contains("export=download") ||
                url.contains("docs.googleusercontent.com/")) &&
            localModel != null) {
          localModel.showDownloadPreventDialog(flutterWebViewPlugin);
        }
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    _onUrlChanged.cancel();
    _screenshotDisable(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //* Since The app bar is a bit annoying when in landscape
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return ViewModelBuilder.reactive(
        onModelReady: (model) => localModel = model,
        builder: (context, model, child) {
          return new WebviewScaffold(
            initialChild: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading ....",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
            hidden: true,
            url: url ?? widget.url,
            appBar: isLandscape
                ? null
                : new AppBar(
                    iconTheme: IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    title: new Text("Notes"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          final RenderBox box = context.findRenderObject();
                          String share = "";

                          if (widget.note != null) {
                            share =
                                "Notes Name: $title\n\nSubject Name: $subjectName\n\nLink:$url\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes";
                          } else if (widget.questionPaper != null) {
                            share =
                                "QuestionPaper year: $year\n\nSubject Name: $subjectName\n\nLink:$url\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes";
                          } else if(widget.syllabus != null) {
                            share =
                                "Syllabus Branch: $br\n\nSubject Name: $subjectName\n\nLink:$url\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes";
                          }
                          Share.share(share,
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size);
                        },
                      )
                    ],
                  ),
          );
        },
        viewModelBuilder: () => WebViewModel());
  }

  void _screenshotDisable(bool isDisable) async {
    AuthenticationService _Auth = locator<AuthenticationService>();
    bool isAdmin = await _Auth.getUser().then((value) => value.isAdmin);
    if(isAdmin){return;}
    if(isDisable)
    {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE); 
    }else{
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }
}
