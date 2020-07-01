import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class DownloadService {
  Logger log = getLogger("DownloadService");
  String table = 'downloaded_subjects';

  List<Download> _downloads = [];

  List<Download> get downloadlist => _downloads;

  addDownload({
    String id,
    String filename,
    String path,
    String subjectName,
    String branch,
    String sem,
    String year,
    String type,
    @required title,
  }) async {
    DBService _dbservie = locator<DBService>();
    _dbservie.insert(table, {
      'id': id,
      'path': path,
      'filename': filename,
      'subjectname': subjectName,
      'branch': branch ?? '',
      'sem': sem ?? '',
      'year': year ?? '',
      'type': type,
      'title': title ?? (sem ?? "" + branch ?? ""),
    });
  }

  Future<List<Download>> fetchAndSetDownloads() async {
    DBService _dbservie = locator<DBService>();
    final dataList = await _dbservie.getData(table);
    print(dataList);
    _downloads = dataList
        .map((item) => Download(
              id: item['id'],
              path: item['path'],
              filename: item['filename'],
              subjectName: item['subjectname'],
              sem: item['sem'],
              branch: item['branch'],
              year: item['year'],
              type: item['type'],
              title : item['title'],
            ))
        .toList();
    return _downloads;
  }

  void removeDownload(String path) {
    DBService _dbservie = locator<DBService>();
    CloudStorageService _cloudStorageService = locator<CloudStorageService>();
    _dbservie.deleteDownload(table, path);
    _cloudStorageService.deleteContent(path);
  }
}
