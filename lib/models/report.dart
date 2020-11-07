class Report {
  String id;
  String subjectName;
  String type;
  String title;
  String email;
  DateTime date;
  int reports;

  Report(this.id, this.subjectName, this.type, this.title , this.email);

  
  Report.fromData(Map<String,dynamic> data)
  {

    id              = data['id'];
    subjectName     = data['subjectName'];
    type            = data['type'];
    title           = data['title'];
    email           = data['email'];
    reports         = data["reports"] ?? 0;
    date            = _parseUploadDate(data["date"]);
  }


  Map<String,dynamic> toJson() {
    return {
      "id"          : id,
      "subjectName" : subjectName,
      "type"        : type,
      "title"       : title,
      "email"       : email,
      "reports"     : reports,
      "date"        : date
    };
  }

   DateTime _parseUploadDate(date) {
    return DateTime.parse(date.toDate().toString());
  }

}