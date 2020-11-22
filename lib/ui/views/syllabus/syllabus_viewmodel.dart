import 'dart:math';

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
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/misc/helper.dart';


import 'package:stacked_services/stacked_services.dart';

class SyllabusViewModel extends BaseViewModel {
  Logger log = getLogger("SyllabusViewModel");
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Syllabus> _syllabus = [];
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  NavigationService _navigationService = locator<NavigationService>();
  DownloadService _downloadService = locator<DownloadService>();
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

  void openDoc(BuildContext context, Syllabus syllabus) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Where do you want to open the file?",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        child: Text(
                          "Open in App",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          navigateToWebView(syllabus);
                        }),
                    FlatButton(
                        child: Text(
                          "Open In Browser",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 15),
                        ),
                        onPressed: () {
                          Helper.launchURL(syllabus.GDriveLink);
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ]);
        });
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
      _navigationService.navigateTo(Routes.pdfScreenRoute,
          arguments: PDFScreenArguments(pathPDF: filePath, title: "Document"));
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
      _navigationService.navigateTo(Routes.pdfScreenRoute,
          arguments: PDFScreenArguments(pathPDF: PDFpath, title: "Document"));
    }
    // });
  }

  // @override
  // Future futureToRun() =>fetchNotes();

}
