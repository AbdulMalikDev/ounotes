//*Path Enum for search bar to figure out where user came from to show appropriate results
enum Path {
  Appbar,
  Dialog,
}

enum Document {
  Notes,
  QuestionPapers,
  Syllabus,
  Links,
  Drawer,
  UploadLog,
  Report,
  None,
}

enum Menu {
  Report,
  Pin,
}

enum SubjectType{
  Main,
  Elective,
}

class Enums{

  // To serialize and deserialize enums from firebase
  static getSubjectTypeFromString(String statusAsString) {
    for (SubjectType element in SubjectType.values) {
      if (element.toString() == statusAsString) {
          return element;
      }
    }
    return null;
  }

}