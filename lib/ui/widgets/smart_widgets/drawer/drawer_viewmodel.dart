import 'dart:io';
import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/email_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:open_appstore/open_appstore.dart';

Logger log = getLogger("DrawerViewModel");

class DrawerViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  AppStateNotifier _appStateNotifier = locator<AppStateNotifier>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  AppInfoService _appInfoService = locator<AppInfoService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  GoogleInAppPaymentService _googleInAppPaymentService = locator<GoogleInAppPaymentService>();

  User _user;

  User get user => _user;

  PackageInfo packageInfo;


  getPackageInfo() async {
    if (packageInfo == null) {
      packageInfo = await _appInfoService.getPackageInfo();
    }
  }

 bool get isVerifier => _authenticationService.user.isVerifier;
 bool get isAdmin => _authenticationService.user.isAdmin;




  updateAppTheme(boolVal) async {
    _appStateNotifier.updateTheme(boolVal);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isdarkmodeon', boolVal);
    notifyListeners();
  }

  navigateToAllDocumentsScreen(Document document) {
    _navigationService.navigateTo(Routes.allDocumentsView);
  }

  navigateToProfileScreen(Document p1) {
    _navigationService.navigateTo(Routes.settingsView);
  }


  navigateToUserUploadScreen(Document p1) {
    _navigationService.navigateTo(
      Routes.uploadSelectionView,
      arguments: UploadSelectionViewArguments(path: p1),
    );
  }

  navigateToDownloadScreen(Document p1) {
    _navigationService.navigateTo(Routes.downLoadView);
  }

  navigateToFDIntroScreen(Document path) {
    // _navigationService.navigateTo(Routes.fDInputView,
    //     arguments: FDInputViewArguments(path: path));
  }

  // navigateToAdminUploadScreen(Document path) {
  //   _navigationService.navigateTo(Routes.adminView,
  //       arguments: FDInputViewArguments(path: path));
  // }
  navigateToVerifierPanelScreen(Document path) {
    _navigationService.navigateTo(Routes.verifierPanelView);
  }

  Future<String> getUserEmail() async =>
      await _getUser().then((user) => user.email);

  Future<String> getUserId() async => await _getUser().then((user) => user.id);

  Future<User> _getUser() async {
    if (_user == null) this._user = await _authenticationService.getUser();
    notifyListeners();
    return _user;
  }


  openDownloadBox() async {
    await Hive.openBox("downloads");
  }

  showIntro(Intro intro, BuildContext context) async {
    await _getUser();

    if (intro == null) {
      log.e("intro is null");
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) async {
      bool shouldIntroBeShown =
          await _sharedPreferencesService.shouldIShowDrawerIntro();
      if (shouldIntroBeShown) {
        if (Scaffold.of(context).isDrawerOpen) {
          Future.delayed(
              Duration(milliseconds: 240), () => intro?.start(context));
        }
      }
    });
  }

  void navigateToDonateScreen() async {
    ProductDetails prod = _googleInAppPaymentService.getProduct(GoogleInAppPaymentService.premiumProductID);
    if(prod == null)return;

    SheetResponse response = await _bottomSheetService.showCustomSheet(
      title: "OU Notes Premium",
      variant: BottomSheetType.premium,
      customData: {"price" : prod.price}
    );
    if(response?.confirmed ?? false){
      if(prod == null){return;}
      await _googleInAppPaymentService.buyProduct(prod:prod);
      log.e("Download started");
    }
  }

  navigateToVerifierPanel() {
  }
}
