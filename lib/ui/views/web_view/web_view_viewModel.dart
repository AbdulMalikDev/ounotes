import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/app/app.locator.dart';
class WebViewModel extends BaseViewModel{
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  void showDownloadPreventDialog(web)async {
    await web.close();
    await _dialogService.showDialog(title: "WARNING" , description: "Notes cannot be downloaded.");
    _navigationService.popRepeated(1);
  }
}