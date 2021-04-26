import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AllDocumentsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  String _subjectName;

  String getSubjectNameAcronym(String subName) {
    List<String> words = [];
    List<String> temp = [];
    bool subNameHasHyphen = false;
    if (subName.contains('-')) {
      temp = subName.split('-');
      words = temp[0].split(' ');
      subNameHasHyphen = true;
    } else {
      words = subName.split(' ');
    }
    print(words);
    String result = '';
    for (int i = 0; i < words.length; i++) {
      if (words[i].length > 2) {
        result += words[i][0];
      }
    }
    if (subNameHasHyphen) {
      result += '-' + temp[1];
    }
    return result;
  }

  set subjectName(String name) {
    _subjectName = name;
  }

  onUploadButtonPressed() {
    _navigationService.navigateTo(Routes.uploadSelectionView,
        arguments: UploadSelectionViewArguments(subjectName: _subjectName));
  }

  handleStartup(BuildContext context) async {
    bool shouldShow = await _sharedPreferencesService.shouldIShowIntroDialog();
    if (shouldShow) {
      await _bottomSheetService.showBottomSheet(
          title: "Welcome !",
          description:
              "This is a student-community driven application. We do not upload all resources but give you a platform to do so.\n\nPlease Make sure you upload the best resources so that all students can benefit !\n\nThe Application is open-sourced on Github. Make sure to check it out and contribute!\n\n~Yours Sincerely\n   Abdul Malik & Syed Wajid\n   Founders, OU Notes");
    }
    bool isUserOnline = await ConnectivityWrapper.instance.isConnected;
    if (!isUserOnline) {
      _bottomSheetService.showBottomSheet(
          title: "Oops !",
          description:
              "Looks like you're offline ! please connect to the internet to access latest the documents.");
    }
  }

  navigateToDownloadScreen() {
    _navigationService.navigateTo(Routes.downLoadView);
  }
}
