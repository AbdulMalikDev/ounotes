import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DownLoadViewModel extends BaseViewModel {
  Logger log = getLogger("downloads");
  String table = 'downloaded_subjects';
  DownloadService _downloadService = locator<DownloadService>();
  NavigationService _navigationService = locator<NavigationService>();
  deleteDownload(
    int index,
    String path,
  ) {
    _downloadService.removeDownload(index, path);
  }

  navigateToPDFScreen(Download download) {
    Note note = Note(
      subjectName: download.subjectName,
      title: download.title,
      type: "",
      path: Document.Notes,
      id: download.id,
      size: download.size,
      author: download.author,
      view: download.view,
    );
    _navigationService.navigateTo(Routes.pdfScreenRoute,
        arguments: PDFScreenArguments(
            pathPDF: download.path, doc: note, askBookMarks: false));
  }
}
