import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';import 'package:FSOUNotes/ui/views/splash/splash_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_helpers.dart';

void main() {
 group('SplashViewmodelTest -', (){

    setUp(() => registerService() );
    tearDown(() => unRegisterServices() );

   group('initialize -', () {
    test('When called should check if User is logged in', () async {
      var sharedPref = getAndRegisterSharedPreferencesServiceMock();
      var model = SplashViewModel();
      model.handleStartUpLogic();
      verify(sharedPref.isUserLoggedIn());
    });

     test('When called and User is logged in, should call replace route with Routes.homeViewRoute', () async {
       var navigationService = getAndRegisterNavigationServiceMock();
       var model = SplashViewModel();
       await model.handleStartUpLogic();
       verify(navigationService.replaceWith(Routes.homeView));
     });

     test('When called and User is not logged in, should call replace route with Routes.introViewRoute [login page]', () async {
       var navigationService = getAndRegisterNavigationServiceMock();
       var model = SplashViewModel();
       await model.handleStartUpLogic();
       verify(navigationService.replaceWith(Routes.introView));
     });
   });
 });
}