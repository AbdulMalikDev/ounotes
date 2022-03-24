import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/download.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../enums/constants.dart';

class DownLoadViewModel extends BaseViewModel {
  Logger log = getLogger("downloads");
  String table = 'downloaded_subjects';
  DownloadService _downloadService = locator<DownloadService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  GoogleInAppPaymentService _googleInAppPaymentService =
      locator<GoogleInAppPaymentService>();
  User user;

  deleteDownload({
    int index,
    String path,
    String downloadBoxName,
    String type = "Note",
    BuildContext context,
  }) {
    Helper.showDeleteConfirmDialog(
        context: context,
        msg: type != Constants.syllabus
            ? "Are you sure you want to delete this ${type.substring(0, type.length - 1)}?"
            : "Are you sure you want to delete this $type",
        onDeletePressed: () {
          _downloadService.removeDownload(index, path, downloadBoxName);
          Navigator.pop(context);
        });
  }

  getUser() async {
    this.user = await _authenticationService.getUser();
  }

  buyPremium() async {
    ProductDetails prod = _googleInAppPaymentService
        .getProduct(GoogleInAppPaymentService.premiumProductID);
    if (prod == null) return;

    SheetResponse response = await _bottomSheetService.showCustomSheet(
        title: "OU Notes Premium",
        variant: BottomSheetType.premium,
        customData: {"price": prod.price});
    if (response?.confirmed ?? false) {
      if (prod == null) {
        return;
      }
      await _googleInAppPaymentService.buyProduct(prod: prod);
      log.e("Download started");
    }
  }

  init() async {
    setBusy(true);
    if (!Hive.isBoxOpen(Constants.notesDownloads)) {
      await Hive.openBox<Download>(Constants.notesDownloads);
    }
    if (!Hive.isBoxOpen(Constants.questionPaperDownloads)) {
      await Hive.openBox<Download>(Constants.questionPaperDownloads);
    }
    if (!Hive.isBoxOpen(Constants.syllabusDownloads)) {
      await Hive.openBox<Download>(Constants.syllabusDownloads);
    }
    setBusy(false);
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
    log.e("download objecthere");
    log.e(download);
    log.e(download.path);
    _navigationService.navigateTo(Routes.pDFScreen,
        arguments: PDFScreenArguments(
            pathPDF: download.path, doc: note, isUploadingDoc: false));
  }
}
