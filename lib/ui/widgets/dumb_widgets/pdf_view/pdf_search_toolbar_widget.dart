import 'package:FSOUNotes/ui/widgets/dumb_widgets/pdf_view/pdf_search_toolbar_item.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/src/theme/pdfviewer_theme.dart';
typedef SearchTapCallback = void Function(Object item);
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
  bool showToast = false;
  int _totalTextValue = 0;

  /// An object that is used to control the Text Field.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used retrieve the text search result.
  PdfTextSearchResult pdfTextSearchResult = PdfTextSearchResult();

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
    pdfTextSearchResult.clear();
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
                pdfTextSearchResult?.nextInstance();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                pdfTextSearchResult?.clear();
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
                pdfTextSearchResult?.previousInstance();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                pdfTextSearchResult?.clear();
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
                  pdfTextSearchResult?.clear();
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
                  pdfTextSearchResult = await widget.controller
                      .searchText(_editingController.text);
                  if (pdfTextSearchResult.totalInstanceCount == 0) {
                    showToast = true;
                    await Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        showToast = false;
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
                      pdfTextSearchResult?.clear();
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
                    '${pdfTextSearchResult?.currentInstanceIndex}',
                    style: TextStyle(color: _color, fontSize: 16),
                  ),
                  Text(
                    ' of ',
                    style: TextStyle(color: _color, fontSize: 16),
                  ),
                  Text(
                    '${pdfTextSearchResult?.totalInstanceCount}',
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
                          if (pdfTextSearchResult?.totalInstanceCount != 0 &&
                              pdfTextSearchResult.currentInstanceIndex <= 1) {
                            _showAlertDialog(context);
                          } else {
                            pdfTextSearchResult?.previousInstance();
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
                          if (pdfTextSearchResult?.currentInstanceIndex ==
                                  pdfTextSearchResult?.totalInstanceCount &&
                              pdfTextSearchResult?.currentInstanceIndex != 0 &&
                              pdfTextSearchResult?.totalInstanceCount != 0) {
                            _showDialog(context);
                          } else {
                            widget.controller.clearSelection();
                            pdfTextSearchResult?.nextInstance();
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
