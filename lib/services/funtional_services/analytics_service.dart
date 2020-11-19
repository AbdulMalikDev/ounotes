

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsService{

  final FirebaseAnalytics analytics = FirebaseAnalytics();
  
}