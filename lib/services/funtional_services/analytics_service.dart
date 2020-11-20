

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class AnalyticsService{

  final FirebaseAnalytics analytics = FirebaseAnalytics();
  

  void logEvent({String name,Map parameters,bool addInNotificationService=false}) async {
    if (parameters == null)
    {
      analytics.logEvent(name: name);
    }else{
      analytics.logEvent(name: name,parameters: parameters);
    }

    if (addInNotificationService && (parameters!=null)){
      OneSignal.shared.sendTags(parameters);
    }
  }

  void setUserProperty({String name, String value}) {
    analytics.setUserProperty(name: name, value: value);
  }
  
}