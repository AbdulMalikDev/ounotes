part of './../google_drive_service.dart';

extension GoogleDriveDeletes on GoogleDriveService{

  /// Function to delete file in Google Drive Account
  ///
  /// `@return values`
  ///
  ///   - "delete successful"
  ///
  Future<String> deleteFile({@required dynamic doc}) async {
    try {
      log.e("File being deleted");
      // initialize http client and GDrive API
      final accountCredentials = new ServiceAccountCredentials.fromJson(
          _remote.remoteConfig.getString("GDRIVE"));
      final scopes = ['https://www.googleapis.com/auth/drive'];

      AutoRefreshingAuthClient gdriveAuthClient =
          await clientViaServiceAccount(accountCredentials, scopes);
      var drive = ga.DriveApi(gdriveAuthClient);
      await _firestoreService.deleteDocument(doc);
      await drive.files.delete(doc.GDriveID);
      return "delete successful";
    } catch (e) {
      return _errorHandling(
          e, "While DELETING Notes IN Google Drive , Error occurred");
    }
  }

  /// Function to delete Folder of a Subject in Google Drive Account
  ///
  /// `@return values`
  ///
  ///   - None
  ///
  Future<bool> deleteSubjectFolder(Subject subject) async {
    log.i("${subject.name} folders being DELETED in GDrive");
    // initialize http client and GDrive API
    try {
      var AuthHeaders = await _authenticationService.refreshSignInCredentials();
      var client = GoogleHttpClient(AuthHeaders);
      var drive = ga.DriveApi(client);
      await drive.files.delete(subject.gdriveFolderID);
      return true;
    } catch (e) {
      log.e("Error while DELETING folders for subject : ${subject.name}");
      log.e(e.toString());
      return false;
    }
  }
}
