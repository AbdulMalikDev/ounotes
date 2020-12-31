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
  TextEditingController _textEditingController;
  String title = "Notes";
  Color _color = Colors.red;
  Color _disabledColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    //* The app bar is a bit annoying when in landscape
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: isLandscape
          ? null
          : PreferredSize(preferredSize: Size.fromHeight(100.0), child: Padding(
            padding: const EdgeInsets.only(top:35.0),
            child: _getAppBar(_pdfViewerController,_color,_disabledColor,context,_textEditingController,_pdfViewerKey),
          )),
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



Widget _getAppBar(_pdfViewerController,_color,_disabledColor,context,_textEditingController,GlobalKey<SfPdfViewerState> pdfViewerKey){
  _textEditingController =
        TextEditingController(text: _pdfViewerController.pageNumber.toString());
  int _pageCount = _pdfViewerController.pageCount;
   final canJumpToPreviousPage = _pdfViewerController.pageNumber > 1;
    final canJumpToNextPage =
        _pdfViewerController.pageNumber < _pdfViewerController.pageCount;
  return Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                ToolbarItem(
                    height: 25,
                    width: 75,
                    child: Row(children: [
                      Flexible(
                        child: paginationTextField(context,_textEditingController,_color,_pdfViewerController),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            '/',
                            style: TextStyle(color: _color, fontSize: 16),
                          )),
                      Text(
                        _pageCount.toString(),
                        style: TextStyle(color: _color, fontSize: 16),
                      )
                    ])),
                Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: ToolbarItem(
                      height: 40,
                      width: 40,
                      child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_up,
                              color: canJumpToPreviousPage
                                  ? _color
                                  : _disabledColor,
                              size: 24,
                            ),
                            onPressed: canJumpToPreviousPage
                                ? () {
                                    _pdfViewerController?.previousPage();
                                  }
                                : null,
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: ToolbarItem(
                      height: 40,
                      width: 40,
                      child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color:
                                  canJumpToNextPage ? _color : _disabledColor,
                              size: 24,
                            ),
                            onPressed: canJumpToNextPage
                                ? () {
                                    _pdfViewerController?.nextPage();
                                  }
                                : null,
                          )),
                    ))
              ]),
              Row(children: <Widget>[
                ToolbarItem(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.bookmark,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed:() {
                               pdfViewerKey.currentState.openBookmarkView();
                              },
                      ),
                    )),
                ToolbarItem(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: _pdfViewerController.pageNumber == 0
                              ? Colors.black12
                              : _color,
                          size: 24,
                        ),
                        onPressed: _pdfViewerController.pageNumber == 0
                            ? null
                            : () {
                                _pdfViewerController.clearSelection();
                                
                              },
                      ),
                    ))
              ]),
            ],
          ));
}
// Toolbar item widget
class ToolbarItem extends StatelessWidget {
  ///Creates a toolbar item
  ToolbarItem({
    this.height,
    this.width,
    @required this.child,
  });

  /// Height of the toolbar item
  final double height;

  /// Width of the toolbar item
  final double width;

  /// Child widget of the toolbar item
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: child,
    );
  }
}
/// Pagination text field widget
  Widget paginationTextField(BuildContext context,_textEditingController,_color,pdfViewerController) {
    return TextField(
      style: TextStyle(color: _color),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      textAlign: TextAlign.center,
      maxLength: 3,
      maxLines: 1,
      decoration: InputDecoration(
        counterText: '',
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      enabled: pdfViewerController.pageCount == 0 ? false : true,
      onTap: pdfViewerController.pageCount == 0
          ? null
          : () {
              _textEditingController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _textEditingController.value.text.length);
            },
      onEditingComplete: () {
        final str = _textEditingController.text;
        if (str != pdfViewerController.pageNumber.toString()) {
          try {
            final int index = int.parse(str);
            if (index > 0 && index <= pdfViewerController.pageCount) {
              pdfViewerController?.jumpToPage(index);
              FocusScope.of(context).requestFocus(FocusNode());
            } else {
              _textEditingController.text =
                  pdfViewerController.pageNumber.toString();
              showErrorDialog(
                  context, 'Error', 'Please enter a valid page number.');
            }
          } catch (exception) {
            return showErrorDialog(
                context, 'Error', 'Please enter a valid page number.');
          }
        }
      },
    );
  }

    Widget showErrorDialog(BuildContext context, String s, String t) {
      return Container();
    }