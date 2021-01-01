import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:logger/logger.dart';
Logger log = getLogger("Subject.dart");

class Subject {
  int id;
  String name;
  Map<String, List<String>> branchToSem;
  bool userSubject = false;
  CourseType courseType;

  SubjectType subjectType;

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
    this.subjectType = SubjectType.Main,
    this.courseType = CourseType.BE,
  });

  Subject.fromData(Map<String, dynamic> data) {
        
      try{ 
        id                           = data['id'];
        name                         = data['name'].toString();
        branchToSem                  = _deserializeBranchToSem(data['branchToSem']);
        gdriveFolderID               = data['gdriveFolderID'];
        gdriveNotesFolderID          = data['gdriveNotesFolderID'];
        gdriveQuestionPapersFolderID = data['gdriveQuestionPapersFolderID'];
        gdriveSyllabusFolderID       = data['gdriveSyllabusFolderID'];
        subjectType                  = Enum.getSubjectTypeFromString(data['subjectType']) ?? SubjectType.Main;
        courseType                   = Enum.getCourseTypeFromString(data['courseType']) ?? CourseType.BE;
      }catch(e){
        log.e("Error while deserializing subject object");
        log.e(e.toString());
      }
  }

  _deserializeBranchToSem(data){
      if(data==null){return null;}
      Map<String,dynamic> receivedData = data;
      Map<String,List<String>> branchToSemMap = {"test":[]};
      receivedData.forEach((key, value) { 
        branchToSemMap.addAll({key : new List<String>.from(value)});
      });
      return branchToSemMap;
  }
        

  Map<String, dynamic> toJson() {
    return {
         "id"                                                             : id,
         "name"                                                           : name,
      if(branchToSem!=null)"branchToSem"                                  : branchToSem,
      if(gdriveFolderID!=null)"gdriveFolderID"                            : gdriveFolderID,
      if(gdriveNotesFolderID!=null)"gdriveNotesFolderID"                  : gdriveNotesFolderID,
      if(gdriveQuestionPapersFolderID!=null)"gdriveQuestionPapersFolderID": gdriveQuestionPapersFolderID,
      if(gdriveSyllabusFolderID!=null)"gdriveSyllabusFolderID"            : gdriveSyllabusFolderID,
      if(subjectType!=null)"subjectType"                                  : subjectType.toString(),
      if(courseType!=null)"courseType"                                    : courseType.toString(),
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
