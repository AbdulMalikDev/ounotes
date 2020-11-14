class Subject{
  int id;
  String name;
  List semester;
  List branch;
  bool userSubject = false;
  
             
  // GDrive data
  String gdriveFolderID;
  String gdriveNotesFolderID;

  Subject.namedParameter({this.id,this.name, this.semester, this.branch});
  Subject(this.id,this.name, this.semester, this.branch);

  Subject.fromData(Map<String,dynamic> data)
  : id                        = data['id'],
    name                      = data['name'],
    semester                  = data['semester'] ,
    branch                    = data['branch'],
    gdriveFolderID            = data['gdriveFolderID'] ?? "",
    gdriveNotesFolderID       = data['gdriveNotesFolderID'] ?? "";

  
  Map<String,dynamic> toJson() {
    return {
      "id"                    : id,
      "name"                  : name,
      "semester"              : semester,
      "branch"                : branch,
      "gdriveFolderID"        : gdriveFolderID,
      "gdriveNotesFolderID"   : gdriveNotesFolderID,
    };
  }

  addFolderID(String id){
    this.gdriveFolderID = id;
  }
  addNotesFolderID(String id){
    this.gdriveNotesFolderID = id;
  }
}