class Report {
  final String id;
  final String subjectName;
  final String type;
  final String title;
  final String email;

  Report(this.id, this.subjectName, this.type, this.title , this.email);

  
  Report.fromData(Map<String,dynamic> data)
  : id              = data['id'],
    subjectName     = data['subjectName'],
    type            = data['type'],
    title           = data['title'],
    email           = data['email'];


  Map<String,dynamic> toJson() {
    return {
      "id"          : id,
      "subjectName" : subjectName,
      "type"        : type,
      "title"       : title,
      "email"       : email,
    };
  }

}