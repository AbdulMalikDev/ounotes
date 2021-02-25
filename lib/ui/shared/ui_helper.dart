import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIhelper {
  double width = 0.0;
  double height = 0.0;
  double safeAreaHorizontal = 0.0;
  double safeAreaVertical = 0.0;
  double screenHeightWithoutSafeArea = 0.0;
  double screenWidthWithoutSafeArea = 0.0;

  UIhelper();

  UIhelper.mediaQuery({BuildContext context}) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    safeAreaHorizontal = mediaQuery.padding.left + mediaQuery.padding.right;
    safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;
    screenHeightWithoutSafeArea = height - safeAreaVertical;
    screenWidthWithoutSafeArea = width - safeAreaHorizontal;
  }

  static BoxDecoration neumorphicEffect() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.grey.shade300,
      boxShadow: [
        BoxShadow(
            offset: Offset(10, 10), color: Colors.black38, blurRadius: 25),
        BoxShadow(
            offset: Offset(-10, -10),
            color: Colors.white.withOpacity(0.85),
            blurRadius: 25)
      ],
    );
  }
}
