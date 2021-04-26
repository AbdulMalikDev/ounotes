

import 'package:sentry/sentry.dart';

class CrashlyticsService{

  SentryClient _sentryClient;


  SentryClient get sentryClient => _sentryClient;

  set sentryClient(client) => _sentryClient = client;
}