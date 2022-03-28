import 'dart:io';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart' as linkModel;
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/models/verifier.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/notification_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("DocumentService");

class DocumentService {
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  NotificationService _notificationService = locator<NotificationService>();
  DownloadService _downloadService = locator<DownloadService>();

  ValueNotifier<double> downloadProgress = new ValueNotifier(0);

  List<File> sharedFiles = null;
  SharedDocType sharedFileType = null;

  ///Function to view any document regardless of where it is uploaded
  viewDocument(UploadLog logItem, {bool viewInBrowser = false}) async {
    //>> Extract document from firebase
    AbstractDocument doc = await _firestoreService.getDocumentById(
        logItem.subjectName,
        logItem.id,
        Constants.getDocFromConstant(logItem.type));
    Document docType = Constants.getDocFromConstant(logItem.type);

    if (docType == Document.Links) {
      log.i("Link being shown");
      await _viewLink(doc);
      return;
    }

    if (doc.GDriveLink == null) {
      //>> Document exists in firebase storage
      await _viewDocumentfromFirebase(logItem, doc);
    } else {
      //>> Document exists in Google Drive storage
      await _viewDocumentFromGoogleDrive(logItem, doc, viewInBrowser);
    }
  }

  /// Used when the verifier thinks the document should be uploaded
  ///
  /// Typically invoked from the Verifier Panel > Docs to Verify Screen
  Future<UploadLog> verifyDocument(UploadLog logItem) async {
    SheetResponse response = await _bottomSheetService.showBottomSheet(
        title: "Are you sure?", description: "");
    if (response == null || !response.confirmed) return null;

    dynamic doc = await _firestoreService.getDocumentById(logItem.subjectName,
        logItem.id, Constants.getDocFromConstant(logItem.type));
    if (doc == null) {
      await _dialogService.showDialog(
          title: "Oops", description: "Can't find this document");
      return null;
    }

    if (logItem.type == Constants.links) {
      if (doc.uploaded == true) {
        await _dialogService.showDialog(
            title: "ERROR", description: "LINK ALREADY UPLOADED");
        return null;
      }
      doc.uploaded = true;
      await _firestoreService.updateDocument(doc, Document.Links);
      await _bottomSheetService.showBottomSheet(
          title: "VERIFIED", description: "Link has been verified ✔️");
      return null;
    }

    try {
      if (doc.GDriveID == null) {
        //>> Case 1 : If document is uploaded in firebase, it should be added in
        //>> process documents so that admin can upload it
        //>> Do Nothing simply forward to Admin

      } else {
        //>>Case 2 : If document is uploaded in GDrive it should be directly updated so that it's live
        await _firestoreService.updateDocument(
            doc, Constants.getDocFromConstant(logItem.type));
        await _firestoreService.deleteUploadLog(logItem);
        Verifier verifier = _updateVerifier(
            Verifier.fromUser(_authenticationService.user), logItem.id);
        await _firestoreService.updateVerifierInFirebase(verifier);
        await _bottomSheetService.showBottomSheet(
            title: "VERIFIED",
            description:
                "Document has been verified ✔️ It may or may not go live instantly. Some documents are automatically sent to the admin for further verification.");
        return UploadLog(isVerifierVerified: true);
      }
    } catch (e) {
      _bottomSheetService.showBottomSheet(
        title: "OOPS",
        description: e.toString(),
      );
    }
    await _bottomSheetService.showBottomSheet(
        title: "VERIFIED",
        description:
            "Document has been verified ✔️ It may or may not go live instantly. Some documents are automatically sent to the admin for further verification.");
    logItem.isVerifierVerified = true;
    logItem.verifier_id = _authenticationService.user.id;
    Verifier verifier = _updateVerifier(
        Verifier.fromUser(_authenticationService.user), logItem.id);
    await _firestoreService.updateVerifierInFirebase(verifier);
    _firestoreService.updateDocument(logItem, Document.UploadLog);
    return logItem;
  }

  /// Used when the verifier is confused and wants to forward the document to the admin
  ///
  /// Typically invoked from the Verifier Panel Screens
  Future<UploadLog> passDocument(
      UploadLog logItem, String additionalInfo) async {
    SheetResponse response = await _bottomSheetService.showBottomSheet(
        title: "Are you sure?", description: "");
    if (response == null || !response.confirmed) return null;
    //>> Document should be passed to admin
    logItem.verifier_id = _authenticationService.user.id;
    logItem.additionalInfo = additionalInfo;
    logItem.isVerifierVerified = true;
    log.e(logItem.isPassed);
    _firestoreService.updateDocument(logItem, Document.UploadLog);
    Verifier verifier = _updateVerifier(
        Verifier.fromUser(_authenticationService.user), logItem.id);
    await _firestoreService.updateVerifierInFirebase(verifier);
    await _bottomSheetService.showBottomSheet(
        title: "FORWARDED TO ADMIN",
        description: "Document has been passed to admin ✔️ ");
    return logItem;
  }

