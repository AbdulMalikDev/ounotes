import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FilterSubjectsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  onTap(String subjectname, Document path) {
    _navigationService.navigateTo(
      Routes.fDDocumentView,
      arguments: FDDocumentViewArguments(
        subjectName: subjectname,
        path: path,
      ),
    );
  }
}
