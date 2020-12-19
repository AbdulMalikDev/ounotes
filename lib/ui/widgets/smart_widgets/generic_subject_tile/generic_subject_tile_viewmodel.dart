import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GenericSubjectTileViewModel extends BaseViewModel {
  Logger log = getLogger("UserSubjectListViewModel");
  NavigationService _navigationService = locator<NavigationService>();

  void onTap(subjectName) {
    _navigationService.replaceWith(Routes.allDocumentsViewRoute,
        arguments: AllDocumentsViewArguments(subjectName: subjectName));
  }
}
