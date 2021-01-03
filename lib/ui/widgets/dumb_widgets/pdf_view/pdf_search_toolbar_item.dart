import 'package:flutter/material.dart';

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
