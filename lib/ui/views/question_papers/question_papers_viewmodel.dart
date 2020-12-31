import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  NavigationService _navigationService = locator<NavigationService>();
  DownloadService _downloadService = locator<DownloadService>();
  DialogService _dialogService = locator<DialogService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<Download> downloadedQp = [];
  bool isloading = false;
  bool get loading => isloading;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  List<QuestionPaper> get questionPapers => _questionPapers;

  Future fetchQuestionPapers(String subjectName) async {
    setBusy(true);
    await _downloadService.fetchAndSetDownloads();
    List<Download> allDownloads = _downloadService.downloadlist;
    allDownloads.forEach((download) {
      if (download.type == Constants.questionPapers) {
        downloadedQp.add(download);
      }
    });
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

  getListOfQpInDownloads(
    String subName,
  ) {
    List<Download> downloadsbysub = [];
    downloadedQp.forEach((download) {
      if (download.subjectName == subName) {
        downloadsbysub.add(download);
      }
    });
    return downloadsbysub;
  }

  String filePath;
  Future<bool> checkQPInDownloads(
      String year, String subname, String title) async {
    await _downloadService.fetchAndSetDownloads();
    List<Download> allDownloads = _downloadService.downloadlist;
    allDownloads.forEach((download) {
      if (download.type == Constants.questionPapers) {
        downloadedQp.add(download);
      }
    });
    for (int i = 0; i < downloadedQp.length; i++) {
      // log.e(downloadedQp[i].filename);
      // log.e(title);
      if (downloadedQp[i].year == year &&
          downloadedQp[i].subjectName == subname &&
          downloadedQp[i].filename == title) {
        filePath = downloadedQp[i].path;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void openDoc(BuildContext context, QuestionPaper questionPaper) async {
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

  void onTap({
    QuestionPaper note,
    String notesName,
    String subName,
    String type,
  }) async {
    checkQPInDownloads(note.year, subName, note.title).then((value) async {
      if (value) {
        // _navigationService.navigateTo(
        //   Routes.pdfScreenRoute,
        //   arguments: PDFScreenArguments(pathPDF: filePath, title: "Document"),
        // );
      } else {
        setLoading(true);

        String PDFpath = await _cloudStorageService.downloadFile(
          notesName: notesName,
          subName: subName,
          type: type,
          note: note,
        );
        if (PDFpath == 'error') {
          await Fluttertoast.showToast(
              msg:
                  'An error has occurred while downloading document...Please Verify your internet connection.');
          setLoading(false);
          return;
        }
        _downloadService.addDownload(
          id: note.id,
          year: note.year,
          filename: notesName,
          path: PDFpath,
          type: type,
          subjectName: subName,
          title: note.title,
        );

        setLoading(false);
        // _navigationService.navigateTo(Routes.pdfScreenRoute,
        //     arguments: PDFScreenArguments(pathPDF: PDFpath, title: notesName));
      }
    });
  }

  // @override
  // Future futureToRun() =>fetchNotes();

}
