import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BottomSheetViewModel extends BaseViewModel {
  String errorText;

  bool _ischecked = false;
  bool _isNextPressed = false;

  double _value=1;

  double get value => _value;


  set setValue(double value) {
    _value = value;
    notifyListeners();
  }

  bool get isNextPressed => _isNextPressed;

  set setIsNextPressed(bool isNextPressed) {
    _isNextPressed = isNextPressed;
    notifyListeners();
  }

  SfRangeValues _sfValues;

  SfRangeValues get sfValues => _sfValues;

  set setSfValues(SfRangeValues values) {
    _sfValues = values;
    notifyListeners();
  }

  bool get ischecked => _ischecked;

  void changeCheckMark(bool val) {
    _ischecked = val;
    notifyListeners();
  }

  response(var func, String responseText) {
    if (responseText.length < 5) {
      errorText =
          "Please explain why you are reporting this document so that admins can take appropriate action";
      notifyListeners();
    } else if (responseText.length > 250) {
      errorText = "Maximum limit of 250 characters exceeded";
      notifyListeners();
    } else {
      func(
        SheetResponse(confirmed: true, responseData: responseText),
      );
    }
  }
}
