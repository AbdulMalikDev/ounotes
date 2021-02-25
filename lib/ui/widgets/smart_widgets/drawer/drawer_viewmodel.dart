import 'dart:io';
import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
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

  bool get isAdmin => _authenticationService.user.isAdmin;

  dispatchEmail() async {
    await EmailService.emailFunc(
      subject: "OU Notes Feedback",
      body:
          "[if you are facing errors please attach Screen Shots or Screen Recordings]",
    );
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    // minDays: 0, // Show rate popup on first day of install,
    // minLaunches:
    //     3, // Show rate popup after 3 launches of app after minDays is passed.
    // remindDays: 7,
    // remindLaunches: 10,
    googlePlayIdentifier: 'com.notes.ounotes',
    appStoreIdentifier: 'com.notes.ounotes',
  );

  showRateMyAppDialog(BuildContext context) {
    rateMyApp.init().then(
      (_) {
        rateMyApp.showStarRateDialog(context,
            title: 'Rate this app', // The dialog title.
            message:
                'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
            // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
            actionsBuilder: (context, stars) {
          // Triggered when the user updates the star rating.
          return [
            // Return a list of actions (that will be shown at the bottom of the dialog).
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                print('Thanks for the ' +
                    (stars == null ? '0' : stars.round().toString()) +
                    ' star(s) !');
                Navigator.pop<RateMyAppDialogButton>(
                    context, RateMyAppDialogButton.rate);
                if (stars < 4) {
                  dispatchEmail();
                } else {
                  OpenAppstore.launch(
                      androidAppId: 'com.notes.ounotes',
                      iOSAppId: 'com.notes.ounotes');
                }
                // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                Navigator.pop<RateMyAppDialogButton>(
                    context, RateMyAppDialogButton.rate);
              },
            ),
          ];
        },
            ignoreNativeDialog: Platform
                .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
            dialogStyle: DialogStyle(
              // Custom dialog styles.
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions:
                StarRatingOptions(), // Custom star bar rating options.
            onDismissed:
                () {} // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
            );
      },
    );
  }

  updateAppTheme(boolVal) async {
    _appStateNotifier.updateTheme(boolVal);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isdarkmodeon', boolVal);
    notifyListeners();
  }

  navigateToAllDocumentsScreen(Document document) {
    _navigationService.navigateTo(Routes.allDocumentsViewRoute);
  }

  navigateToProfileScreen(Document p1) {
    _navigationService.navigateTo(Routes.profileView);
  }

  navigateToAboutUsScreen(Document p1) {
    _navigationService.navigateTo(Routes.aboutUsViewRoute);
  }

  navigateToUserUploadScreen(Document p1) {
    _navigationService.navigateTo(
      Routes.uploadSelectionViewRoute,
      arguments: UploadSelectionViewArguments(path: p1),
    );
  }

  navigateToDownloadScreen(Document p1) {
    _navigationService.navigateTo(Routes.downLoadView);
  }

  navigateToFDIntroScreen(Document path) {
    _navigationService.navigateTo(Routes.fdInputView,
        arguments: FDInputViewArguments(path: path));
  }

  navigateToAdminUploadScreen(Document path) {
    _navigationService.navigateTo(Routes.adminViewRoute,
        arguments: FDInputViewArguments(path: path));
  }

  Future<String> getUserEmail() async =>
      await _getUser().then((user) => user.email);

  Future<String> getUserId() async => await _getUser().then((user) => user.id);

  Future<User> _getUser() async {
    if (_user == null) this._user = await _authenticationService.getUser();
    notifyListeners();
    return _user;
  }

  handleSignOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Are you sure, you want to logout?",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 20),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Text(
                    "GO BACK",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "PROCEED",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    setBusy(true);
                    await _authenticationService.handleSignOut().then((value) {
                      if (value ?? true) {
                        _navigationService.navigateTo(Routes.introViewRoute);
                      } else
                        Fluttertoast.showToast(
                            msg: "Sign Out failed ,please try again later");
                    });
                    setBusy(false);
                    notifyListeners();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
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
}
