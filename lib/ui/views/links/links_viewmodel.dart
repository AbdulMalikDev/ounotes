import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';

class LinksViewModel extends BaseViewModel {
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<Link> _links = [];
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  NavigationService _navigationService = locator<NavigationService>();

  List<Link> get linksList => _links;
  bool isloading = false;
  bool get loading => isloading;

  setLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  Future fetchLinks(String subjectName) async {
    setBusy(true);
    _links = await _firestoreService.loadLinksFromFirebase(subjectName);
    notifyListeners();
    setBusy(false);
  }

  void onTap({
    Link note,
    String notesName,
    String subName,
    String type,
  }) async {
    setLoading(true);
    String PDFpath = await _cloudStorageService.downloadFile(
      notesName: notesName,
      subName: subName,
      type: type,
      note: note,
    );
    setLoading(false);
    _navigationService.navigateTo(Routes.pdfScreenRoute,
        arguments: PDFScreenArguments(pathPDF: PDFpath, title: notesName));
  }

  // @override
  // Future futureToRun() =>fetchNotes();

}
