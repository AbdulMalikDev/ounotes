import 'dart:io';

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/ui/views/pdf/Add_bookmarks/add_bookMarks_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

/// PDF Viewer import
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Core theme import
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:FSOUNotes/models/document.dart';

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
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  bool _showPdf;
  bool _showToolbar;
  bool _showToast;
  bool _showScrollHead;
  OverlayEntry _overlayEntry;
  Color _contextMenuColor;
  Color _copyColor;
  double _contextMenuWidth;
  double _contextMenuHeight;
  bool _askBookMarks;

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
    _askBookMarks = widget.askBookMarks;

    if (widget.askBookMarks) {
      showBottomSeetForBookMarks(true);
    }
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

  /// Show Context menu for Text Selection.
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
                if (_textSearchKey.currentState?._pdfTextSearchResult != null &&
                    _textSearchKey
                        .currentState._pdfTextSearchResult.hasResult) {
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

  @override
  Widget build(BuildContext context) {
    //* The app bar is a bit annoying when in landscape
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      //Book marks
      floatingActionButton: widget.askBookMarks
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  showBottomSeetForBookMarks(false);
                },
                backgroundColor: Theme.of(context).accentColor,
              ),
            )
          : null,
      appBar: isLandscape
          ? null
          : AppBar(
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
                  SfPdfViewer.asset(
                    widget.pathPDF,
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
                    visible: _textSearchKey?.currentState?._showToast ?? false,
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

  // @override
  // void initState() {
  //   // _pdfViewerController = PdfViewerController();
  //   // if (widget.doc?.title != null)title = widget.doc?.title;
  //   super.initState();
  // }
}

/// Represents PDF document.
class Documentf {
  /// Constructs Document instance.
  Documentf(this.name, this.path);

  /// Name of the PDF document.
  final String name;

  /// Path of the PDF document.
  final String path;
}

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

// class Toolbar extends StatefulWidget {
//   Toolbar({
//     this.controller,
//     this.onTap,
//     this.showTooltip = true,
//     Key key,
//   }) : super(key: key);

//   /// Indicates whether tooltip for the toolbar items need to be shown or not..
//   final bool showTooltip;

//   /// An object that is used to control the [SfPdfViewer].
//   final PdfViewerController controller;

//   /// Called when the toolbar item is selected.
//   final TapCallback onTap;

//   @override
//   _ToolbarState createState() => _ToolbarState();
// }

// class _ToolbarState extends State<Toolbar> {
//   SfPdfViewerThemeData _pdfViewerThemeData;
//   Color _color;
//   Color _disabledColor;
//   int _pageCount;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

/// Toolbar widget
class Toolbar extends StatefulWidget {
  ///it describe top toolbar constructor
  Toolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    Key key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController controller;

  /// Called when the toolbar item is selected.
  final TapCallback onTap;

  @override
  ToolbarState createState() => ToolbarState();
}

/// State for the Toolbar widget
class ToolbarState extends State<Toolbar> {
  SfPdfViewerThemeData _pdfViewerThemeData;
  Color _color;
  Color _disabledColor;
  int _pageCount;

  /// An object that is used to control the Text Field.
  TextEditingController _textEditingController;

  @override
  void initState() {
    widget.controller?.addListener(_pageChanged);
    _textEditingController =
        TextEditingController(text: widget.controller.pageNumber.toString());
    _pageCount = widget.controller.pageCount;
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_pageChanged);
    super.dispose();
  }

  /// Called when the page changes and updates the page number text field.
  void _pageChanged({String property}) {
    if (widget.controller?.pageCount != null &&
        _pageCount != widget.controller.pageCount) {
      _pageCount = widget.controller.pageCount;
      setState(() {});
    }
    if (widget.controller?.pageNumber != null &&
        _textEditingController.text !=
            widget.controller.pageNumber.toString()) {
      _textEditingController.text = widget.controller.pageNumber.toString();
      print(widget.controller.pageNumber.toString());
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _color = _pdfViewerThemeData.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    _disabledColor = _pdfViewerThemeData.brightness == Brightness.light
        ? Colors.black12
        : Colors.white12;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final canJumpToPreviousPage = widget.controller.pageNumber > 1;
    final canJumpToNextPage =
        widget.controller.pageNumber < widget.controller.pageCount;
    return GestureDetector(
      onTap: () {
        widget.onTap?.call('Toolbar');
      },
      child: Container(
          margin: EdgeInsets.only(top: 35),
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // ToolbarItem(
              //   height: 40,
              //   width: 40,
              //   child: Material(
              //       color: Colors.transparent,
              //       child: IconButton(
              //         icon: Icon(
              //           Icons.folder_open,
              //           color: _color,
              //           size: 24,
              //         ),
              //         onPressed: () async {
              //           // widget.onTap?.call('File Explorer');
              //           // widget.controller.clearSelection();
              //           // await Future.delayed(Duration(milliseconds: 50));
              //           // Navigator.of(context).push(MaterialPageRoute(
              //           //     builder: (context) => FileExplorer(
              //           //           brightness: _pdfViewerThemeData.brightness,
              //           //           onDocumentTap: (document) {
              //           //             widget.onTap?.call(document);
              //           //             Navigator.of(context, rootNavigator: true)
              //           //                 .pop(context);
              //           //           },
              //           //         )));
              //         },
              //         tooltip: widget.showTooltip ? 'Choose file' : null,
              //       )),
              // ),
              Row(children: <Widget>[
                ToolbarItem(
                    height: 25,
                    width: 75,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, bottom: 1),
                          child: Flexible(
                            child: paginationTextField(context),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Text(
                              '/',
                              style: TextStyle(color: _color, fontSize: 16),
                            )),
                        Text(
                          _pageCount.toString(),
                          style: TextStyle(color: _color, fontSize: 16),
                        )
                      ]),
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
                              Icons.keyboard_arrow_up,
                              color: canJumpToPreviousPage
                                  ? _color
                                  : _disabledColor,
                              size: 24,
                            ),
                            onPressed: canJumpToPreviousPage
                                ? () {
                                    widget.onTap?.call('Previous page');
                                    widget.controller?.previousPage();
                                  }
                                : null,
                            tooltip:
                                widget.showTooltip ? 'Previous page' : null,
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
                                    widget.onTap?.call('Next page');
                                    widget.controller?.nextPage();
                                  }
                                : null,
                            tooltip: widget.showTooltip ? 'Next page' : null,
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
                          color: widget.controller.pageNumber == 0
                              ? Colors.black12
                              : _color,
                          size: 24,
                        ),
                        onPressed: widget.controller.pageNumber == 0
                            ? null
                            : () {
                                _textEditingController.selection =
                                    TextSelection(
                                        baseOffset: -1, extentOffset: -1);
                                widget.onTap?.call('Bookmarks');
                              },
                        tooltip: widget.showTooltip ? 'Bookmarks' : null,
                      ),
                    )),
                ToolbarItem(
                    height: 40,
                    width: 40,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.share,
                          color: widget.controller.pageNumber == 0
                              ? Colors.black12
                              : _color,
                          size: 24,
                        ),
                        onPressed: () {
                          //TODO MALIK include share logic
                        },
                        tooltip: widget.showTooltip ? 'Search' : null,
                      ),
                    ))
              ]),
            ],
          )),
    );
  }

  /// Pagination text field widget
  Widget paginationTextField(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 20),
      child: IntrinsicWidth(
        child: TextField(
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
          enabled: widget.controller.pageCount == 0 ? false : true,
          onTap: widget.controller.pageCount == 0
              ? null
              : () {
                  _textEditingController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _textEditingController.value.text.length);
                  widget.onTap?.call('Jump to the page');
                },
          onEditingComplete: () {
            final str = _textEditingController.text;
            if (str != widget.controller.pageNumber.toString()) {
              try {
                final int index = int.parse(str);
                if (index > 0 && index <= widget.controller.pageCount) {
                  widget.controller?.jumpToPage(index);
                  FocusScope.of(context).requestFocus(FocusNode());
                  widget.onTap?.call('Navigated');
                } else {
                  _textEditingController.text =
                      widget.controller.pageNumber.toString();
                  showErrorDialog(
                      context, 'Error', 'Please enter a valid page number.');
                }
              } catch (exception) {
                return showErrorDialog(
                    context, 'Error', 'Please enter a valid page number.');
              }
            }
            widget.onTap?.call('Navigated');
          },
        ),
      ),
    );
  }
}

