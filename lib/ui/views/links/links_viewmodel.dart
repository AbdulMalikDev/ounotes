import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';

class LinksViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Link> _links = [];
  List<Link> get linksList => _links;

  Future fetchLinks(String subjectName) async {
    setBusy(true);
    _links = await _firestoreService.loadLinksFromFirebase(subjectName);
    notifyListeners();
    setBusy(false);
  }
}
