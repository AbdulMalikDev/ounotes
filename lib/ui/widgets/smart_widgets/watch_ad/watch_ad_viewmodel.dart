import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WatchAdToContinueViewModel extends BaseViewModel {
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  buyPremium() {
    _bottomSheetService.showCustomSheet(
      title: "OU Notes Premium",
      variant: BottomSheetType.premium,
    );
  }
}
