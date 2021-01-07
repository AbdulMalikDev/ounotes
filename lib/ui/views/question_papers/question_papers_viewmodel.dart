import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';

class QuestionPapersViewModel extends BaseViewModel {
  Logger log = getLogger("QuestionPapersViewModel");
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<QuestionPaper> _questionPapers = [];
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<QuestionPaper> get questionPapers => _questionPapers;

  Future fetchQuestionPapers(String subjectName) async {
    setBusy(true);
    var result =
        await _firestoreService.loadQuestionPapersFromFirebase(subjectName);
    if (result is String) {
      _dialogService.showDialog(
          title: "Error",
          description: "Error in loading documents " + "$result");
      setBusy(false);
    } else {
      _questionPapers = result;
    }
    notifyListeners();
    setBusy(false);
  }


  void onTap(BuildContext context, QuestionPaper questionPaper) async {
    SharedPreferences prefs = await _sharedPreferencesService.store();

    if (prefs.containsKey("openDocChoice")) {
      String button = prefs.getString("openDocChoice");
      if (button == "Open In App") {
        navigateToWebView(questionPaper);
      } else {
        _sharedPreferencesService.updateView(questionPaper.id);
        Helper.launchURL(questionPaper.GDriveLink);
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
    if (!response?.confirmed ?? true) {
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
            response.responseData['buttonText'], questionPaper, context);
        return;
      }
    } else {
      navigateToPDFScreen(
          response.responseData['buttonText'], questionPaper, context);
    }
    return;
  }

  navigateToPDFScreen(String buttonText, QuestionPaper questionPaper, BuildContext context) {
    if (buttonText == 'Open In App') {
      navigateToWebView(questionPaper);
    } else {
      _sharedPreferencesService.updateView(questionPaper.id);
      Helper.launchURL(questionPaper.GDriveLink);
    }
  }

  void navigateToWebView(QuestionPaper questionPaper) {
    _navigationService.navigateTo(Routes.webViewWidgetRoute,
        arguments: WebViewWidgetArguments(questionPaper: questionPaper));
  }

}
