import 'package:flutter/material.dart';

class App {
  BuildContext _context;
  double _width;
  double _height;
  double _safeAreaHorizontal;
  double _safeAreaVertical;
  double _screenHeightWithoutSafeArea;
  double _screenWidthWithoutSafeArea;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _width = _queryData.size.width;
    _height = _queryData.size.height;
    _safeAreaHorizontal = _queryData.padding.left + _queryData.padding.right;
    _safeAreaVertical = _queryData.padding.top + _queryData.padding.bottom;
    _screenHeightWithoutSafeArea = _height - _safeAreaVertical;
    _screenWidthWithoutSafeArea = _width - _safeAreaHorizontal;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appSafeAreaHorizontal(double v) {
    return _safeAreaHorizontal * v;
  }
   double appSafeAreaVertical(double v) {
    return _safeAreaVertical * v;
  }
  
   double appScreenHeightWithOutSafeArea(double v){
     return _screenHeightWithoutSafeArea*v;
   }
    
    double appScreenWidthWithOutSafeArea(double v){
     return _screenWidthWithoutSafeArea*v;
   } 
}

