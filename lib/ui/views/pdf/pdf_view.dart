import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:FSOUNotes/models/document.dart';

class PDFScreen extends StatefulWidget {
  final String pathPDF;
  final AbstractDocument doc;
  PDFScreen({this.pathPDF, this.doc});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController _pdfViewerController;
  String title = "Notes";

  @override
  Widget build(BuildContext context) {
    //* The app bar is a bit annoying when in landscape
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons. bookmark,
            color: Colors.white,
          ),
          onPressed: () {
            _pdfViewerKey.currentState?.openBookmarkView();
          },
        ),
      ],
    ),
      body: SfPdfViewer.file(
        File(widget.pathPDF),
        key: _pdfViewerKey,
      ),
    );
  }


  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    if (widget.doc?.title != null)title = widget.doc?.title; 
    super.initState();
  }
}
