import 'package:FSOUNotes/app/logger.dart';
import 'package:logger/logger.dart';

Logger log = getLogger("Report");
class Report {
  String id;
  String subjectName;
  String type;
  String title;
  String email;
  DateTime date;
  int reports;
  String reporter_id;
  bool notificationSent = false;

  Report(this.id, this.subjectName, this.type, this.title , this.email);

  
  Report.fromData(Map<String,dynamic> data)
  {

    try {

      id                      = data['id'];
      subjectName             = data['subjectName'];
      type                    = data['type'];
      title                   = data['title'];
      email                   = data['email'];
      reports                 = data["reports"] ?? 0;
      date                    = _parseUploadDate(data["date"]);
      reporter_id             = data["reporter_id"];
      notificationSent        = data["notificationSent"] ?? false;
    
    } on Exception catch (e) {
          log.e("Error while DESERIALIZING report from firebase ${e.toString()}");
    }
  }


  Map<String,dynamic> toJson() {
    return {
      "id"                      : id,
      "subjectName"             : subjectName,
      "type"                    : type,
      "title"                   : title,
      "email"                   : email,
      "reports"                 : reports,
      "date"                    : date,
      "notificationSent"       : notificationSent,
    };
  }

  set setNotificationSent(bool isNotificationSent) => this.notificationSent = isNotificationSent;

   DateTime _parseUploadDate(date) {
    return DateTime.parse(date.toDate().toString());
  }

}