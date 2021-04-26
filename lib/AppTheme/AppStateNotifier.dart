import 'package:stacked/stacked.dart';

class AppStateNotifier extends BaseViewModel {
 static bool isDarkModeOn = false;
  void updateTheme(bool isdarkmodeon){
    isDarkModeOn = isdarkmodeon;
    notifyListeners(); 
  }
}
