import 'dart:convert';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPreferencesService {
  Logger log = getLogger("SharedPreferencesService");

  SharedPreferences _store;

  bool introDialog;
  bool telegramDialog;

  Future<SharedPreferences> store() async {
    if (_store == null) {
      _store = await SharedPreferences.getInstance();
    }
    return _store;
  }

  saveUserLocally(User user) async {
    SharedPreferences prefs = await store();
    log.i("User saved locally");
    prefs.setString("current_user", json.encode(user.toJson()));
    log.e(user.googleSignInAuthHeaders);
    prefs.setString(
        "google_auth_header", json.encode(user.googleSignInAuthHeaders));
    log.e(json.decode(prefs.getString("google_auth_header")));
  }

  Future<bool> isUserLoggedIn() async {
    AuthenticationService _authenticationService =
        locator<AuthenticationService>();
    SharedPreferences prefs = await store();
    if (!prefs.containsKey("current_user_is_logged_in")) {
      return false;
    } else {
      log.i("User retreived from storage");
      var user = User.fromData(json.decode(prefs.getString("current_user")));
      if (user == null) {
        return false;
      }
      if (user.semester != null && user.branch != null) {
        _authenticationService.setUser = user;
      } else {
        return false;
      }

      return user.isAuth;
    }
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
