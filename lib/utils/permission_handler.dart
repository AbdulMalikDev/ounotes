import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class PermissionHandler {
  Future<bool> askPermission() async {
    DialogService _dialogService = locator<DialogService>();
    SharedPreferencesService _preferencesService =
        locator<SharedPreferencesService>();
    SharedPreferences prefs = await _preferencesService.store();
    if (prefs.containsKey("storage_permission_dialog_denied")) {
      return false;
    }

    var status = await Permission.storage.status;
    if (status.isUndetermined || status.isDenied) {
      // We didn't ask for permission yet.
      DialogResponse result = await _dialogService.showConfirmationDialog(
          title: "Permission",
          description:
              "The documents will be stored in your device so that you can access them offline. We require necessary permission to do so.",
          cancelTitle: "DO NOT SAVE",
          confirmationTitle: "OK SAVE THEM");
      prefs.setString("storage_permission_dialog_denied", "dialog_shown");
      if (!result.confirmed) {
        _dialogService.showDialog(
            title: "We're sorry to hear this",
            description:
                "You can always change this by going into the settings -> App Permissions -> enable storage permission to use OU Notes with its full potential.");
        return false;
      }
      PermissionStatus storagestatus = await Permission.storage.request();
      if (storagestatus == PermissionStatus.denied ||
          storagestatus == PermissionStatus.permanentlyDenied) {
        return false;
      }
      return true;
    }
    return false;
  }
}
