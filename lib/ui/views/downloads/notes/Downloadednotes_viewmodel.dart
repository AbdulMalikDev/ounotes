import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownloadedNotesViewModel extends BaseViewModel {
  Logger log = getLogger("DownloadService");
  DownloadService _downloadService = locator<DownloadService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<Download> notes = [];
  List<Download> allDownloads = [];

  List<Download> get downloadedNotes => notes;

  fetchAndSetListOfNotesInDownloads() {
    setBusy(true);
    _downloadService.fetchAndSetDownloads();
    allDownloads = _downloadService.downloadlist;
    log.i(allDownloads);
    allDownloads.forEach((download) {
      if (download.type == Constants.notes) {
        notes.add(download);
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

  removeNoteFromDownloads(String path) {
    notes.removeWhere((note) => note.path == path);
    _downloadService.removeDownload(path);
    notifyListeners();
  }
}
