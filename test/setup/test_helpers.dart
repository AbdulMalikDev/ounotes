import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/report_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/services/state_services/vote_service.dart';
import 'package:FSOUNotes/utils/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

class SharedPreferencesServiceMock extends Mock
    implements SharedPreferencesService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class AuthenticationServiceMock extends Mock implements AuthenticationService {}

class SubjectsServiceMock extends Mock implements SubjectsService {}

class DialogServiceMock extends Mock implements DialogService {}

class PermissionHandlerServiceMock extends Mock implements PermissionHandler {}

class FireStoreServiceMock extends Mock implements FirestoreService {}

class ReportServiceMock extends Mock implements ReportsService {}

class CloudStorageServiceMock extends Mock implements CloudStorageService {}

class VoteServiceMock extends Mock implements VoteServie {}

SharedPreferencesService getAndRegisterSharedPreferencesServiceMock(
    {bool isUserLoggedIn = true}) {
  _removeRegistrationIfExists<SharedPreferencesService>();
  var service = SharedPreferencesServiceMock();

  //Stubbing using mockito
  when(service.isUserLoggedIn())
      .thenAnswer((_) => Future.value(isUserLoggedIn));

  locator.registerSingleton<SharedPreferencesService>(service);
  return service;
}

FirestoreService getAndRegisterFirestoreServiceMock() {
  _removeRegistrationIfExists<FirestoreService>();
  var service = FireStoreServiceMock();

  //Stubbing using mockito
  locator.registerSingleton<FirestoreService>(service);
  return service;
}

CloudStorageService getAndRegisterCloudStorageServiceMock() {
  _removeRegistrationIfExists<CloudStorageService>();
  var service = CloudStorageServiceMock();

  //Stubbing using mockito
  locator.registerSingleton<CloudStorageService>(service);
  return service;
}

ReportsService getAndRegisterReportServiceMock() {
  _removeRegistrationIfExists<ReportsService>();
  var service = ReportServiceMock();

  //Stubbing using mockito
  locator.registerSingleton<ReportsService>(service);
  return service;
}

VoteServie getAndRegisterVoteServiceMock() {
  _removeRegistrationIfExists<VoteServie>();
  var service = VoteServiceMock();

  //Stubbing using mockito
  locator.registerSingleton<VoteServie>(service);
  return service;
}

NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  var service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

AuthenticationService getAndRegisterAuthenticationServiceMock() {
  _removeRegistrationIfExists<AuthenticationService>();
  var service = AuthenticationServiceMock();

  when(service.handleSignIn())
      .thenAnswer((realInvocation) => Future.value(true));

  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

SubjectsService getAndRegisterSubjectsServiceMock() {
  _removeRegistrationIfExists<SubjectsService>();
  var service = SubjectsServiceMock();
  service.setUserSubjects(new ValueNotifier(new List<Subject>()));
  locator.registerSingleton<SubjectsService>(service);
  return service;
}

DialogService getAndRegisterDialogServiceMock(
    {@required bool isUserConfirmedDialog}) {
  _removeRegistrationIfExists<DialogService>();
  var service = DialogServiceMock();

  when(service.showConfirmationDialog(
    title: "Are You Sure?",
    description:
        "Semester,Branch and College Name will be used to personalise this app",
    cancelTitle: "GO BACK",
    confirmationTitle: "PROCEED",
  )).thenAnswer((_) => Future.value(DialogResponse(confirmed: true)));

  when(service.showDialog()).thenAnswer((_) => Future.value());

  locator.registerSingleton<DialogService>(service);
  return service;
}

registerService() {
  getAndRegisterSharedPreferencesServiceMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterAuthenticationServiceMock();
  getAndRegisterSubjectsServiceMock();
  getAndRegisterDialogServiceMock(isUserConfirmedDialog: true);
  getAndRegisterPermissionHandlerServiceMock();
  getAndRegisterFirestoreServiceMock();
  getAndRegisterReportServiceMock();
  getAndRegisterCloudStorageServiceMock();
  getAndRegisterVoteServiceMock();
}

unRegisterServices() {
  locator.unregister<SharedPreferencesService>();
  locator.unregister<NavigationService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<SubjectsService>();
  locator.unregister<DialogService>();
  locator.unregister<PermissionHandler>();
  locator.unregister<FirestoreService>();
  locator.unregister<CloudStorageService>();
  locator.unregister<ReportsService>();
  locator.unregister<VoteServie>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

PermissionHandler getAndRegisterPermissionHandlerServiceMock() {
  _removeRegistrationIfExists<PermissionHandler>();
  var service = PermissionHandlerServiceMock();
  locator.registerSingleton<PermissionHandler>(service);
  return service;
}
