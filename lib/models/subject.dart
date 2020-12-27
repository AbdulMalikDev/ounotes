import 'package:FSOUNotes/enums/enums.dart';

class Subject {
  int id;
  String name;
  Map<String, List<String>> branchToSem;
  bool userSubject = false;
  CourseType courseType;

  SubjectType type;

  // GDrive data
  String gdriveFolderID;
  String gdriveNotesFolderID;
  String gdriveQuestionPapersFolderID;
  String gdriveSyllabusFolderID;

  Subject.namedParameter({
    this.id,
    this.name,
    this.branchToSem,
  });
  Subject(
    this.id,
    this.name, {
    this.branchToSem,
    this.type = SubjectType.Main,
    this.courseType = CourseType.BE,
  });

  Subject.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        branchToSem = data['branchToSem'],
        gdriveFolderID = data['gdriveFolderID'] ?? "",
        gdriveNotesFolderID = data['gdriveNotesFolderID'] ?? "",
        gdriveQuestionPapersFolderID =
            data['gdriveQuestionPapersFolderID'] ?? "",
        gdriveSyllabusFolderID = data['gdriveSyllabusFolderID'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "branchToSem": branchToSem,
      "gdriveFolderID": gdriveFolderID,
      "gdriveNotesFolderID": gdriveNotesFolderID,
      "gdriveQuestionPapersFolderID": gdriveNotesFolderID,
      "gdriveSyllabusFolderID": gdriveNotesFolderID,
    };
  }

  addFolderID(String id) {
    this.gdriveFolderID = id;
  }

  addNotesFolderID(String id) {
    this.gdriveNotesFolderID = id;
  }

  addQuestionPapersFolderID(String id) {
    this.gdriveQuestionPapersFolderID = id;
  }

  addSyllabusFolderID(String id) {
    this.gdriveSyllabusFolderID = id;
  }
}
