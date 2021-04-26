import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GenericSubjectTileViewModel extends BaseViewModel {
  Logger log = getLogger("UserSubjectListViewModel");
  NavigationService _navigationService = locator<NavigationService>();

  void onTap(subjectName) {
    _navigationService.replaceWith(Routes.allDocumentsView,
        arguments: AllDocumentsViewArguments(subjectName: subjectName));
  }
}
