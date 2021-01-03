import 'package:flutter/material.dart';
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
