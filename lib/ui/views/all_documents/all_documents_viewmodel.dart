import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/utils/permission_handler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllDocumentsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  DialogService _dialogService = locator<DialogService>();
  PermissionHandler _permissionHandler = locator<PermissionHandler>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  String _subjectName;

  set subjectName(String name) {
    _subjectName = name;
  }

  onUploadButtonPressed() {
    _navigationService.navigateTo(Routes.uploadSelectionViewRoute,
        arguments: UploadSelectionViewArguments(subjectName: _subjectName));
  }
  
  handleStartup(BuildContext context) async {
    //permission for storage not needed
    // await _permissionHandler.askPermission();
   bool shouldShow = await _sharedPreferencesService.shouldIShowIntroDialog();
   if (shouldShow) {
      await _bottomSheetService.showBottomSheet(
        title: "Welcome !",
        description: "This is a student-community driven application. We do not upload all resources but give you a platform to do so.\n\nPlease Make sure you upload the best resources so that all students can benefit !\n\nThe Application is open-sourced on Github. Make sure to check it out and contribute!\n\n~Yours Sincerely\n   Abdul Malik & Syed Wajid\n   Founders, OU Notes"
      );
      // await showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(20)),
      //           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //           title: Text(
      //             "Welcome !",
      //             style: Theme.of(context)
      //                 .textTheme
      //                 .headline6
      //                 .copyWith(fontSize: 18),
      //           ),
      //           content: SingleChildScrollView(
      //             child: Text(
      //               "This is a student-community driven application. We do not upload all resources but give you a platform to do so.\n\nPlease Make sure you upload the best resources so that all students can benefit !\n\nThe Application is open-sourced on Github. Make sure to check it out and contribute!\n\n~Yours Sincerely\n   Abdul Malik & Syed Wajid\n   Founders, OU Notes",
      //               style: Theme.of(context)
      //                   .textTheme
      //                   .subtitle1
      //                   .copyWith(fontSize: 18),
      //             ),
      //           ),
      //           actions: <Widget>[
      //             FlatButton(
      //                 child: Text(
      //                   "Ok",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .subtitle2
      //                       .copyWith(fontSize: 17),
      //                 ),
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 }),
      //           ]);
      //     });
    }
    bool isUserOnline = await ConnectivityWrapper.instance.isConnected;
    if (!isUserOnline){
      _bottomSheetService.showBottomSheet(title: "Oops !",description: "Looks like you're offline ! please connect to the internet to access latest the documents.");
    }
 }
}
