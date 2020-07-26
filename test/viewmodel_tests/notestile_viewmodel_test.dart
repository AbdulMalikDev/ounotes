import 'package:FSOUNotes/ui/views/notes/notes_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/notes_tile/notes_tile_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../setup/test_helpers.dart';

void main() {
  group('NotestileViewmodelTest -', () {
    setUp(() => registerService() );
    tearDown(() => unRegisterServices() );
    group('Voting', () {
      test('When user pressed upvotes ,vote should be increased by 1', () {
        var model = NotesTileViewModel();
        model.incrementvotes(1);
        expect(model.noofvotes, 1);
      });
      test('When user pressed downvotes ,vote should be decremented by 1', () {
        var model = NotesTileViewModel();
        model.decrementvotes(1);
        expect(model.noofvotes, -1);
      });
    });
  });
}
