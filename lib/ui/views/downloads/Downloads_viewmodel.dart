import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/services/funtional_services/db_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class DownLoadViewModel extends BaseViewModel {
  Logger log = getLogger("downloads");
  String table = 'downloaded_subjects';
  DownloadService _downloadService = locator<DownloadService>();
  List<Download> downloads;
  List<Download> get downloadList => downloads;

  fetchListOfDownloads() async{
    setBusy(true);
    await _downloadService.fetchAndSetDownloads();
    downloads=_downloadService.downloadlist;
    notifyListeners();
    setBusy(false);
  }
}
