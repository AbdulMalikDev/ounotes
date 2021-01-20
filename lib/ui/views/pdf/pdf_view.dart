
import 'dart:io';

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/pdf_view/pdf_error_dialog.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/pdf_view/pdf_search_toolbar_widget.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/pdf_view/pdf_toolbar_widget.dart';
import 'package:FSOUNotes/ui/views/pdf/Add_bookmarks/add_bookMarks_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:FSOUNotes/models/document.dart';

part "./pdf_functions.dart";

Logger log = getLogger("PDFScreen");

class PDFScreen extends StatefulWidget {
  final String pathPDF;
  final AbstractDocument doc;
  final bool askBookMarks;
  PDFScreen({this.pathPDF, this.doc, @required this.askBookMarks});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String _documentPath;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  bool _showPdf;
  bool _showToolbar;
  bool _showToast;
  bool _showScrollHead;
  OverlayEntry _overlayEntry;
  Color _contextMenuColor;
  Color _copyColor;
  double _contextMenuWidth;
  double _contextMenuHeight;

  @override
  Widget build(BuildContext context) {
    //* The app bar is a bit annoying when in landscape
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      //Book marks
      
      floatingActionButton: 
          widget.askBookMarks && (widget.doc.path == Document.Notes)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: const Icon(Icons.bookmark),
                onPressed: () async {
                  if(widget.doc.type == Constants.notes)
                  showBottomSeetForBookMarks(false);
                },
                backgroundColor: Theme.of(context).accentColor,
              ),
            )
          : null,
      appBar: isLandscape
          ? null
          : AppBar(
            toolbarHeight: MediaQuery.of(context).size.height * 0.070,
              flexibleSpace: Toolbar(
                  showTooltip: true,
                  controller: _pdfViewerController,
                  onTap: (Object toolbarItem) {
                    if (toolbarItem.toString() != 'Bookmarks') {
                      _checkAndCloseContextMenu();
                      _pdfViewerController.clearSelection();
                    }
                    if (_pdfViewerKey.currentState.isBookmarkViewOpen) {
                      Navigator.pop(context);
                    }
                    if (toolbarItem != 'Jump to the page') {
                      final currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.requestFocus(FocusNode());
                      }
                    }
                    if (toolbarItem is Documentf) {
                      setState(() {
                        _documentPath = toolbarItem.path;
                      });
                    }
                    if (toolbarItem.toString() == 'Bookmarks') {
                      setState(() {
                        _showToolbar = false;
                      });
                      _pdfViewerKey.currentState?.openBookmarkView();
                    } else if (toolbarItem.toString() == 'Search') {
                      setState(() {
                        _showToolbar = false;
                        _showScrollHead = false;
                        _ensureHistoryEntry();
                      });
                    }
                  },
                ),
              automaticallyImplyLeading: false,
              backgroundColor:
                  SfPdfViewerTheme.of(context).bookmarkViewStyle.headerBarColor,
            ),
      body: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 200)).then((value) {
          _showPdf = true;
        }),
        builder: (context, snapshot) {
          if (_showPdf) {
            return SfPdfViewerTheme(
              data: SfPdfViewerThemeData(),
              child: WillPopScope(
                onWillPop: () async {
                  setState(() {
                    _showToolbar = true;
                  });
                  return true;
                },
                child: Stack(children: [
                  SfPdfViewer.file(
                    File(widget.pathPDF.trim()),
                    enableTextSelection: false,
                    key: _pdfViewerKey,
                    controller: _pdfViewerController,
                    onTextSelectionChanged:
                        (PdfTextSelectionChangedDetails details) async {
                      if (details.selectedText == null &&
                          _overlayEntry != null) {
                        _checkAndCloseContextMenu();
                      } else if (details.selectedText != null &&
                          _overlayEntry == null) {
                        _showContextMenu(context, details);
                      }
                    },
                    onDocumentLoadFailed:
                        (PdfDocumentLoadFailedDetails details) {
                      showErrorDialog(
                          context, details.error, details.description);
                    },
                    canShowScrollHead: _showScrollHead,
                  ),
                  Visibility(
                    visible: _textSearchKey?.currentState?.showToast ?? false,
                    child: Align(
                      alignment: Alignment.center,
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, top: 7, right: 15, bottom: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'No result',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _showToast,
                    child: Positioned.fill(
                      bottom: 25.0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 16, top: 6, right: 16, bottom: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Text(
                                'Copied',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          } else {
            return Container(
              color: SfPdfViewerTheme.of(context).backgroundColor,
            );
          }
        },
      ),
    );
  }
  
  @override
  void initState() {
    super.initState();
    _documentPath = 'assets/pdf/gis_succinctly.pdf';
    _showPdf = false;
    _showToolbar = true;
    _showToast = false;
    _showScrollHead = true;
    _contextMenuHeight = 48;
    _contextMenuWidth = 100;
    log.e(widget.pathPDF);
    // Schedularb
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.askBookMarks && widget.doc.type == Constants.notes) {
        showBottomSeetForBookMarks(true);
      }
    });
  }

  showBottomSeetForBookMarks(bool initial) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => BookMarkBottomSheet(
        note: widget.doc,
        isInitial: initial,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    /// Used figma colors for context menu color and copy text color.
    _contextMenuColor = Color(0xFFFFFFFF);
    _copyColor = Color(0xFF000000);
    super.didChangeDependencies();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final RenderBox renderBoxContainer =
        context.findRenderObject() as RenderBox;
    final Offset containerOffset = renderBoxContainer.localToGlobal(
      renderBoxContainer.paintBounds.topLeft,
    );
    if (containerOffset.dy < details.globalSelectedRegion.topLeft.dy - 55 ||
        (containerOffset.dy <
                details.globalSelectedRegion.center.dy -
                    (_contextMenuHeight / 2) &&
            details.globalSelectedRegion.height > _contextMenuWidth)) {
      double top = details.globalSelectedRegion.height > _contextMenuWidth
          ? details.globalSelectedRegion.center.dy - (_contextMenuHeight / 2)
          : details.globalSelectedRegion.topLeft.dy - 55;
      double left = details.globalSelectedRegion.height > _contextMenuWidth
          ? details.globalSelectedRegion.center.dx - (_contextMenuWidth / 2)
          : details.globalSelectedRegion.bottomLeft.dx;
      if ((details.globalSelectedRegion.top) >
          MediaQuery.of(context).size.height / 2) {
        top = details.globalSelectedRegion.topLeft.dy - 55;
        left = details.globalSelectedRegion.bottomLeft.dx;
      }
      final OverlayState _overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: top,
          left: left,
          child: Container(
            decoration: BoxDecoration(
              color: _contextMenuColor,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.14),
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.12),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            constraints: BoxConstraints.tightFor(
                width: _contextMenuWidth, height: _contextMenuHeight),
            child: FlatButton(
              child: Text(
                'Copy',
                style: TextStyle(fontSize: 17, color: _copyColor),
              ),
              onPressed: () async {
                _checkAndCloseContextMenu();
                _pdfViewerController.clearSelection();
                if (_textSearchKey.currentState?.pdfTextSearchResult != null &&
                    _textSearchKey
                        .currentState.pdfTextSearchResult.hasResult) {
                  setState(() {
                    _showToolbar = false;
                  });
                }
                await Clipboard.setData(
                    ClipboardData(text: details.selectedText));
                setState(() {
                  _showToast = true;
                });
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  _showToast = false;
                });
              },
            ),
          ),
        ),
      );
      _overlayState.insert(_overlayEntry);
    }
  }

  /// Ensure the entry history of Text search.
  LocalHistoryEntry _historyEntry;
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic> route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry);
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    _textSearchKey?.currentState?.clearSearch();
    _historyEntry = null;
  }

  void _checkAndCloseContextMenu() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

}

