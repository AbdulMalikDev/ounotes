

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsService{

  final FirebaseAnalytics analytics = FirebaseAnalytics();
  

  void logEvent({String name,Map parameters}) async {
    if (parameters == null)
    {
      analytics.logEvent(name: name);
    }else{
      analytics.logEvent(name: name,parameters: parameters);
    }
  }

  void setUserProperty({String name, String value}) {
    analytics.setUserProperty(name: name, value: value);
  }
  
}