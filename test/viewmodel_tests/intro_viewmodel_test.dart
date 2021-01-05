import 'package:FSOUNotes/app/config_reader.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/ui/views/intro/intro_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data.dart';
import '../setup/test_helpers.dart';

void main() {
 group('IntroViewmodelTest -', (){

   setUp(() => registerService() );
    tearDown(() => unRegisterServices() );
    
   group('Handle Sign in -', () {
    test('When called, should attempt to sign in the user', () async  {
        await ConfigReader.initialize();
        var authService = getAndRegisterAuthenticationServiceMock();
        // var dialogService = getAndRegisterDialogServiceMock(isUserConfirmedDialog: true);
        // var navService = getAndRegisterNavigationServiceMock();
        // var model = IntroViewModel();
        // model.changedDropDownItemOfBranch(TestData.branch);
        // model.changedDropDownItemOfCollege(TestData.college);
        // model.changedDropDownItemOfSemester(TestData.semester);
        // await model.handleSignUp();
        verify(authService.handleSignIn(branch: TestData.branch,college: TestData.college ,semeseter: TestData.semester));
        
    });

    test('When called and user sign in process completed, should call replace route with Routes.spashViewRoute', () async {
        await ConfigReader.initialize();
        var dialogService = getAndRegisterDialogServiceMock(isUserConfirmedDialog: true);
        var navService = getAndRegisterNavigationServiceMock();
        var model = IntroViewModel();
        // model.changedDropDownItemOfBranch(TestData.branch);
        // model.changedDropDownItemOfCollege(TestData.college);
        // model.changedDropDownItemOfSemester(TestData.semester);
        // await model.handleSignUp();
        verify(navService.replaceWith(Routes.splashViewRoute));
    });
   });
 });
}