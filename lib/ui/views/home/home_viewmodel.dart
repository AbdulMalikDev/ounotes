import 'dart:io';
import 'dart:math';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/email_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:package_info/package_info.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';

class HomeViewModel extends BaseViewModel {
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  AdmobService _admobService = locator<AdmobService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

  NavigationService _navigationService = locator<NavigationService>();

  ValueNotifier<List<Subject>> get userSubjects =>
      _subjectsService.userSubjects;
  ValueNotifier<List<Subject>> get userSelectedSubjects =>
      _subjectsService.selectedSubjects;
  ValueNotifier<List<Subject>> get allSubjects => _subjectsService.allSubjects;
  AppInfoService _appInfoService = locator<AppInfoService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  bool _isEditPressed = false;

  bool get isEditPressed => _isEditPressed;

  set setIsEditPressed(bool isDeletePressed) {
    _isEditPressed = isDeletePressed;
    notifyListeners();
  }

  resetUserSelectedSubjects() {
    _subjectsService.resetUserSelectedSubjects();
  }

  navigateToUserUploadScreen() {
    _navigationService.navigateTo(
      Routes.uploadSelectionView,
      arguments: UploadSelectionViewArguments(),
    );
  }

  navigateToRecentlyOpenedSeeAllScreen() {
    // _navigationService.navigateTo(Routes.recentlyAddedNotesView);
  }

  deleteSelectedSubjects() {
    if (_subjectsService.selectedSubjects.value.length == 0) {
      Fluttertoast.showToast(msg: "No subject selected!");
      return;
    }
    _subjectsService.removeSelectedUserSubjects();
  }

  User user;
  PackageInfo packageInfo;

  AdmobService get admobService => _admobService;
  showTelgramDialog(BuildContext context) async {
    bool shouldShowTelegramDialog =
        await _sharedPreferencesService.shouldIShowTelegramDialog();
    if (shouldShowTelegramDialog) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                children: [
                  Text(
                    "Join us on telegram ",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                    height: 30,
                    width: 40,
                    child: ClipRRect(
                        child: Image.asset("assets/images/telegram-logo.png")),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _analyticsService.addTagInNotificationService(
                          key: "TELEGRAM", value: "VISITED");
                      launchURL("https://t.me/ounotes");
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "CLICK HERE TO JOIN",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          });
    }
  }

  dispatchEmail() async {
    await EmailService.emailFunc(
      subject: "OU Notes Feedback",
      body:
          "[if you are facing errors please attach Screen Shots or Screen Recordings]",
    );
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0, // Show rate popup on first day of install,
    minLaunches:
        3, // Show rate popup after 3 launches of app after minDays is passed.
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.notes.ounotes',
    appStoreIdentifier: 'com.notes.ounotes',
  );

  showRateMyAppDialog(BuildContext context) {
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showStarRateDialog(
          context,
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
                  if(stars==0)return;
                  if (stars < 3) {
                    dispatchEmail();
                  } else {
                    OpenAppstore.launch(
                        androidAppId: 'com.notes.ounotes',
                        iOSAppId: 'com.notes.ounotes');
                  }
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
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        );
      }
    });
  }

  Future<String> getUserEmail() async =>
      await _getUser().then((user) => user.email);

  Future<String> getUserId() async => await _getUser().then((user) => user.id);

  Future<User> _getUser() async {
    if (user == null) user = await _authenticationService.getUser();
    return user;
  }

  getPackageInfo() async {
    if (packageInfo == null) {
      packageInfo = await _appInfoService.getPackageInfo();
    }
  }

  showIntroDialog(BuildContext context) async {
    if (_subjectsService.userSubjects.value.length == 0) {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        //TODO DevChecklist - Dev feature to test intro, do not forget to remove
        // FeatureDiscovery.clearPreferences(context, <String>{
        //   OnboardingService.floating_action_button_to_add_subjects,
        //   OnboardingService.drawer_hamburger_icon_to_access_other_features,
        // });
        FeatureDiscovery.discoverFeatures(
          context,
          const <String>{
            // Feature ids for every feature that you want to showcase in order.
            OnboardingService.floating_action_button_to_add_subjects,
            OnboardingService.drawer_hamburger_icon_to_access_other_features,
          },
        );
      });
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // void updateNoteInFirebase(Note note) async {
  //   await _firestoreService.updateNoteInFirebase(note);
  // }

  // void updateQuestionPaperInFirebase(QuestionPaper paper) async {
  //   await _firestoreService.updateQuestionPaperInFirebase(paper);
  // }

  // void updateSyllabusInFirebase(Syllabus syllabus) async {
  //   await _firestoreService.updateSyllabusInFirebase(syllabus);
  // }

  // void addSubjectToFirebase(Subject subject) async {
  //   await _firestoreService.updateSubjectInFirebase(subject.toJson());
  // }

  // getNotesFromFirebase(Subject subject) async {
  //   var notes = await _firestoreService.loadNotesFromFirebase(subject.name);
  //   return notes;
  // }

  // getQuestionPapersFromFirebase(Subject subject) async {
  //   var notes =
  //       await _firestoreService.loadQuestionPapersFromFirebase(subject.name);
  //   return notes;
  // }

  // getSyllabusFromFirebase(Subject subject) async {
  //   var notes = await _firestoreService.loadSyllabusFromFirebase(subject.name);
  //   return notes;
  // }

}
