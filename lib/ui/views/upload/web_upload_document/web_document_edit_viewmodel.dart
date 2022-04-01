import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/pdfWeb.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../misc/constants.dart';

class WebDocumentEditViewModel extends BaseViewModel {
  NavigationService _navigationService = locator<NavigationService>();
  DocumentService _documentService = locator<DocumentService>();

  Map _textFieldsMap = Constants.Notes;
  List<PdfWeb> _files = [];
  List<PdfWeb> get files => _files;

  Map get textFieldsMap => _textFieldsMap;
  List<AbstractDocument> _documents = [];
  List<AbstractDocument> get documents => _documents;

  void init(List<PdfWeb> files, Map textFieldsMap, AbstractDocument doc) {
    _textFieldsMap = textFieldsMap ?? Constants.Notes;
    _files = files;
    for (int i = 0; i < files.length; i++) {
      AbstractDocument newDoc = getDocumentObj(doc);
      _documents.add(newDoc);
    }
  }

  bool _isTermsAndConditionschecked = false;
  bool get isTermsAndConditionsChecked => _isTermsAndConditionschecked;

  AbstractDocument getDocumentObj(AbstractDocument doc) {
    String type = doc.type;
    if (type == Constants.notes) {
      Note currDoc = doc;
      Note newDoc = new Note(
        subjectName: currDoc.subjectName,
        path: currDoc.path,
        title: "",
        author: "",
        uploadDate: currDoc.uploadDate,
        view: 0,
        type: currDoc.type,
        subjectId: currDoc.subjectId,
      );
      return newDoc;
    } else if (type == Constants.questionPapers) {
      QuestionPaper currDoc = doc;
      QuestionPaper newDoc = new QuestionPaper(
        subjectName: currDoc.subjectName,
        path: currDoc.path,
        title: currDoc.title,
        uploadDate: currDoc.uploadDate,
        type: currDoc.type,
        subjectId: currDoc.subjectId,
        branch: currDoc.branch,
        year: currDoc.year,
      );
      return newDoc;
    } else {
      Syllabus currDoc = doc;
      Syllabus newDoc = new Syllabus(
        subjectName: currDoc.subjectName,
        path: currDoc.path,
        title: currDoc.title,
        uploadDate: currDoc.uploadDate,
        type: currDoc.type,
        subjectId: currDoc.subjectId,
        branch: currDoc.branch,
        year: currDoc.year,
      );
      return newDoc;
    }
  }

  void changeCheckMark(bool val) {
    _isTermsAndConditionschecked = val;
    notifyListeners();
  }

  navigatetoPrivacyPolicy() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  navigateToTermsAndConditionView() {
    _navigationService.navigateTo(Routes.termsAndConditionView);
  }

  void handleUpload() async {
    setBusy(true);
    Future.delayed(Duration(seconds: 1));
    notifyListeners();
    Map<AbstractDocument, PdfWeb> uploadDocMap = {};
    for (int i = 0; i < _documents.length; i++) {
      uploadDocMap[_documents[i]] = _files[i];
    }
    await _documentService.uploadAllDocumentsOnWeb(uploadDocMap);
    setBusy(false);
  }
}
