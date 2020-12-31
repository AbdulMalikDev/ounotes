
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
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
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  NavigationService _navigationService = locator<NavigationService>();
  DownloadService _downloadService = locator<DownloadService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<Download> downloadedSyllabus = [];
  bool isloading = false;
  bool get loading => isloading;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  List<Syllabus> get syllabus => _syllabus;

  Future fetchSyllabus(String subjectName) async {
    setBusy(true);
    _syllabus = await _firestoreService.loadSyllabusFromFirebase(subjectName);
    await _downloadService.fetchAndSetDownloads();
    notifyListeners();
    setBusy(false);
  }

  String filePath;
  Future<bool> checkSyllabusInDownloads(Syllabus syllabus) async {
    await _downloadService.fetchAndSetDownloads();
    List<Download> allDownloads = _downloadService.downloadlist;
    for (int i = 0; i < allDownloads.length; i++) {
      var doc = allDownloads[i];
      log.e(doc.type);
      log.e(doc.filename);
      bool isDuplicate = (doc.type == syllabus.type) &&
          (doc.filename == syllabus.title) &&
          (doc.subjectName == syllabus.subjectName);
      if (isDuplicate) {
        filePath = doc.path;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  getListOfSyllabusInDownloads(String subName) {
    List<Download> allDownloads = _downloadService.downloadlist;
    List<Download> downloadsbysub = [];
    allDownloads.forEach((download) {
      if (download.type == Constants.syllabus &&
          download.subjectName == subName) {
        downloadsbysub.add(download);
      }
    });
    return downloadsbysub;
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

  void onTap({Syllabus doc}) async {
    bool value = await checkSyllabusInDownloads(doc);
    log.i("Document present in downloads? : $value");
    log.i("Type : ${doc.type}");
    log.i("Title : ${doc.title}");

    if (value) {
      // _navigationService.navigateTo(Routes.pdfScreenRoute,
      //     arguments: PDFScreenArguments(pathPDF: filePath, title: "Document"));
    } else {
      setLoading(true);
      String PDFpath = await _cloudStorageService.downloadFile(
        notesName: doc.title,
        subName: doc.subjectName,
        type: doc.type,
        note: doc,
      );
      if (PDFpath == 'error') {
        await Fluttertoast.showToast(
            msg:
                'An error has occurred while downloading document...Please Verify your internet connection.');
        setLoading(false);
        return;
      }
      _downloadService.addDownload(
        id: doc.id,
        filename: doc.title,
        subjectName: doc.subjectName,
        path: PDFpath,
        sem: doc.semester,
        branch: doc.branch,
        type: doc.type,
        title: doc.title,
      );
      setLoading(false);
      // _navigationService.navigateTo(Routes.pdfScreenRoute,
      //     arguments: PDFScreenArguments(pathPDF: PDFpath, title: "Document"));
    }
    // });
  }

  // @override
  // Future futureToRun() =>fetchNotes();

}
