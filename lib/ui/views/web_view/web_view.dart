import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  String url;
  WebViewWidget({this.url, Key key}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      initialChild: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loading ....",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 25),),
            SizedBox(height: 40,),
            CircularProgressIndicator(),
          ],
        ),
      ),
      hidden: true,
      url: widget.url,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: new Text("Notes"),
      ),
    );
  }
}
