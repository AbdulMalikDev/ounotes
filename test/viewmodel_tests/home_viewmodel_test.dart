import 'dart:js';

import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/ui/views/home/home_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data.dart';
import '../setup/test_helpers.dart';

void main() {
 group('HomeViewmodelTest -', (){

   
    setUp(() => registerService() );
    tearDown(() => unRegisterServices() );

   group('Initialize -', () {
    test('When called, should show welcome dialog', () async {
      var dialogService = getAndRegisterDialogServiceMock(isUserConfirmedDialog: true);
      var model = HomeViewModel();
      when(model.userSubjects).thenReturn(new ValueNotifier(new List<Subject>()));
      await model.showIntroDialog(null);
      verify(dialogService.showDialog(title: TestData.welcomeDialogTitle,description: TestData.welcomeDialogDescription));
    });
   });
 });
}