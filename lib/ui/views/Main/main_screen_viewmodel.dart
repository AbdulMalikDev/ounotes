import 'dart:math';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputView.dart';
import 'package:FSOUNotes/ui/views/Settings/settings_view.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_view.dart';
import 'package:FSOUNotes/ui/views/home/home_view.dart';
import 'package:FSOUNotes/ui/views/upload/upload_selection/upload_selection_view.dart';
import 'package:FSOUNotes/ui/views/upload/upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainScreenViewModel extends BaseViewModel {
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  List<Widget> _screens = [
    HomeView(
      key: ValueKey("Home"),
    ),
    FDInputView(key: ValueKey("input")),
    UploadSelectionView(),
    DownLoadView(key: ValueKey("download")),
    SettingsView(key: ValueKey("settings")),
  ];

  PageController get controller => _pageController;
  List<Widget> get screens => _screens;
  int get currIdx => _selectedIndex;

  void onPageChanged(int idx) {
    print('onPageChanged Idx: ' + idx.toString());
    _pageController.animateToPage(idx,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    _selectedIndex = idx;
  }

  void onIconTapped(int pageIdx) {
    print('selectedIndex: ' + pageIdx.toString());
    _selectedIndex = pageIdx;
    notifyListeners();
  }

  void init() {}

  void updateDialog(
      bool shouldShowUpdateDialog, Map<String, dynamic> versionDetails) {
    if (versionDetails == null) return;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (shouldShowUpdateDialog) {
        String updatedVersion = versionDetails["updatedVersion"];
        String currentVersion = versionDetails["currentVersion"];
        String warning =
            "If you don't see the update option, please wait a day or two for the update to roll-out";
        //To show this warning only sometimes, using a random bool
        Random random = new Random();
        bool shouldShowWarning = random.nextBool();
        SheetResponse response = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.confirm,
          title: "Update App? ✨",
          description:
              "A new version of OU Notes is available. Update the app to avoid crashes and access new features !!",
          mainButtonTitle: 'UPDATE',
          secondaryButtonTitle: 'NOT NOW',
          barrierDismissible: false,
          customData: [
            updatedVersion,
            currentVersion,
            shouldShowWarning ? warning : ""
          ],
        );
        //BottomSheet closed by tapping elsewhere on the screen
        if (response == null) return;
        //Confirm action
        if (response.confirmed) {
          OpenAppstore.launch(
              androidAppId: 'com.notes.ounotes', iOSAppId: 'com.notes.ounotes');
        }
      }
    });
  }
}
