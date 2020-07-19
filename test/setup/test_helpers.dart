import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/services/funtional_services/authentication_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

class SharedPreferencesServiceMock extends Mock implements SharedPreferencesService {}
class NavigationServiceMock extends Mock implements NavigationService {}
class AuthenticationServiceMock extends Mock implements AuthenticationService {}
class SubjectsServiceMock extends Mock implements SubjectsService {}

SharedPreferencesService getAndRegisterSharedPreferencesServiceMock({bool isUserLoggedIn = true})
{
  _removeRegistrationIfExists<SharedPreferencesService>();
  var service = SharedPreferencesServiceMock();

  //Stubbing using mockito 
  when(service.isUserLoggedIn()).thenAnswer((_) => Future.value(isUserLoggedIn));

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
  locator.registerSingleton<AuthenticationService>(service);
  return service;

}

SubjectsService getAndRegisterSubjectsServiceMock()
{
  _removeRegistrationIfExists<SubjectsService>();
  var service = SubjectsServiceMock();
  locator.registerSingleton<SubjectsService>(service);
  return service;

}


registerService()
{
  getAndRegisterSharedPreferencesServiceMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterAuthenticationServiceMock();
  getAndRegisterSubjectsServiceMock();
}

unRegisterServices()
{
  locator.unregister<SharedPreferencesService>();
  locator.unregister<NavigationService>();
  locator.unregister<AuthenticationService>();
  locator.unregister<SubjectsService>();
}

void _removeRegistrationIfExists<T>() {
  if(locator.isRegistered<T>())
  {
    locator.unregister<T>();
  }
}