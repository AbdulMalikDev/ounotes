import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class AppStateNotifier extends BaseViewModel {
 static bool isDarkModeOn = false;
  void updateTheme(bool isdarkmodeon){
    isDarkModeOn = isdarkmodeon;
    notifyListeners(); 
  }
}
