import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:FSOUNotes/utils/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

class SharedPreferencesServiceMock extends Mock implements SharedPreferencesService {}
class NavigationServiceMock extends Mock implements NavigationService {}
class AuthenticationServiceMock extends Mock implements AuthenticationService {}
class SubjectsServiceMock extends Mock implements SubjectsService {}
class DialogServiceMock extends Mock implements DialogService {}
class PermissionHandlerServiceMock extends Mock implements PermissionHandler {}

SharedPreferencesService getAndRegisterSharedPreferencesServiceMock({bool isUserLoggedIn = true})
{
  _removeRegistrationIfExists<SharedPreferencesService>();
  var service = SharedPreferencesServiceMock();

  //Stubbing using mockito 
  when(service.isUserLoggedIn()).thenAnswer((_) => Future.value(new User()));

  locator.registerSingleton<SharedPreferencesService>(service);
  return service;
}

NavigationService getAndRegisterNavigationServiceMock()
{
  _removeRegistrationIfExists<NavigationService>();
  var service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;

}

AuthenticationService getAndRegisterAuthenticationServiceMock()
{
  _removeRegistrationIfExists<AuthenticationService>();
  var service = AuthenticationServiceMock();

  when(service.handleSignIn()).thenAnswer((realInvocation) => Future.value(true));

  locator.registerSingleton<AuthenticationService>(service);
  return service;

}

SubjectsService getAndRegisterSubjectsServiceMock()
{
  _removeRegistrationIfExists<SubjectsService>();
  var service = SubjectsServiceMock();
  service.setUserSubjects(new ValueNotifier(new List<Subject>()));
  locator.registerSingleton<SubjectsService>(service);
  return service;

}

DialogService getAndRegisterDialogServiceMock({@required bool isUserConfirmedDialog})
{
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


registerService()
{
  getAndRegisterSharedPreferencesServiceMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterAuthenticationServiceMock();
  getAndRegisterSubjectsServiceMock();
  getAndRegisterDialogServiceMock(isUserConfirmedDialog: true);
  getAndRegisterPermissionHandlerServiceMock();
}

unRegisterServices()
{
  locator.unregister<SharedPreferencesService>();
  locator.unregister<NavigationService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<SubjectsService>();
  locator.unregister<DialogService>();
  locator.unregister<PermissionHandler>();
}

void _removeRegistrationIfExists<T>() {
  if(locator.isRegistered<T>())
  {
    locator.unregister<T>();
  }
}









PermissionHandler getAndRegisterPermissionHandlerServiceMock()
{
  _removeRegistrationIfExists<PermissionHandler>();
  var service = PermissionHandlerServiceMock();
  locator.registerSingleton<PermissionHandler>(service);
  return service;

}