/// Signature for [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// Toolbar item widget
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

/// Displays the error message
void showErrorDialog(BuildContext context, String error, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(error),
        content: Text(description),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      );
    },
  );
}

/// SearchToolbar widget
class SearchToolbar extends StatefulWidget {
  ///it describe search toolbar constructor
  SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    Key key,
  }) : super(key: key);

  /// Indicates whether tooltip for the search toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback onTap;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  SfPdfViewerThemeData _pdfViewerThemeData;
  Color _color;
  bool _showItem = false;
  bool _showToast = false;
  int _totalTextValue = 0;

  /// An object that is used to control the Text Field.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  /// Define the focus node. To manage the lifecycle, create the FocusNode in
  /// the initState method, and clean it up in the dispose method.
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode?.dispose();
    super.dispose();
  }

  ///clear the text search result
  void clearSearch() {
    _pdfTextSearchResult.clear();
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _color = _pdfViewerThemeData.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.65);
    super.didChangeDependencies();
  }

  ///Display the Alert Dialog to search from the beginning
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Result'),
          content: Text(
              'No more occurrences found. Would you like to continue to search from the beginning?'),
          actions: <Widget>[
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                _pdfTextSearchResult?.nextInstance();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                _pdfTextSearchResult?.clear();
                _editingController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///Display the Alert Dialog to search from the ending
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Result'),
          content: Text(
              'No more occurrences found. Would you like to continue to search from the ending?'),
          actions: <Widget>[
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                _pdfTextSearchResult?.previousInstance();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                _pdfTextSearchResult?.clear();
                _editingController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SearchToolbarItem(
            height: 40,
            width: 40,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: _color,
                  size: 24,
                ),
                onPressed: () {
                  widget.onTap?.call('Cancel Search');
                  _editingController.clear();
                  _pdfTextSearchResult?.clear();
                },
              ),
            ),
          ),
          SearchToolbarItem(
            child: Flexible(
              child: TextFormField(
                style: TextStyle(color: _color),
                enableInteractiveSelection: false,
                autofocus: true,
                focusNode: myFocusNode,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                controller: _editingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Find...',
                ),
                onChanged: (text) {
                  if (_totalTextValue < _editingController.value.text.length) {
                    _totalTextValue = _editingController.value.text.length;
                  }
                  if (_editingController.value.text.length < _totalTextValue) {
                    setState(() {
                      _showItem = false;
                    });
                  }
                },
                onFieldSubmitted: (String value) async {
                  _pdfTextSearchResult = await widget.controller
                      .searchText(_editingController.text);
                  if (_pdfTextSearchResult.totalInstanceCount == 0) {
                    _showToast = true;
                    await Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        _showToast = false;
                      });
                    });
                  } else {
                    _showItem = true;
                  }
                },
              ),
            ),
          ),
          SearchToolbarItem(
            child: Visibility(
              visible: _editingController.text.isNotEmpty,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: _color,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _editingController.clear();
                      _pdfTextSearchResult?.clear();
                      widget.controller.clearSelection();
                      _showItem = false;
                      myFocusNode.requestFocus();
                    });
                    widget.onTap?.call('Clear Text');
                  },
                  tooltip: widget.showTooltip ? 'Clear Text' : null,
                ),
              ),
            ),
          ),
          SearchToolbarItem(
            child: Visibility(
              visible: _showItem,
              child: Row(
                children: [
                  Text(
                    '${_pdfTextSearchResult?.currentInstanceIndex}',
                    style: TextStyle(color: _color, fontSize: 16),
                  ),
                  Text(
                    ' of ',
                    style: TextStyle(color: _color, fontSize: 16),
                  ),
                  Text(
                    '${_pdfTextSearchResult?.totalInstanceCount}',
                    style: TextStyle(color: _color, fontSize: 16),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.navigate_before,
                        color: _color,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_pdfTextSearchResult?.totalInstanceCount != 0 &&
                              _pdfTextSearchResult.currentInstanceIndex <= 1) {
                            _showAlertDialog(context);
                          } else {
                            _pdfTextSearchResult?.previousInstance();
                          }
                        });
                        widget.onTap?.call('Previous Instance');
                      },
                      tooltip: widget.showTooltip ? 'Previous' : null,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        color: _color,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_pdfTextSearchResult?.currentInstanceIndex ==
                                  _pdfTextSearchResult?.totalInstanceCount &&
                              _pdfTextSearchResult?.currentInstanceIndex != 0 &&
                              _pdfTextSearchResult?.totalInstanceCount != 0) {
                            _showDialog(context);
                          } else {
                            widget.controller.clearSelection();
                            _pdfTextSearchResult?.nextInstance();
                          }
                        });
                        widget.onTap?.call('Next Instance');
                      },
                      tooltip: widget.showTooltip ? 'Next' : null,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// SearchToolbar item widget
class SearchToolbarItem extends StatelessWidget {
  ///Creates a search toolbar item
  SearchToolbarItem({
    this.height,
    this.width,
    @required this.child,
  });

  /// Height of the search toolbar item
  final double height;

  /// Width of the search toolbar item
  final double width;

  /// Child widget of the search toolbar item
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
