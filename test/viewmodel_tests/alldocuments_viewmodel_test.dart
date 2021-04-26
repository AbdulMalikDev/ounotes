import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/ui/views/all_documents/all_documents_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data.dart';
import '../setup/test_helpers.dart';

void main() {
 group('AlldocumentsViewmodelTest -', (){

    setUp(() => registerService() );
    tearDown(() => unRegisterServices() );

    group('General -', () {
     test('When upload button pressed, should navigate to upload screen', () {
       var navService = getAndRegisterNavigationServiceMock();
       var permissionhandler = getAndRegisterPermissionHandlerServiceMock();
       var model = AllDocumentsViewModel();
       model.subjectName = TestData.subjectName;
       model.onUploadButtonPressed();
       verify(navService.navigateTo(Routes.uploadSelectionView,arguments:isA<UploadSelectionViewArguments>(),id: null));
     });
    });
 });
}