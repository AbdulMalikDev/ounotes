import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FilterSubjectsViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  onTap(String subjectname, Document path) {
    _navigationService.navigateTo(
      Routes.fdDocumentView,
      arguments: FDDocumentViewArguments(
        subjectName: subjectname,
        path: path,
      ),
    );
  }
}
