
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';


import 'package:stacked_services/stacked_services.dart';

class SyllabusViewModel extends BaseViewModel {
  Logger log = getLogger("SyllabusViewModel");
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Syllabus> _syllabus = [];
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<Syllabus> get syllabus => _syllabus;

  Future fetchSyllabus(String subjectName) async {
    setBusy(true);
    _syllabus = await _firestoreService.loadSyllabusFromFirebase(subjectName);
    notifyListeners();
    setBusy(false);
  }
    void openDoc(BuildContext context, Syllabus syllabus) async {
    SharedPreferences prefs = await _sharedPreferencesService.store();

    if (prefs.containsKey("openDocChoice")) {
      String button = prefs.getString("openDocChoice");
      if (button == "Open In App") {
        navigateToWebView(syllabus);
      } else {
        _sharedPreferencesService.updateView(syllabus.id);
        Helper.launchURL(syllabus.GDriveLink);
      }
      return;
    }

    SheetResponse response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.floating2,
      title: 'Where do you want to open the file?',
       description:
          "Tip : Open Notes in Google Drive app to avoid loading issues. ' Open in Browser > Google Drive Icon ' ",
      mainButtonTitle: 'Open In Browser',
      secondaryButtonTitle: 'Open In App',
    );
    log.i("openDoc BottomSheetResponse ");
    if (!response.confirmed) {
      return;
    }

    if (response.responseData['checkBox']) {
      prefs.setString(
        "openDocChoice",
        response.responseData['buttonText'],
      );

      SheetResponse response2 = await _bottomSheetService.showBottomSheet(
        title: "Settings Saved !",
        description:
            "You can change this setting in the profile screen anytime.",
      );
      if (response2.confirmed) {
        navigateToPDFScreen(
            response.responseData['buttonText'], syllabus, context);
        return;
      }
    } else {
      navigateToPDFScreen(
          response.responseData['buttonText'], syllabus, context);
    }
    return;
  }

  navigateToPDFScreen(String buttonText, Syllabus syllabus, BuildContext context) {
    if (buttonText == 'Open In App') {
      navigateToWebView(syllabus);
    } else {
      _sharedPreferencesService.updateView(syllabus.id);
      Helper.launchURL(syllabus.GDriveLink);
    }
  }
  
  void navigateToWebView(Syllabus syllabus) {
    _navigationService.navigateTo(Routes.webViewWidgetRoute,
        arguments: WebViewWidgetArguments(syllabus: syllabus));
  }

}
