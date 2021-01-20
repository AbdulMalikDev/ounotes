
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/pdf_view/pdf_error_dialog.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/pdf_view/pdf_toolbar_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/src/theme/pdfviewer_theme.dart';

/// Signature for [Toolbar.onTap] callback.
typedef TapCallback = void Function(Object item);

/// Toolbar widget
class Toolbar extends StatefulWidget {
  ///it describe top toolbar constructor
  Toolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    this.doc,
    Key key,
  }) : super(key: key);

  /// Indicates whether tooltip for the toolbar items need to be shown or not..
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController controller;

  /// Called when the toolbar item is selected.
  final TapCallback onTap;

  ///Abstract Document
  final AbstractDocument doc;

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
              Row(children: <Widget>[
                ToolbarItem(
                    height: 25,
                    width: 75,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, bottom: 1),
                          child: FittedBox(
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
                          final RenderBox box = context.findRenderObject();
                          Share.share(
                              "Notes Name: ${widget.doc.title}\n\nSubject Name: ${widget.doc.subjectName}\n\nLink:${widget.doc.GDriveLink}\n\nFind Latest Notes | Question Papers | Syllabus | Resources for Osmania University at the OU NOTES App\n\nhttps://play.google.com/store/apps/details?id=com.notes.ounotes",
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size
                          );
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
