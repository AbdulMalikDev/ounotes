import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/app/router.gr.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/enums/constants.dart' as enumConst;
import 'package:FSOUNotes/misc/course_info.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/subject.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:FSOUNotes/services/funtional_services/firestore_service.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadViewModel extends BaseViewModel {
  Logger log = getLogger("UploadViewModel");
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  SubjectsService _subjectsService = locator<SubjectsService>();

  List<DropdownMenuItem<String>> _dropDownMenuItemsofsemester;

  List<DropdownMenuItem<String>> _dropDownMenuItemsofBranch;
  List<DropdownMenuItem<String>> _dropDownMenuItemForTypeYear;
  bool _ischecked = false;

  List<DropdownMenuItem<String>> get dropdownofsem =>
      _dropDownMenuItemsofsemester;
  List<DropdownMenuItem<String>> get dropdownofbr => _dropDownMenuItemsofBranch;

  List<DropdownMenuItem<String>> get dropdownofyear =>
      _dropDownMenuItemForTypeYear;

  String _selectedSemester;
  String _selectedBranch;
  String _selectedyeartype;

  String _year = '2020';

  String get year => _year;

  set setYear(String year) {
    _year = year;
    notifyListeners();
  }

  String _document;
  String get document => _document;
  String get typeofyear => _selectedyeartype;
  String get sem => _selectedSemester;
  String get br => _selectedBranch;
  bool get ischecked => _ischecked;

  // set setDate(DateTime date) {
  //   if (date.year > DateTime.now().year) {
  //     _dialogService.showDialog(
  //         title: "ERROR", description: "Select Valid Date Please");
  //     return;
  //   }
  //   _year = date.year;
  //   notifyListeners();
  // }

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

  initialise(Document path) {
    _dropDownMenuItemsofBranch =
        buildAndGetDropDownMenuItems(CourseInfo.branch);
    _dropDownMenuItemsofsemester =
        buildAndGetDropDownMenuItems(CourseInfo.semestersInNumbers);
    _dropDownMenuItemForTypeYear =
        buildAndGetDropDownMenuItems(CourseInfo.yeartype);
    _selectedSemester = _dropDownMenuItemsofsemester[0].value;
    _selectedBranch = _dropDownMenuItemsofBranch[0].value;
    _selectedyeartype = _dropDownMenuItemForTypeYear[0].value;
    _document = Constants.getDocumentNameFromEnum(path);
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List items) {
    List<DropdownMenuItem<String>> i = List();
    items.forEach((item) {
      i.add(DropdownMenuItem(value: item, child: Text(item)));
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
    _ischecked = val;
    notifyListeners();
  }

  navigatetoPrivacyPolicy() {
    _navigationService.navigateTo(Routes.privacyPolicyView);
  }

  navigateToTermsAndConditionView() {
    _navigationService.navigateTo(Routes.termsAndConditionView);
  }

  Future handleUpload(String text1, String text2, String text3, Document path,
      String subjectName, BuildContext context) async {
    //* For all 4 upload screens , there are different text fields and
    //* their value may be different while uploading , so i have used switch case to
    //* handle all 4 situations
    setBusy(true);
    Subject subject = await _firestoreService.getSubjectByName(subjectName);
    String type;
    log.e("year $_year");
    AbstractDocument doc;
    switch (path) {
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
      case Document.Report:
        break;
      case Document.UploadLog:
        break;
      case Document.Report:
        break;
    }
    if (doc.path != Document.Links) {
      SheetResponse response = await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.filledStacks,
          title: "What do you want to upload?",
          description: "",
          mainButtonTitle: "PDF",
          secondaryButtonTitle: "Image",
          customData: {"file_upload": true});
      if (response == null) {
        setBusy(false);
        return;
      }
      String fileType = response.confirmed
          ? enumConst.Constants.pdf
          : enumConst.Constants.png;
      var result = await _cloudStorageService.uploadFile(
          note: doc, type: type, uploadFileType: fileType);
      log.w(result);
      if (result == "BLOCKED") {
        await _dialogService.showDialog(
            title: "BANNED",
            description:
                "You have been banned by admins for uploading irrelevant content or reporting documents with no issue again and again. Use the feedback option in the drawer to contact the admins if you think this is a mistake");
        setBusy(false);
        return;
      } else if (result == "File size more than 35mb") {
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
        setBusy(false);
        return;
      } else if (result == "File is null") {
        setBusy(false);
        return;
      } else if (result == 'error') {
        setBusy(false);
        Fluttertoast.showToast(
            msg: "An error occurred...please try again later");
      } else if (result == "upload successful") {
        setBusy(false);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Thank you for uploading ! The admins will verify if your uploaded document is relevant and it will be displayed in $subjectName.\n",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 18),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Uploading irrelevant information may result in a ban from the application",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 15),
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        "ok",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              );
            });
      } else if (result == 'file is not pdf') {
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
                                  launchURL(
                                      "https://www.ilovepdf.com/word_to_pdf");
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
        setBusy(false);
      }
    } else {
      Link link = doc;
      bool isValidURL = Uri.parse(link.linkUrl).isAbsolute;
      if (isValidURL) {
        await _firestoreService.saveLink(doc);
        await _dialogService.showDialog(
            title: "SUCCESS",
            description:
                "Thank you for sharing a resource with all the students ! Admins will review the link and display it in the app.");
        _navigationService
            .popUntil((route) => route.settings.name == Routes.homeViewRoute);
      } else {
        await _dialogService.showDialog(
            title: "Aww ! Wrong Link !",
            description:
                "Looks like the link format is not valid, make sure to copy and paste the exact link and not just the domain name. For example, \"google.com\" is not valid, \"https://google.com\" is a valid URL");
      }
      setBusy(false);
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
