import 'package:FSOUNotes/enums/enums.dart';
import 'package:flutter/material.dart';

class Constants {
  //These are cloud storage constants so as to not mess up the URL while Uploading
  static const String notes = "Notes";
  static const String questionPapers = "Question Papers";
  static const String syllabus = "Syllabus";
  static const String links = "Links";
  static const String uploadLog = "Upload Log";
  static const String report = "Report";
  static const String userStats = "user_stats";
  static const String openInBrowser = 'openInBrowser';
  static const String openInApp = 'openInApp';

  //firebase collection names
  static const String firebase_notes = "Notes";
  static const String firebase_questionPapers = "QuestionPapers";
  static const String firebase_syllabus = "Syllabus";
  static const String firebase_links = "Links";

  //file extension names
  static const String pdf = 'pdf';
  static const String png = 'png';
  static const String jpeg = 'jpeg';
  static const String jpg = 'jpg';

  //images path
  static const String appIcon = "assets/images/apnaicon.png";
  static const String adminImage = "assets/images/admin.jpg";
  static const String githubIcon = "assets/images/github-logo.png";
  static const String donateIcon = "assets/images/donate-icon.png";
  static const String pdfIcon = "assets/images/pdf.png";

  //Hive Box Names
  static const String ouNotes = "OUNOTES";
  static const String notesDownloads = "NotesDownloads";
  static const String questionPaperDownloads = "QuestionPaperDownloads";
  static const String syllabusDownloads = "SyllabusDownloads";
  static const String recentlyOpenedNotes = "recentlyOpenedNotes";

  //Notification Events [ Make sure Cloud Functions file has same constants ]
  static const String notificationEventNotesUpload =
      "notificationEventNotesUpload";
  static const String notificationEventGrantVerifierAccess =
      "notificationEventGrantVerifierAccess";

  static TextStyle kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  static TextStyle kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  static BoxDecoration kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  //* making fields null so that null checks can be performed
  //* and displayed accordingly in views
  static Map Notes = {
    "TextFieldHeading1": "Name",
    "TextFieldHeadingLabel1": "Unit 1...",
    "TextFieldHeading2": "Author",
    "TextFieldHeadingLabel2": "Sameer...",
    "TextFieldHeading3": null,
    "TextFieldHeadingLabel3": null,
  };
  static Map EditNotes = {
    "TextFieldHeading1": "Name",
    "TextFieldHeadingLabel1": "Unit 1...",
    "TextFieldHeading2": "Author",
    "TextFieldHeadingLabel2": "Sameer...",
    "TextFieldHeading3": "Views",
    "TextFieldHeadingLabel3": "0",
    "TextFieldHeading4": "Votes",
    "TextFieldHeadingLabel4": "0",
  };
  static Map Syllabus = {
    "TextFieldHeading1": "Semester",
    "TextFieldHeadingLabel1": "Any number between 1-8",
    "TextFieldHeading2": "Branch",
    "TextFieldHeadingLabel2": "CSE , ECE .....",
    "TextFieldHeading3": "Year",
    "TextFieldHeadingLabel3": "2020...",
    "TextFieldHeading4": null,
    "TextFieldHeadingLabel4": null,
  };

  static Map QuestionPaper = {
    "TextFieldHeading1": "Year",
    "TextFieldHeadingLabel1": "2020...",
    "TextFieldHeading2": "Branch",
    "TextFieldHeadingLabel2": "CSE , ECE .....",
    "TextFieldHeading3": null,
    "TextFieldHeadingLabel3": null,
    "TextFieldHeading4": null,
    "TextFieldHeadingLabel4": null,
  };

  static Map Links = {
    "TextFieldHeading1": "Title",
    "TextFieldHeadingLabel1": "...",
    "TextFieldHeading2": "Description",
    "TextFieldHeadingLabel2": "...",
    "TextFieldHeading3": "URL",
    "TextFieldHeadingLabel3": "...",
    "TextFieldHeading4": null,
    "TextFieldHeadingLabel4": null,
  };

  static Map<int, String> semlist = {
    1: "Semester 1",
    2: "Semester 2",
    3: "Semester 3",
    4: "Semester 4",
    5: "Semester 5",
    6: "Semester 6",
    7: "Semester 7",
    8: "Semester 8"
  };

  static getDocumentNameFromEnum(Document doc) {
    switch (doc) {
      case Document.Notes:
        return notes;
        break;
      case Document.QuestionPapers:
        return questionPapers;
        break;
      case Document.Syllabus:
        return syllabus;
        break;
      case Document.Links:
        return links;
        break;
      case Document.UploadLog:
        return uploadLog;
        break;
      case Document.Report:
        return report;
        break;
      case Document.None:
      case Document.Drawer:
      case Document.Random:
        return "";
        break;
    }
  }

  static BoxDecoration defaultDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(width: 0.3, color: Colors.black26),
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 0),
        color: Colors.black,
        spreadRadius: -10,
        blurRadius: 14,
      )
    ],
  );

  static BoxDecoration kdecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(32),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  static BoxDecoration mdecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  static getConstantFromDoc(Document document) {
    switch (document) {
      case Document.Notes:
        return Constants.notes;
        break;
      case Document.QuestionPapers:
        return Constants.questionPapers;
        break;
      case Document.Syllabus:
        return Constants.syllabus;
        break;
      case Document.Links:
        return Constants.links;
        break;
      case Document.Report:
        return Constants.report;
        break;
      case Document.UploadLog:
        return Constants.uploadLog;
        break;
      default:
        break;
    }
  }

  static getDocFromConstant(String constant) {
    switch (constant) {
      case Constants.notes:
        return Document.Notes;
        break;
      case Constants.questionPapers:
        return Document.QuestionPapers;
        break;
      case Constants.syllabus:
        return Document.Syllabus;
        break;
      case Constants.links:
        return Document.Links;
        break;
      default:
        break;
    }
  }
}

//DO NOT DELETE THIS
// @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ReportViewModel>.reactive(
//       builder: (context, model, child) => Scaffold(),
//       viewModelBuilder:() => ReportViewModel(),
//     );
//   }
