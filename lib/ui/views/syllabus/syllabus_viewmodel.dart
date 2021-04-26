import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/syllabus_tile.dart/syllabus_tile_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
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

  List<Widget> _syllabusTiles = [];

  List<Widget> get syllabusTiles => _syllabusTiles;

  List<Syllabus> get syllabus => _syllabus;

  Future fetchSyllabus(String subjectName) async {
    setBusy(true);
    // var syllabusList =
    //     await _firestoreService.loadSyllabusFromFirebase(subjectName);
    // if (syllabusList is String) {
    //   await Fluttertoast.showToast(
    //       msg:
    //           "You are facing an error in loading the Syllabus. If you are facing this error more than once, please let us know by using the 'feedback' option in the app drawer.");
    //   setBusy(false);
    //   return;
    // } else {
    //   _syllabus = syllabusList;
    // }

    // for (int i = 0; i < syllabusList.length; i++) {
    //   Syllabus syllabus = syllabusList[i];
    //   if (syllabus.GDriveLink == null) {
    //     continue;
    //   }
    //   _syllabusTiles.add(_addInkWellWidget(syllabus));
    // }
    // notifyListeners();
    setBusy(false);
  }

  void openDoc(Syllabus syllabus) async {
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
          "",
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
        navigateToPDFScreen(response.responseData['buttonText'], syllabus);
        return;
      }
    } else {
      navigateToPDFScreen(response.responseData['buttonText'], syllabus);
    }
    return;
  }

  navigateToPDFScreen(String buttonText, Syllabus syllabus) {
    if (buttonText == 'Open In App') {
      navigateToWebView(syllabus);
    } else {
      _sharedPreferencesService.updateView(syllabus.id);
      Helper.launchURL(syllabus.GDriveLink);
    }
  }

  void navigateToWebView(Syllabus syllabus) {
    _navigationService.navigateTo(Routes.webViewWidget,
        arguments: WebViewWidgetArguments(syllabus: syllabus));
  }

  Widget _addInkWellWidget(
    Syllabus syllabus,
  ) {
    return InkWell(
        child: SyllabusTileView(
          syllabus: syllabus,
        ),
        onTap: () {
          openDoc(syllabus);
        });
  }
}