  /// Used when the verifier thinks the document should be deleted
  /// essentially agreeing with the user who has reported this document.
  /// The document wont be deleted but it will be forwarded to the admin for one last check.
  ///
  /// Typically invoked from the Verifier Panel > Rerported Docs Screen
  deleteDocumentForVerifier(UploadLog logItem) async {
    SheetResponse response = await _bottomSheetService.showBottomSheet(
        title: "Are you sure?", description: "");
    if (response == null || !response.confirmed) return null;
    //>> Document should be passed to admin
    logItem.verifier_id = _authenticationService.user.id;
    logItem.isVerifierVerified = true;
    _firestoreService.updateDocument(logItem, Document.UploadLog);
    Verifier verifier = _updateVerifier(
        Verifier.fromUser(_authenticationService.user), logItem.id,
        isReport: true);
    await _firestoreService.updateVerifierInFirebase(verifier);
    await _bottomSheetService.showBottomSheet(
        title: "FORWARDED TO ADMIN",
        description: "Document has been passed to admin ✔️ ");
    await _firestoreService.deleteReport(null, id: logItem.id);
    return logItem;
  }

  /// Function to delete reports that are useless
  deleteReport(Report report) async {
    SheetResponse response = await _bottomSheetService.showBottomSheet(
        title: "Are you sure?", description: "");
    if (response == null || !response.confirmed) return null;
    Verifier verifier = _updateVerifier(
        Verifier.fromUser(_authenticationService.user), report.id,
        isReport: true);
    await _firestoreService.deleteReport(report);
    await _firestoreService.updateVerifierInFirebase(verifier);
    await _bottomSheetService.showBottomSheet(
        title: "REPORT DELETED", description: "Nice Work ✔️ ");
    return report;
  }

  /// Function to upload any document
  uploadDocument(UploadLog logItem) async {
    //>> Extract document from firebase
    AbstractDocument doc = await _firestoreService.getDocumentById(
        logItem.subjectName,
        logItem.id,
        Constants.getDocFromConstant(logItem.type));
    Document docType = Constants.getDocFromConstant(logItem.type);

    if (docType == Document.Links) {
      log.i("Link being shown");
      await _uploadLink(doc);
      return;
    }

    if (doc.GDriveLink == null) {
      //>> Document exists in firebase storage
      File file =
          await _viewDocumentfromFirebase(logItem, doc, navigate: false);
      await _googleDriveService.uploadFileToGoogleDriveAfterVerification(
          file, docType, doc);
      _dialogService.showDialog(title: "OUTPUT", description: "");
    } else {
      //>> Document exists in Google Drive storage
      await _firestoreService.updateDocument(
          doc, Constants.getDocFromConstant(logItem.type));
    }
  }

  downloadDocument(
      {AbstractDocument note,
      Function setLoading
      }) async {
    SheetResponse response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.filledStacks,
        title: "⬇",
        description: "Sure you want to download ${note.title} ?",
        mainButtonTitle: "YES",
        secondaryButtonTitle: "NO",
        customData: {"download": true});
    print(response?.confirmed);
    if (response == null || !response.confirmed) return;
    if (note.type == Constants.notes){
      await _firestoreService.incrementView(note);
    }
    await _googleDriveService.downloadPuchasedPdf(
      note: note,
      startDownload: () {
        setLoading(true);
      },
      onDownloadedCallback: (path, fileName) async {
        setLoading(false);
        await _notificationService.dispatchLocalNotification(
            NotificationService.download_purchase_notify, {
          "title": "Downloaded " + fileName,
          "body":
              "PDF File has been downloaded in the downloads folder. Thank you for using the OU Notes app.",
          "payload": {"path": path, "id": note.id},
        });
        User user = await _authenticationService.getUser();
        user.addDownload("${note.subjectId}_${note.id}");
        _navigationService.navigateTo(Routes.thankYouView,
            arguments: ThankYouViewArguments(filePath: path));
      },
    );
    return true;

    // -- Legacy Code used for premium in-app  feature--
    //
    // ProductDetails prod = _googleInAppPaymentService
    //     .getProduct(GoogleInAppPaymentService.pdfProductID);
    // //Show download floating sheet
    // SheetResponse response = await _bottomSheetService.showCustomSheet(
    //     variant: BottomSheetType.downloadPdf,
    //     title: "Download PDF",
    //     customData: {"price": prod?.price ?? "10"});

