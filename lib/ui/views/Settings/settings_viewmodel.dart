import 'dart:convert';
import 'dart:io';
import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/AppTheme/AppTheme.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/services/funtional_services/email_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';

class SettingsViewModel extends BaseViewModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  AppInfoService _appInfoService = locator<AppInfoService>();
  AppStateNotifier _appStateNotifier = locator<AppStateNotifier>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  GoogleInAppPaymentService _googleInAppPaymentService =
      locator<GoogleInAppPaymentService>();

  String _userOption;
  User _user = User();
  User get user => _user;

  String get userOption => _userOption;

  PackageInfo packageInfo;
  bool get isVerifier => _authenticationService.user.isVerifier;
  bool get isAdmin => _authenticationService.user.isAdmin;

  getPackageInfo() async {
    if (packageInfo == null) {
      packageInfo = await _appInfoService.getPackageInfo();
    }
  }

  List<DropdownMenuItem<String>> _dropDownOfOpenPDF;
  List<DropdownMenuItem<String>> get dropDownOfOpenPDF => _dropDownOfOpenPDF;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = [];
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Text(item)));
    });
    return i;
  }

  void changedDropDownItemOfOpenPdfChoice(String newChoice) async {
    _userOption = newChoice;
    SharedPreferences prefs = await _sharedPreferencesService.store();
    if (newChoice == "Ask me before opening pdf") {
      if (prefs.containsKey("openDocChoice")) {
        prefs.remove("openDocChoice");
      }
    } else {
      prefs.setString("openDocChoice", newChoice);
    }
    Fluttertoast.showToast(msg: "Settings Saved !");
    notifyListeners();
  }

  void recordTelegramVisit() {
    _analyticsService.addTagInNotificationService(
        key: "TELEGRAM", value: "VISITED");
    _analyticsService.logEvent(name: "TELEGRAM_VISIT");
  }

  Future updateAppTheme(BuildContext context, bool isDarkModeEnabled) async {
    // bool boolVal = !AppStateNotifier.isDarkModeOn;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isdarkmodeon', isDarkModeEnabled);
    _appStateNotifier.updateTheme(isDarkModeEnabled);

    ThemeSwitcher.of(context).changeTheme(
      theme: isDarkModeEnabled ? AppTheme.darkTheme : AppTheme.lightTheme,
      isReversed: !isDarkModeEnabled,
    );
    notifyListeners();
  }

  navigateToAboutUsScreen() {
    _navigationService.navigateTo(Routes.aboutUsView);
  }

  navigateToVerifierPanelScreen() {
    _navigationService.navigateTo(Routes.verifierPanelView);
  }

  navigateToAdminUploadScreen() {
    _navigationService.navigateTo(
      Routes.adminView,
    );
  }

  navigateToAccountInfoScreen() {
    _navigationService.navigateTo(
      Routes.accountInfoView,
    );
  }

  dispatchEmail() async {
    await EmailService.emailFunc(
      subject: "OU Notes Feedback",
      body:
          "[if you are facing errors please attach Screen Shots or Screen Recordings]",
    );
  }

  Future setUser() async {
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));
    print(user);
    _user = user;
    notifyListeners();
  }

  handleSignOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                  child: Text(
                    "GO BACK",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15, color: Colors.redAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
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
                        _navigationService.navigateTo(Routes.introView);
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
            TextButton(
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

  void showBuyPremiumBottomSheet() async {
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
    }
  }

  Future<String> getUserEmail() async =>
      await _getUser().then((user) => user.email);

  Future<String> getUserId() async => await _getUser().then((user) => user.id);
  Future<User> _getUser() async {
    if (_user == null) this._user = await _authenticationService.getUser();
    notifyListeners();
    return _user;
  }
}
