// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/analytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/app_info_service.dart';
import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/third_party_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/crashlytics_service.dart';
import 'package:FSOUNotes/services/funtional_services/db_service.dart';
import 'package:FSOUNotes/services/state_services/download_service.dart';
import 'package:FSOUNotes/utils/file_picker_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive_service.dart';
import 'package:FSOUNotes/services/state_services/links_service.dart';
import 'package:FSOUNotes/services/state_services/notes_service.dart';
import 'package:FSOUNotes/utils/permission_handler.dart';
import 'package:FSOUNotes/services/funtional_services/push_notification_service.dart';
import 'package:FSOUNotes/services/state_services/question_paper_service.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/services/state_services/syllabus_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  g.registerLazySingleton<AdmobService>(() => AdmobService());
  g.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  g.registerLazySingleton<AppInfoService>(() => AppInfoService());
  g.registerLazySingleton<AppStateNotifier>(() => AppStateNotifier());
  g.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  g.registerLazySingleton<BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  g.registerLazySingleton<CloudStorageService>(() => CloudStorageService());
  g.registerLazySingleton<CrashlyticsService>(() => CrashlyticsService());
  g.registerLazySingleton<DBService>(() => DBService());
  g.registerLazySingleton<DialogService>(
      () => thirdPartyServicesModule.dialogService);
  g.registerLazySingleton<DownloadService>(() => DownloadService());
  g.registerLazySingleton<FilePickerService>(() => FilePickerService());
  g.registerLazySingleton<FirestoreService>(() => FirestoreService());
  g.registerLazySingleton<GoogleDriveService>(() => GoogleDriveService());
  g.registerLazySingleton<LinksService>(() => LinksService());
  g.registerLazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  g.registerLazySingleton<NotesService>(() => NotesService());
  g.registerLazySingleton<PermissionHandler>(() => PermissionHandler());
  g.registerLazySingleton<PushNotificationService>(
      () => PushNotificationService());
  g.registerLazySingleton<QuestionPaperService>(() => QuestionPaperService());
  g.registerLazySingleton<RemoteConfigService>(() => RemoteConfigService());
  g.registerLazySingleton<ReportsService>(() => ReportsService());
  g.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService());
  g.registerLazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  g.registerLazySingleton<SubjectsService>(() => SubjectsService());
  g.registerLazySingleton<SyllabusService>(() => SyllabusService());
  g.registerLazySingleton<VoteService>(() => VoteService(),);
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  BottomSheetService get bottomSheetService => BottomSheetService();
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}
