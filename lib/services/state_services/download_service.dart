import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class DownloadService {
  Logger log = getLogger("DownloadService");
  User user;
  List<Download> _downloads = [];

  List<Download> get downloadlist => _downloads;

  addDownload({@required Download download}) async {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    this.user = await _authenticationService.getUser();
    if (!Hive.isBoxOpen(download.boxName)) {
      await Hive.openBox<Download>(download.boxName);
    }
    Box<Download> downloadBox = Hive.box(download.boxName);
    downloadBox.add(download);
    // if (downloadBox.length > 3 && !user.isPremiumUser) {
    //   //if downloads list length is > 3 and he is not a premium user then delete the oldest download which is at index 0
    //   downloadBox.deleteAt(0);
    // }
  }

  void removeDownload(int index, String path, String downloadBoxName) async {
    CloudStorageService _cloudStorageService = locator<CloudStorageService>();
    await _cloudStorageService.deleteContent(path);
    Box<Download> downloadBox = Hive.box(downloadBoxName);
    downloadBox.deleteAt(index);
  }
}
