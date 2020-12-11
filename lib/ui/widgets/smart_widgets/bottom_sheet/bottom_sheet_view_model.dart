import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BottomSheetViewModel extends BaseViewModel{
  

  String errorText;
  
  response(var func,String responseText) {
    if(responseText.length < 5){
      errorText = "Please explain why you are reporting this document so that admins can take appropriate action";
      notifyListeners();
    }else if(responseText.length > 250){
      errorText = "Maximum limit of 250 characters exceeded";
      notifyListeners();
    }else{
      func(SheetResponse(confirmed: true,responseData: responseText));
    }
  }

}