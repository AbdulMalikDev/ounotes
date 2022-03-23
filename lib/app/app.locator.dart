// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../AppTheme/AppStateNotifier.dart';
import '../services/funtional_services/admob_service.dart';
import '../services/funtional_services/analytics_service.dart';
import '../services/funtional_services/app_info_service.dart';
import '../services/funtional_services/authentication_service.dart';
import '../services/funtional_services/cloud_functions_service.dart';
import '../services/funtional_services/cloud_storage_service.dart';
import '../services/funtional_services/crashlytics_service.dart';
import '../services/funtional_services/db_service.dart';
import '../services/funtional_services/document_service.dart';
import '../services/funtional_services/firebase_firestore/firestore_service.dart';
import '../services/funtional_services/google_drive/google_drive_service.dart';
import '../services/funtional_services/google_in_app_payment_service.dart';
import '../services/funtional_services/in_app_payment_service.dart';
import '../services/funtional_services/notification_service.dart';
import '../services/funtional_services/pdf_service.dart';
import '../services/funtional_services/push_notification_service.dart';
import '../services/funtional_services/remote_config_service.dart';
import '../services/funtional_services/sharedpref_service.dart';
import '../services/state_services/download_service.dart';
import '../services/state_services/links_service.dart';
import '../services/state_services/notes_service.dart';
import '../services/state_services/question_paper_service.dart';
import '../services/state_services/recently_opened_notes_service.dart';
import '../services/state_services/report_service.dart';
import '../services/state_services/subjects_service.dart';
import '../services/state_services/syllabus_service.dart';
import '../utils/file_picker_service.dart';
import '../utils/permission_handler.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => BottomSheetService());
  // locator.registerLazySingleton(() => AdmobService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => AppInfoService());
  locator.registerLazySingleton(() => AppStateNotifier());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => CrashlyticsService());
  locator.registerLazySingleton(() => DBService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => DownloadService());
  locator.registerLazySingleton(() => RecentlyOpenedNotesService());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => GoogleDriveService());
  locator.registerLazySingleton(() => GoogleInAppPaymentService());
  locator.registerLazySingleton(() => InAppPaymentService());
  locator.registerLazySingleton(() => LinksService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NotesService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => PermissionHandler());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => QuestionPaperService());
  locator.registerLazySingleton(() => RemoteConfigService());
  locator.registerLazySingleton(() => ReportsService());
  locator.registerLazySingleton(() => SharedPreferencesService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => SubjectsService());
  locator.registerLazySingleton(() => SyllabusService());
  locator.registerLazySingleton(() => PDFService());
  locator.registerLazySingleton(() => CloudFunctionsService());
  locator.registerLazySingleton(() => DocumentService());
}
