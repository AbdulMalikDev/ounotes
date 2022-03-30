part of './../google_drive_service.dart';

extension GoogleDriveReads on GoogleDriveService{

  Future downloadPuchasedPdf(
      {var note,
      Function(String, String) onDownloadedCallback,
      Function startDownload}) async {
    try {

      //>> Display ads based on downloads
      await _admobService.showAd();
      if (_admobService.shouldShowAd()) {
        return;
      }

      //>> If file exists, avoid downloading again
      String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS)+ "/OUNotes/" + note.subjectName + "/" + note.type.replaceAll(' ', '') + "/";
      log.e(path);
      String fileName = "${note.subjectName}_${note.title}.pdf";
      String filePath = path + fileName;
      bool doesFileExist = await _checkIfFileExists(filePath);
      if (doesFileExist) {
        log.e("File Already Exists in Storage");
        _createDownloadObject(note,filePath);
        onDownloadedCallback(filePath, fileName);
        return;
      }

      //>> Verify storage permission
      PermissionStatus status = await Permission.storage.request();
      log.e(status.isGranted);
      int downloadedLength = 0;
      downloadProgress.value = 0;
      List<int> dataStore = [];

      startDownload();

      //> Google Drive Set Up
      ga.DriveApi drive = await _initializeHttpClientAndGDriveAPI();

      //>> Download file
      String fileID = note.GDriveID;
      ga.Media file = await drive.files
          .get(fileID, downloadOptions: ga.DownloadOptions.fullMedia);
      _createPath(path);

      
      log.e(filePath);
      //*Figure out size from note.size property to show proper loading indicator
      File localFile;
      double contentLength;
      if (note.size != null) {
        contentLength = double.parse(note.size.split(" ")[0]);
        contentLength = note.size?.split(" ")[1] == 'KB'
            ? contentLength * 1000
            : contentLength * 1000000;
        log.e("Size in numbers : " + contentLength.toString());
      } else {
        contentLength = 0.0;
      }

      //*Start the download
      file.stream.listen((data) {
        downloadedLength += data.length;
        downloadProgress.value = (downloadedLength / contentLength) * 100;
        // log.e(downloadedLength);
        // log.e(contentLength);
        print("loading.. : " + downloadProgress.value.toString());
        // if(downloadProgress.value < 1)
        // EasyLoading.showProgress(downloadProgress.value, status: 'downloading...');
        dataStore.insertAll(dataStore.length, data);
        downloadProgress.notifyListeners();
      }, onDone: () async {
        // EasyLoading.dismiss();
        localFile = File(filePath);
        await localFile.writeAsBytes(dataStore);
        note = note as AbstractDocument;
        _createDownloadObject(note,localFile.path);
        await Future.delayed(Duration(seconds: 1));
        await onDownloadedCallback(localFile.path, fileName);
        log.e("DOWNLOAD DONE");
        downloadProgress.value = 0;
      });
    } catch (e) {
      print("error");
      log.e(e);
    }
  } 
}

// -- Legacy Code -- 
// downloadFile(
//       {@required Note note,
//       @required onDownloadedCallback,
//       @required startDownload,
//       loading}) async {
//     try {
//       int downloadedLength = 0;
//       downloadProgress.value = 0;
//       List<int> dataStore = [];

//       //>> If file exists, avoid downloading again
//       File localFile;
//       Directory tempDir = await getTemporaryDirectory();
//       String filePath = "${tempDir.path}/${note.subjectId}_${note.id}";
//       log.e(filePath);
//       bool doesFileExist = await _checkIfFileExists(filePath);
//       if (doesFileExist) {
//         onDownloadedCallback(filePath, note);
//         return;
//       }

//       startDownload();

//       //>> Google Drive Set Up
//       var drive = _initializeHttpClientAndGDriveAPI();
//       String fileID = note.GDriveID;

//       //>> Initialization for Download
//       ga.Media file = await drive.files
//           .get(fileID, downloadOptions: ga.DownloadOptions.fullMedia);

//       //*Figure out size from note.size property to show proper loading indicator
//       double contentLength =
//           double.parse(note.size == null ? '0.0' : note.size.split(" ")[0]);
//       contentLength = note.size == null
//           ? 0
//           : note.size.split(" ")[1] == 'KB'
//               ? contentLength * 1000
//               : contentLength * 1000000;

//       //>> Start the download
//       file.stream.listen((data) {
//         downloadedLength += data.length;
//         downloadProgress.value = ((downloadedLength / contentLength) * 100);
//         loading.value = downloadProgress.value;
//         print(downloadProgress.value);
//         dataStore.insertAll(dataStore.length, data);
//       }, onDone: () async {
//         localFile = File(filePath);
//         await localFile.writeAsBytes(dataStore);
//         _insertBookmarks(filePath, note);
//         Download downloadObject = Download(
//           id: note.id,
//           path: filePath,
//           author: note.author,
//           view: note.view,
//           size: note.size,
//           subjectName: note.subjectName,
//           title: note.title,
//           uploadDate: note.uploadDate,
//         );
//         //  note.id,
//         //   filePath,
//         //   note.title,
//         //   note.subjectName,
//         //   note.author,
//         //   note.view,
//         //   note.pages,
//         //   note.size,
//         //   note.uploadDate,
//         _downloadService.addDownload(download: downloadObject);
//         await Future.delayed(Duration(seconds: 1));
//         downloadProgress.value = 0;
//         onDownloadedCallback(localFile.path, note);
//       });
//     } catch (e) {
//       log.e(e.toString());
//     }
//   }
