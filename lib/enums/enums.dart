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
  Random,
}

enum Menu {
  Report,
  Pin,
}

enum SubjectType{
  Main,
  Elective,
}

enum CourseType{
  BE,
}

class Enum{

  // To serialize and deserialize enums from firebase
  static getSubjectTypeFromString(String statusAsString) {
    if(statusAsString == null)return null;
    
    for (SubjectType element in SubjectType.values) {
      if (element.toString() == statusAsString) {
          return element;
      }
    }
    return null;
  }
  static getCourseTypeFromString(String courseTypeAsString) {
    if(courseTypeAsString == null)return null;

    for (CourseType element in CourseType.values) {
      if (element.toString() == courseTypeAsString) {
          return element;
      }
    }
    return null;
  }
  static getDocumentFromString(String documentAsString) {
    if(documentAsString == null)return null;

    for (Document element in Document.values) {
      if (element.toString() == documentAsString) {
          return element;
      }
    }
    return null;
  }

}
