

import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

class CrashlyticsService{
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  init() async {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FirebaseCrashlytics.instance.setUserIdentifier(_authenticationService.user.id);
    }
  }

}