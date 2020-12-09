import 'package:FSOUNotes/enums/enums.dart';
import 'package:flutter/material.dart';

const Color primary = Color(0xff5177d6);
const Color secondary = Color(0xffFFB800);
const Color ternary = Color(0xffFF8282);
const Color count_red = Color(0xffFF5F5F);
const Color difficulty_hard = Color(0xffFF6D6D);
const Color difficulty_medium = Color(0xffFFD600);
const Color difficulty_easy = Color(0xff6CCFA8);

//Default Text Styles
//styles used for drawer
const TextStyle listTitleDefaultTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.03,
    fontFamily: 'Montserrat');

//styles used for screens
const TextStyle defaultTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontWeight: FontWeight.normal,
  letterSpacing: -0.03,
  fontFamily: 'Montserrat',
);

class Constants {
  //These are cloud storage constants so as to not mess up the URL while Uploading
  static String notes = "Notes";
  static String questionPapers = "Question Papers";
  static String syllabus = "Syllabus";
  static String links = "Links";
  static String none = 'none';
  static String upvote = 'upvote';
  static String downvote = 'downvote';
  static TextStyle kHintTextStyle = TextStyle(
    color: Colors.grey,
  );

  static TextStyle kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  static BoxDecoration kBoxDecorationStyle = BoxDecoration(
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

  //* making fields null so that null checks can be performed
  //* and displayed accordingly in views
  static Map Notes = {
    "TextFieldHeading1": "Notes Title",
    "TextFieldHeadingLabel1": "Unit 1...",
    "TextFieldHeading2": "Author",
    "TextFieldHeadingLabel2": "Sameer...",
    "TextFieldHeading3": null,
    "TextFieldHeadingLabel3": null,
  };
  static Map Syllabus = {
    "TextFieldHeading1": "Semester",
    "TextFieldHeadingLabel1": "Any number between 1-8",
    "TextFieldHeading2": "Branch",
    "TextFieldHeadingLabel2": "CSE , ECE .....",
    "TextFieldHeading3": "Year",
    "TextFieldHeadingLabel3": "2020...",
  };

  static Map QuestionPaper = {
    "TextFieldHeading1": "Year",
    "TextFieldHeadingLabel1": "2020...",
    "TextFieldHeading2": "Branch",
    "TextFieldHeadingLabel2": "CSE , ECE .....",
    "TextFieldHeading3": null,
    "TextFieldHeadingLabel3": null,
  };

  static Map Links = {
    "TextFieldHeading1": "Link Title",
    "TextFieldHeadingLabel1": "...",
    "TextFieldHeading2": "Description",
    "TextFieldHeadingLabel2": "...",
    "TextFieldHeading3": "URL",
    "TextFieldHeadingLabel3": "...",
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
      case Document.None:
      case Document.Drawer:
      case Document.UploadLog:
      case Document.Report:
        return "";
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
