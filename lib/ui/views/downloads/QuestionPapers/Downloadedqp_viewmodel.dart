import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownloadedQPViewModel extends BaseViewModel {
  DownloadService _downloadService = locator<DownloadService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<Download> questionPapers = [];
  List<Download> allDownloads = [];

  List<Download> get downloadedQuestionPaper => questionPapers;

  fetchAndSetListOfQuestionPapersInDownloads() {
    setBusy(true);
     _downloadService.fetchAndSetDownloads();
    allDownloads = _downloadService.downloadlist;
    allDownloads.forEach((download) {
      if (download.type == Constants.questionPapers) {
        questionPapers.add(download);
      }
    });
    notifyListeners();
    setBusy(false);
  }

  void onTap({String PDFpath, String notesName}) {
    _navigationService.navigateTo(
      Routes.pdfScreenRoute,
      arguments: PDFScreenArguments(pathPDF: PDFpath, title: notesName),
    );
  }

  removeQpFromDownloads(String path) {
    questionPapers.removeWhere((note) => note.path == path);
    _downloadService.removeDownload(path);
    notifyListeners();
  }
}
