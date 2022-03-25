import 'package:FSOUNotes/ui/views/FilterDocuments/FD_InputScreen/fd_inputView.dart';
import 'package:FSOUNotes/ui/views/Settings/settings_view.dart';
import 'package:FSOUNotes/ui/views/downloads/Downloads_view.dart';
import 'package:FSOUNotes/ui/views/home/home_view.dart';
import 'package:FSOUNotes/ui/views/upload/upload_selection/upload_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainScreenViewModel extends BaseViewModel {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  List<Widget> _screens = [
    HomeView(
      key: ValueKey("Home"),
    ),
    FDInputView(key: ValueKey("input")),
    UploadSelectionView(
      key: ValueKey("upload"),
      isFromMainScreen: true,
    ),
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
}
