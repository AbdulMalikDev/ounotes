

import 'package:injectable/injectable.dart';
import 'package:sentry/sentry.dart';

@lazySingleton
class CrashlyticsService{

  SentryClient _sentryClient;


  SentryClient get sentryClient => _sentryClient;

  set sentryClient(client) => _sentryClient = client;
}