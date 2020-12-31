import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownloadedSyllabusViewModel extends BaseViewModel {
  DownloadService _downloadService = locator<DownloadService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<Download> syllabus = [];
  List<Download> allDownloads = [];

  List<Download> get downloadedSyllabus => syllabus;

  fetchAndSetListOfSyllabusInDownloads() {
    setBusy(true);
    _downloadService.fetchAndSetDownloads();
    allDownloads = _downloadService.downloadlist;
    allDownloads.forEach((download) {
      if (download.type == Constants.syllabus) {
        syllabus.add(download);
      }
    });
    notifyListeners();
    setBusy(false);
  }

  void onTap({String PDFpath, String notesName}) {
    // _navigationService.navigateTo(
    //   Routes.pdfScreenRoute,
    //   arguments: PDFScreenArguments(pathPDF: PDFpath, title: notesName),
    // );
  }

  removeSyllabusFromDownloads(String path) {
    syllabus.removeWhere((note) => note.path == path);
    _downloadService.removeDownload(path);
    notifyListeners();
  }
}
