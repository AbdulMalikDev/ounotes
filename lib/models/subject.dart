class Subject{
  int id;
  String name;
  List semester;
  List branch;
  bool userSubject = false;
  
             

  Subject.namedParameter({this.id,this.name, this.semester, this.branch});
  Subject(this.id,this.name, this.semester, this.branch);

  Subject.fromData(Map<String,dynamic> data)
  : id           = data['id'],
    name         = data['name'],
    semester     = data['semester'] ,
    branch       = data['branch'];

  
  Map<String,dynamic> toJson() {
    return {
      "id"       : id,
      "name"     : name,
      "semester" : semester,
      "branch"   : branch,
    };
  }
}