import 'dart:convert';

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/models/notes_view.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Logger log = getLogger("SharedPreferencesService");

  SharedPreferences _store;

  bool introDialog;
  bool telegramDialog;
  bool drawerIntro;
  String modeOfView;

  Future<SharedPreferences> store() async {
    if (_store == null) {
      _store = await SharedPreferences.getInstance();
    }
    return _store;
  }

  saveUserLocally(User user) async {
    SharedPreferences prefs = await store();
    log.i("User getting saved locally");
    prefs.setString("current_user_is_logged_in",
        json.encode(user.toJson(), toEncodable: myEncode));
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  Future<User> isUserLoggedIn() async {
    try {
      AuthenticationService _authenticationService =
          locator<AuthenticationService>();
      SharedPreferences prefs = await store();
      //Changed 20th November to force users to sign in again to log anaytics events
      if (!prefs.containsKey("current_user_is_logged_in")) {
        return null;
      } else {
        log.i("User retreived from storage");
        var user = User.fromData(
            json.decode(prefs.getString("current_user_is_logged_in")));
        if (user == null) {
          log.e("User is null");
          return null;
        }
        if (user.semester != null && user.branch != null) {
          // _authenticationService.setUser = user;
        } else {
          log.e("User branch semester is null");
          return null;
        }
        _authenticationService.setUser = user;
        return user;
      }
    } catch (e) {
      log.e(e.toString());
    }
    return null;
  }

  getModeOfView() async {
    SharedPreferences prefs = await this.store();
    if (!prefs.containsKey("modeofview")) {
      return null;
    }
    String modeofview = prefs.getString("modeofview");
    return modeofview;
  }

  updateView(String docId) async {
    SharedPreferences prefs = await this.store();
    //if notes_view is not present in the local storage then add the current view with docId with currTime
    if (!prefs.containsKey("notes_view")) {
      log.i("notes views not present in local storage");
      NotesView notesView =
          NotesView(time: DateTime.now().toString(), views: {docId: 1});
      prefs.setString("notes_view", jsonEncode(notesView.toJson()));
      return;
    }

    log.i("notes views present in local storage");
    //fetch notes_view from local storage
    Map<String, dynamic> data = jsonDecode(prefs.getString("notes_view"));
    NotesView notesView = NotesView.fromData(data);
    if (notesView.views.keys.contains(docId)) {
      notesView.views[docId]++;
    } else {
      notesView.views[docId] = 1;
    }

    DateTime startTime = DateTime.parse(notesView.time);

    Duration currStartTimediff = DateTime.now().difference(startTime);
    print(currStartTimediff.inDays);
    if (currStartTimediff.inHours > 24) {
      FirestoreService _firestoreService = locator<FirestoreService>();
      log.i("Updating views to server");
      //update views to the server
      notesView.views.forEach((docId, view) {
        if (view != 0) {
          //TODO
          // _firestoreService.incrementView(docId, view);
        }
        notesView.views[docId] = 0;
      });

      //update time
      notesView.time = DateTime.now().toString();
    }

    prefs.setString("notes_view", jsonEncode(notesView.toJson()));
  }

  loadSubjectsFromStorage() {}

  storeReport(List<Report> reports) async {
    SharedPreferences prefs = await this.store();

    prefs.setString(
        "reports", json.encode(reports.map((e) => e.toJson()).toList()));
  }

  loadReportsFromStorage() async {
    SharedPreferences prefs = await store();
    if (!prefs.containsKey("reports")) {
      return null;
    } else {
      List reportsLocal = json.decode(prefs.getString("reports"));
      List<Report> reports =
          reportsLocal.map((e) => Report.fromData(e)).toList();
      return reports;
    }
  }

  shouldIShowIntroDialog() async {
    if (introDialog != null) {
      if (introDialog == false) {
        return introDialog;
      }
    }
    SharedPreferences prefs = await store();
    if (prefs.containsKey("all_document_screen_dialog")) {
      introDialog = false;
    } else {
      await prefs.setBool("all_document_screen_dialog", true);
      introDialog = true;
    }
    return introDialog;
  }

  shouldIShowTelegramDialog() async {
    if (telegramDialog != null) {
      if (telegramDialog == false) {
        return telegramDialog;
      }
    }
    SharedPreferences prefs = await store();
    if (prefs.containsKey("telegram_dialog")) {
      telegramDialog = false;
    } else {
      await prefs.setBool("telegram_dialog", true);
      telegramDialog = true;
    }
    return telegramDialog;
  }

  Future<bool> shouldIShowDrawerIntro() async {
    if (drawerIntro != null) {
      if (drawerIntro == false) {
        return drawerIntro;
      }
    }
    SharedPreferences prefs = await store();
    if (prefs.containsKey("drawerIntro")) {
      drawerIntro = false;
    } else {
      await prefs.setBool("drawerIntro", true);
      drawerIntro = true;
    }
    return drawerIntro;
  }

  Future getUser() async {
    SharedPreferences prefs = await store();
    log.i("User trying to be retrieved from local storage");
    String userJson = prefs.getString("current_user_is_logged_in");
    if (userJson == null) {
      log.e("getUser - User is not present in local storage");
      return null;
    }
    User user = User.fromData(json.decode(userJson));
    return user;
  }
}

// //Utility Functions for Shared Preferences
// Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
//   Map<String, dynamic> newMap = {};
//   if (map.length > 0) {
//     map.forEach((key, value) {
//       newMap[key.toString()] = map[key];
//     });
//   }
//   return newMap;
// }

// Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
//   Map<DateTime, dynamic> newMap = {};
//   if (map.length > 0) {
//     map.forEach((key, value) {
//       newMap[DateTime.parse(key)] = map[key];
//     });
//   }
//   return newMap;
// }

// }
