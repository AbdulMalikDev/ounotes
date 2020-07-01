import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFScreen extends StatelessWidget {
  final String pathPDF;
  final String title;
  PDFScreen({this.pathPDF, this.title});

  @override
  Widget build(BuildContext context) {
    print(pathPDF);
    //* The app bar is a bit annoying when in landscape
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return PDFViewerScaffold(
        appBar: 
        isLandscape
        ?null
        :AppBar(
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ),
       path: pathPDF);
  }
}
