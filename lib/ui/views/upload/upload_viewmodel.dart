import 'dart:convert';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/enums/constants.dart' as enumConst;
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/models/user.dart';
import 'package:FSOUNotes/services/funtional_services/document_service.dart';
import 'package:FSOUNotes/services/funtional_services/firebase_firestore/firestore_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_drive/google_drive_service.dart';
import 'package:FSOUNotes/services/funtional_services/sharedpref_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadViewModel extends BaseViewModel {
  Logger log = getLogger("UploadViewModel");
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SubjectsService _subjectsService = locator<SubjectsService>();
  GoogleDriveService _googleDriveService = locator<GoogleDriveService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  DocumentService _documentService = locator<DocumentService>();

  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;

  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> _dropDownMenuItemForTypeYear;
  bool _isTermsAndConditionschecked = false;
  bool _canUseUploaderUserName = false;

  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;

  List<DropdownMenuItem<String>> get dropdownofyear =>
      _dropDownMenuItemForTypeYear;

  String _selectedSemester;
  String _selectedBranch;
  String _selectedyeartype;

  SfRangeValues _sfValues = SfRangeValues(2.0, 4.0);

  String _year = '2020';

  String get year => _year;
  SfRangeValues get sfValues => _sfValues;

  Document _documentType = Document.Notes;
  Document get documentType => _documentType;
  Map _textFieldsMap = Constants.Notes;

  Map get textFieldsMap => _textFieldsMap;

  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _controllerOfSub = TextEditingController();
  TextEditingController _controllerOfYear1 = TextEditingController();
  TextEditingController _controllerOfYear2 = TextEditingController();

  TextEditingController get textFieldController1 => _textFieldController1;
  TextEditingController get textFieldController2 => _textFieldController2;
  TextEditingController get textFieldController3 => _textFieldController3;
  TextEditingController get controllerOfSub => _controllerOfSub;
  TextEditingController get controllerOfYear1 => _controllerOfYear1;
  TextEditingController get controllerOfYear2 => _controllerOfYear2;

  set setDocumentType(Document selectedType) {
    _documentType = selectedType;
    _textFieldsMap = Constants.getTextFieldMapFromEnum(selectedType);
    notifyListeners();
  }

  set setYear(String year) {
    _year = year;
    notifyListeners();
  }

  set setSfValues(SfRangeValues values) {
    _sfValues = values;
    notifyListeners();
  }

  User _user = User();
  User get user => _user;
  String _document;
  String get document => _document;
  String get typeofyear => _selectedyeartype;
  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  bool get isTermsAndConditionsChecked => _isTermsAndConditionschecked;
  bool get canUseUploaderUserName => _canUseUploaderUserName;

  // set setDate(DateTime date) {
  //   if (date.year > DateTime.now().year) {
  //     _dialogService.showDialog(
  //         title: "ERROR", description: "Select Valid Date Please");
  //     return;
  //   }
  //   _year = date.year;
  //   notifyListeners();
  // }

  Future setUser() async {
    setBusy(true);
    SharedPreferences prefs = await _sharedPreferencesService.store();
    User user = User.fromData(
        json.decode(prefs.getString("current_user_is_logged_in")));

    _user = user;
    setBusy(false);
    notifyListeners();
  }

  List<String> getSuggestions(String query) {
    List<String> subList = getAllSubjectsList();
    log.e(subList);
    final List<String> suggestions = query.isEmpty
        ? []
        : subList
            .where((sub) => sub.toLowerCase().startsWith(query.toLowerCase()))
            .toList()
            .cast<String>();
    return suggestions;
  }

  List<String> getAllSubjectsList() {
    List<String> userSub = _subjectsService.userSubjects.value
        .map((sub) => sub.name)
        .toList()
        .cast<String>();
    List<String> allSub = _subjectsService.allSubjects.value
        .map((sub) => sub.name)
        .toList()
        .cast<String>();
    List<String> subList = userSub + allSub;
    subList = subList.toSet().toList().cast<String>();
    return subList;
  }

  initialise(Document uploadType, String subjectName) async {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semestersInNumbers);
    _dropDownMenuItemForTypeYear =
        buildAndGetDropDownMenuItems(CourseInfo.yeartype);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
    _selectedyeartype = _dropDownMenuItemForTypeYear[0].value;
    print("inside initialise function : uploadViewModel");
    print(uploadType);
    _documentType = uploadType ?? Document.Notes;
    _textFieldsMap = Constants.getTextFieldMapFromEnum(_documentType);
    if (subjectName != null) {
      controllerOfSub.text = subjectName;
    }
    await setUser();
    notifyListeners();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = [];
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Center(child: Text(item))));
    });
    return i;
  }

  void changedDropDownItemOfSemester(String selectedSemester) {
    _selectedSemester = selectedSemester;
    notifyListeners();
  }

  void changedDropDownItemOfBranch(String selectedBranch) {
    _selectedBranch = selectedBranch;
    notifyListeners();
  }

  void changedDropDownItemOfYear(selectedYearType) {
    _selectedyeartype = selectedYearType;
    notifyListeners();
  }

  void changeCheckMark(bool val) {
    _isTermsAndConditionschecked = val;
    notifyListeners();
  }

  ///Change [_canUseUploaderUserName] check mark field
  void changeCheckMark2(bool val) {
    _canUseUploaderUserName = val;
    notifyListeners();
  }

  navigatetoPrivacyPolicy() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  navigateToTermsAndConditionView() {
    _navigationService.navigateTo(Routes.termsAndConditionView);
  }

  Future handleUpload(String text1, String text2, String text3,
      String subjectName, BuildContext context) async {
    setBusy(true);
    Subject subject = await _firestoreService.getSubjectByName(subjectName);
    bool isUserUploadingSharedFile = false;

    AbstractDocument doc;
    SheetResponse response;
    doc = _setDoc(doc, documentType, text1, text2, text3, subjectName, subject);

    if (doc.path == Document.Links) {
      _processLink(doc);
      setBusy(false);
    } else {
      if (!isUserUploadingSharedFile)
        response = await _showDocTypeSelectionSheet();
      log.e(response);

      if (!isUserUploadingSharedFile && response == null) {
        log.e("No response from upload sheet");
        setBusy(false);
        return;
      }

      String fileType = (response?.confirmed ?? true)
          ? enumConst.Constants.pdf
          : enumConst.Constants.png;
      // var result = await _cloudStorageService.uploadFile(note: doc, type: doc.type, uploadFileType: fileType);
      var result = await _googleDriveService.processFile(
          doc: doc,
          docEnum: doc.path,
          note: doc,
          type: doc.type,
          uploadFileType: fileType);
      log.w(result);

      //* Handle upload result
      switch (result) {
        case "BLOCKED":
          await _showBannedDialog();
          setBusy(false);
          // return;
          break;
        case "File size more than 35mb":
          _showFileSizeExceededDialog(context);
          setBusy(false);
          // return;
          break;
        case "error":
          setBusy(false);
          Fluttertoast.showToast(
              msg: "An error occurred...please try again later");
          break;
        case "file is not pdf":
          await _showFileIsNotPdfDialog(context);
          setBusy(false);
          break;
        case "Upload Successful":
          setBusy(false);
          _navigationService.navigateTo(Routes.thankYouForUploadingView);
          break;
        case "Invalid document":
          setBusy(false);
          break;
        default:
          setBusy(false);
          // return;
          break;
      }
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  AbstractDocument _setDoc(
      AbstractDocument doc, path, text1, text2, text3, subjectName, subject) {
    String type;

    switch (path) {

      ///TODO malik use [_sfValue] which is number of units and [_canUseUploaderUserName] boolean value
      /// to set Notes data
      case Document.Notes:
        type = Constants.notes;
        doc = Note(
          subjectName: subjectName,
          path: Document.Notes,
          title: text1,
          author: text2,
          uploadDate: DateTime.now(),
          view: 0,
          type: type,
          subjectId: subject?.id,
        );
        break;
      case Document.QuestionPapers:
        type = Constants.questionPapers;
        doc = QuestionPaper(
          subjectName: subjectName,
          path: Document.QuestionPapers,
          title: "$_year",
          branch: _selectedBranch,
          year: "$_year",
          type: type,
          subjectId: subject?.id,
        );
        break;
      case Document.Syllabus:
        type = Constants.syllabus;
        doc = Syllabus(
          title: "$_selectedSemester$_selectedBranch",
          subjectName: subjectName,
          path: Document.Syllabus,
          type: type,
          semester: _selectedSemester,
          branch: _selectedBranch,
          year: _year.toString(),
          subjectId: subject?.id,
        );
        break;
      case Document.Links:
        type = Constants.links;
        doc = Link(
          subjectName: subjectName,
          title: text1,
          description: text2,
          linkUrl: text3,
          path: Document.Links,
          subjectId: subject?.id,
        );
        break;
      case Document.None:
      case Document.Drawer:
      case Document.UploadLog:
      case Document.Random:
      case Document.Report:
        break;
      case Document.UploadLog:
        break;
      case Document.Report:
        break;
    }
    return doc;
  }

  _showBannedDialog() async {
    await _dialogService.showDialog(
        title: "BANNED",
        description:
            "You have been banned by admins for uploading irrelevant content or reporting documents with no issue again and again. Use the feedback option in the drawer to contact the admins if you think this is a mistake");
  }

  void _showFileSizeExceededDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please compress the pdf",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "The file size has exceeded the limit of 35mb.You can use below link to compress the file",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Link :',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18),
                        ),
                        TextSpan(
                          text: "https://www.ilovepdf.com/compress_pdf",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL(
                                  "https://www.ilovepdf.com/compress_pdf");
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      "Go Back",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    child: Text(
                      "Open Link",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontSize: 17),
                    ),
                    onPressed: () {
                      launchURL("https://www.ilovepdf.com/compress_pdf");
                    }),
              ]);
        });
  }

  _showFileIsNotPdfDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Wrong file type",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please upload pdf file.You can use below link to convert your file to pdf",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Link :',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18),
                        ),
                        TextSpan(
                          text: "https://www.ilovepdf.com/word_to_pdf",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 18, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchURL("https://www.ilovepdf.com/word_to_pdf");
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      "Go Back",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    child: Text(
                      "Open Link",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontSize: 17),
                    ),
                    onPressed: () {
                      launchURL("https://www.ilovepdf.com/word_to_pdf");
                    }),
              ]);
        });
  }

  void _processLink(AbstractDocument doc) async {
    Link link = doc;
    log.e("link content");
    log.e(link.linkUrl);
    bool isValidURL = Uri.parse(link.linkUrl).isAbsolute;
    if (isValidURL) {
      await _firestoreService.saveLink(doc);
      await _dialogService.showDialog(
          title: "SUCCESS",
          description:
              "Thank you for sharing a resource with all the students ! Admins will review the link and display it in the app.");
      _navigationService.clearStackAndShow(Routes.splashView);
    } else {
      await _dialogService.showDialog(
          title: "Aww ! Wrong Link !",
          description:
              "Looks like the link format is not valid, make sure to copy and paste the exact link and not just the domain name. For example, \"google.com\" is not valid, \"https://google.com\" is a valid URL");
    }
  }

  Future<SheetResponse> _showDocTypeSelectionSheet() async {
    var result = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.filledStacks,
        title: "What do you want to upload?",
        description: "",
        mainButtonTitle: "PDF",
        secondaryButtonTitle: "Image",
        customData: {"file_upload": true});
    log.e(result);
    return result;
  }
}
