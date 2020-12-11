import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends BaseViewModel {
  AnalyticsService _analyticsService = locator<AnalyticsService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  AdmobService _admobService = locator<AdmobService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  ValueNotifier<List<Subject>> get userSubjects =>
      _subjectsService.userSubjects;
  ValueNotifier<List<Subject>> get allSubjects => _subjectsService.allSubjects;

  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

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

  showIntroDialog(BuildContext context) async {
    if (_subjectsService.userSubjects.value.length == 0) {
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        FeatureDiscovery.clearPreferences(context, <String>{ 
          OnboardingService.floating_action_button_to_add_subjects, 
          OnboardingService.drawer_hamburger_icon_to_access_other_features, 
        });
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

  void updateNoteInFirebase(Note note) async {
    await _firestoreService.updateNoteInFirebase(note);
  }

  void updateQuestionPaperInFirebase(QuestionPaper paper) async {
    await _firestoreService.updateQuestionPaperInFirebase(paper);
  }

  void updateSyllabusInFirebase(Syllabus syllabus) async {
    await _firestoreService.updateSyllabusInFirebase(syllabus);
  }

  void addSubjectToFirebase(Subject subject) async {
    await _firestoreService.updateSubjectInFirebase(subject.toJson());
  }

  getNotesFromFirebase(Subject subject) async {
    var notes = await _firestoreService.loadNotesFromFirebase(subject.name);
    return notes;
  }

  getQuestionPapersFromFirebase(Subject subject) async {
    var notes =
        await _firestoreService.loadQuestionPapersFromFirebase(subject.name);
    return notes;
  }

  getSyllabusFromFirebase(Subject subject) async {
    var notes = await _firestoreService.loadSyllabusFromFirebase(subject.name);
    return notes;
  }
}