    // if (response?.confirmed ?? false) {
    //   if (prod == null) {
    //     return;
    //   }
    //   await _googleInAppPaymentService.buyProduct(prod: prod, note: note);
    //   log.e("Download started");
    // }
  }

  deleteDocument(UploadLog logItem) async {
    try {
      SheetResponse response = await _bottomSheetService.showBottomSheet(
          title: "Are you sure you want to delete?", description: "");
      if (response == null || !response.confirmed) return null;
      //>> Extract document from firebase
      AbstractDocument doc = await _firestoreService.getDocumentById(
          logItem.subjectName,
          logItem.id,
          Constants.getDocFromConstant(logItem.type));
      Document docType = Constants.getDocFromConstant(logItem.type);

      if (docType == Document.Links) {
        log.i("Link being shown");
        await _deleteLink(doc);
        return;
      }
      if (doc == null) {
        log.e("Doc null");
        return;
      }

      if (doc.GDriveLink == null) {
        await _cloudStorageService.deleteDocument(doc);
      } else {
        await _googleDriveService.deleteFile(doc: doc);
        _dialogService.showDialog(title: "Deleted", description: "Success");
      }
    } catch (e) {
      _bottomSheetService.showBottomSheet(
        title: "OOPS",
        description: e.toString(),
      );
    }
  }

  Verifier _updateVerifier(Verifier verifier, id, {bool isReport = false}) {
    if (!isReport) {
      verifier.numOfVerifiedDocs = 1;
      verifier.numOfReportedDocs = 0;
    } else {
      verifier.numOfReportedDocs = 1;
      verifier.numOfVerifiedDocs = 0;
    }
    verifier.docIdBeingVerified = id;
    return verifier;
  }

  Future<File> _viewDocumentfromFirebase(
      UploadLog logItem, AbstractDocument doc,
      {bool navigate = true}) async {
    log.i("Viewing document from Firebase");
    downloadProgress.value = 0;
    File file = await _cloudStorageService.downloadFile(
      notesName: logItem.fileName,
      subName: logItem.subjectName,
      type: logItem.type,
      note: doc,
    );
    String PDFpath = file?.path;
    log.e("FilePath : " + file.path);
    if (PDFpath == null) {
      await Fluttertoast.showToast(
          msg:
              'An error has occurred while downloading document from Firebase...Please Verify your internet connection.');
      return null;
    }
    if (navigate)
      _navigationService.navigateTo(Routes.pDFScreen,
          arguments: PDFScreenArguments(pathPDF: PDFpath,doc: doc,isUploadingDoc: false));
    return file;
  }

  _viewDocumentFromGoogleDrive(
      UploadLog logItem, AbstractDocument doc, bool viewInBrowser) async {
    log.i("Viewing document from Google Drive");
    Document docType = Constants.getDocFromConstant(logItem.type);

    if (viewInBrowser) {
      Helper.launchURL(doc.GDriveLink);
      return;
    }

    if (docType != Document.Notes) {
      Helper.launchURL(doc.GDriveLink);
      return;
    }

    //>> Download Notes from GDrive [As of time of writing this function was limited to Notes only]
    try {
      await _googleDriveService.downloadPuchasedPdf(
        // loading: downloadProgress,
        note: doc,
        startDownload: () {},
        onDownloadedCallback: (path, note) {
          _navigationService.navigateTo(Routes.pDFScreen,
              arguments: PDFScreenArguments(pathPDF: path, doc: doc));
        },
      );
      return;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error Occurred while downloading pdf..." +
              "Please check you internet connection and try again later");
      return;
    }
  }

  void _viewLink(linkModel.Link link) async {
    FlutterClipboard.copy(link.linkUrl);
    await _dialogService.showDialog(
        title: "Link Content", description: link.linkUrl);
  }

  _uploadLink(linkModel.Link link) async {
    if (link.uploaded == true) {
      await _dialogService.showDialog(
          title: "ERROR", description: "ALREADY UPLOADED");
      return;
    }
    link.uploaded = true;
    await _firestoreService.updateDocument(link, Document.Links);
  }

  _deleteLink(linkModel.Link link) async {
    await _firestoreService.deleteLinkById(link.id);
    SheetResponse response = await _bottomSheetService.showBottomSheet(
        title: "Link Deleted ✔️", description: "");
  }

  void shareFile(List<SharedMediaFile> sharedFile) {
    this.sharedFiles = sharedFile.map((e) => File(e.path)).toList();

    switch(sharedFile[0].type){
      
      case SharedMediaType.IMAGE:
        this.sharedFileType = SharedDocType.IMAGE;
        _navigationService.navigateTo(Routes.uploadSelectionView);
        return;
      case SharedMediaType.FILE:
        this.sharedFileType = SharedDocType.FILE;
        if(sharedFile.length > 1){
          Fluttertoast.showToast(msg: "Cannot upload multiple documents at once! Please merge them first at www.ilovepdf.com");
          return;
        }
        _navigationService.navigateTo(Routes.uploadSelectionView);
        return;
      case SharedMediaType.VIDEO:
      default:
        break;

    }
    // If control flow reaches this point document type not supported
    Fluttertoast.showToast(msg: "Document Type Not Supported. Please Upload a PDF or Image");
  }
}
