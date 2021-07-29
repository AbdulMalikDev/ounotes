
import 'dart:io';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/models/UploadLog.dart';
import 'package:FSOUNotes/models/link.dart' as linkModel;
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/verifier.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("DocumentService");

class DocumentService{

  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();

  ValueNotifier<double> downloadProgress = new ValueNotifier(0);


  viewDocument(UploadLog logItem) async {
    //>> Extract document from firebase
    AbstractDocument doc = await _firestoreService.getDocumentById(logItem.subjectName, logItem.id, Constants.getDocFromConstant(logItem.type));
    Document docType = Constants.getDocFromConstant(logItem.type);

    if(docType == Document.Links){
      log.i("Link being shown");
      await _viewLink(doc);
      return;
    }
    
    if(doc.GDriveLink == null){
      //>> Document exists in firebase storage
      await viewDocumentfromFirebase(logItem,doc);
    }else{
      //>> Document exists in Google Drive storage
      await viewDocumentFromGoogleDrive(logItem,doc);

    }
  }


  viewDocumentfromFirebase(UploadLog logItem, AbstractDocument doc) async {
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
      return;
    }
    _navigationService.navigateTo(Routes.pDFScreen,
        arguments: PDFScreenArguments(pathPDF: PDFpath, askBookMarks: false));

  }

  viewDocumentFromGoogleDrive(UploadLog logItem,AbstractDocument doc) async {
    log.i("Viewing document from Google Drive");
    Document docType = Constants.getDocFromConstant(logItem.type);

    if(docType != Document.Notes){
      Helper.launchURL(doc.GDriveLink);
    }

    //>> Download Notes from GDrive [As of time of writing this function was limited to Notes only]
    try {
      await _googleDriveService.downloadFile(
        loading:downloadProgress,
        note: doc,
        startDownload: () {
        },
        onDownloadedCallback: (path, note) {
          _navigationService.navigateTo(Routes.pDFScreen,
              arguments: PDFScreenArguments(
                  pathPDF: path, doc: note, askBookMarks: false));
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
    await _dialogService.showDialog(title: "Link Content" , description: link.linkUrl);
  }


  Future<UploadLog> verifyDocument(UploadLog logItem) async {

    SheetResponse response = await _bottomSheetService.showBottomSheet(title: "Are you sure?",description: "");
    if(response==null || !response.confirmed)return null;

    dynamic doc = await _firestoreService.getDocumentById(logItem.subjectName,logItem.id,Constants.getDocFromConstant(logItem.type));
    if(doc == null){await _dialogService.showDialog(title:"Oops",description: "Can't find this document");return null;}

    if (logItem.type == Constants.links){

      if(doc.uploaded == true){await _dialogService.showDialog(title: "ERROR" , description: "LINK ALREADY UPLOADED");return null;}
      doc.uploaded = true;
      await _firestoreService.updateDocument(doc, Document.Links);
      await _bottomSheetService.showBottomSheet(title: "VERIFIED",description: "Link has been verified ✔️");
      return null;
    }

    try {

      if(doc.GDriveID == null){
        //>> Case 1 : If document is uploaded in firebase, it should be added in 
        //>> process documents so that admin can upload it
        //>> Do Nothing simply forward to Admin

      }else{
        //>>Case 2 : If document is uploaded in GDrive it should be directly updated so that it's live
        await _firestoreService.updateDocument(doc, Constants.getDocFromConstant(logItem.type));
        await _firestoreService.deleteUploadLog(logItem);
        Verifier verifier = _updateVerifier(Verifier.fromUser(_authenticationService.user),logItem.id); 
        await _firestoreService.updateVerifierInFirebase(verifier);
        await _bottomSheetService.showBottomSheet(title: "VERIFIED",description: "Document has been verified ✔️ It may or may not go live instantly. Some documents are automatically sent to the admin for further verification.");
        return UploadLog(isVerifierVerified: true);
      }
      
    } catch (e) {
      _bottomSheetService.showBottomSheet(
        title: "OOPS",
        description: e.toString(),
      );
    }
    await _bottomSheetService.showBottomSheet(title: "VERIFIED",description: "Document has been verified ✔️ It may or may not go live instantly. Some documents are automatically sent to the admin for further verification.");
    logItem.isVerifierVerified = true;
    logItem.verifier_id = _authenticationService.user.id;
    Verifier verifier = _updateVerifier(Verifier.fromUser(_authenticationService.user),logItem.id); 
    await _firestoreService.updateVerifierInFirebase(verifier);
    _firestoreService.updateDocument(logItem, Document.UploadLog);
    return logItem;
  }

  Future<UploadLog> passDocument(UploadLog logItem,String additionalInfo) async {
    SheetResponse response = await _bottomSheetService.showBottomSheet(title: "Are you sure?",description: "");
    if(response==null || !response.confirmed)return null;
    //>> Document should be passed to admin
    logItem.verifier_id = _authenticationService.user.id;
    logItem.additionalInfo = additionalInfo;
    logItem.isVerifierVerified = true;
    _firestoreService.updateDocument(logItem, Document.UploadLog);
    Verifier verifier = _updateVerifier(Verifier.fromUser(_authenticationService.user),logItem.id); 
    await _firestoreService.updateVerifierInFirebase(verifier);
    await _bottomSheetService.showBottomSheet(title: "FORWARDED TO ADMIN",description: "Document has been passed to admin ✔️ ");
    return logItem;
  }


  Verifier _updateVerifier(Verifier verifier,id,{bool isReport = false}){
    if(!isReport){verifier.numOfVerifiedDocs = 1;verifier.numOfReportedDocs = 0;}
    else {verifier.numOfReportedDocs = 1;verifier.numOfVerifiedDocs = 0;}
    verifier.docIdBeingVerified = id;
    return verifier;
  }

  deleteDocumentForVerifier(UploadLog logItem) async {
    SheetResponse response = await _bottomSheetService.showBottomSheet(title: "Are you sure?",description: "");
    if(response==null || !response.confirmed)return null;
    //>> Document should be passed to admin
    logItem.verifier_id = _authenticationService.user.id;
    logItem.isVerifierVerified = true;
    _firestoreService.updateDocument(logItem, Document.UploadLog);
    Verifier verifier = _updateVerifier(Verifier.fromUser(_authenticationService.user),logItem.id,isReport: true);
    log.e(verifier.toJson()); 
    await _firestoreService.updateVerifierInFirebase(verifier);
    await _bottomSheetService.showBottomSheet(title: "FORWARDED TO ADMIN",description: "Document has been passed to admin ✔️ ");
    return logItem;
  }
}