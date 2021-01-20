import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class DownloadService {
  Logger log = getLogger("DownloadService");
  String table = 'downloaded_subjects';
  User user;
  List<Download> _downloads = [];

  List<Download> get downloadlist => _downloads;

  addDownload({Download download}) async {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    this.user = await _authenticationService.getUser();
    Box downloadBox = Hive.box('downloads');
    downloadBox.add(download);
    // if (downloadBox.length > 3 && !user.isPremiumUser) {
    //   //if downloads list length is > 3 and he is not a premium user then delete the oldest download which is at index 0
    //   downloadBox.deleteAt(0);
    // }
  }

  void removeDownload(int index, String path) {
    CloudStorageService _cloudStorageService = locator<CloudStorageService>();
    _cloudStorageService.deleteContent(path);
    Box downloadBox = Hive.box('downloads');
    downloadBox.deleteAt(index);
  }
}
