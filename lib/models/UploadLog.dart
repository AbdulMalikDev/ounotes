
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/models/report.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class UploadLog {
  Logger log = getLogger("UploadLog");
  String id;
  String subjectName;
  String type;
  String fileName;
  DateTime date;
  String size;
  String email;
  String uploader_id;
  String uploader_name;
  bool notificationSent = false;
  bool isReport = false;
  bool isPassed = false;

  //Addition info or comments from verifiers to be viewed by admin
  String additionalInfo;
  List additionalInfoFromVerifiers;

  bool isVerifierVerified = false;
  // If uploaded by Verifier wont show to admins
  bool isUploadedByVerifier;

  String verifier_id;

  bool isAdminVerified = false;

  UploadLog(
      {this.id,
      this.subjectName,
      this.isVerifierVerified,
      this.type,
      this.fileName,
      this.date,
      this.size,
      this.email});

  UploadLog.fromData(Map<String, dynamic> data) {
    try {

      fileName                    = data["fileName"] ?? "";
      subjectName                 = data['subjectName'].toString();
      id                          = data['id'].toString() ?? "";
      type                        = data["type"].toString();
      email                       = data["email"].toString();
      size                        = data["size"].toString() ?? "0";
      uploader_id                 = data["uploader_id"];
      verifier_id                 = data["verifier_id"];
      uploader_name               = data["uploader_name"];
      additionalInfoFromVerifiers = data["additionalInfoFromVerifiers"];
      notificationSent            = data["notificationSent"] ?? false;
      isVerifierVerified          = data["isVerifierVerified"] ?? false;
      isAdminVerified             = data["isAdminVerified"] ?? false;
      isReport             = data["isReport"] ?? false;
      isPassed             = data["isPassed"] ?? false;
      log.e(isReport);
      date                        = data["uploadedAt"]!=null ? _parseUploadDate(data["uploadedAt"]) : null;
    } catch (e) {
      log.e("While DESERIALIZING uploadLog model from Firebase , Error occurred");
      String error;
      if (e is PlatformException) error = e.message;
      error = e.toString();
      log.e(error);
    }
  }

  UploadLog.fromReport(Report report){
    id = report.id;
    subjectName = report.subjectName;
    type = report.type;
    uploader_id = report.reporter_id;
    email = report.email;
    fileName = report.title;
    isReport = true;
  }

  Map<String, dynamic> toJson() {
    return {
      "fileName"                   : fileName,
      "subjectName"                : subjectName,
      "email"                      : email,
      "type"                       : type,
      "id"                         : id,
      "uploader_id"                : uploader_id,
      "verifier_id"                : verifier_id,
      "uploader_name"              : uploader_name,
      "uploadedAt"                 : date,
      "size"                       : size??"0",
      "notificationSent"           : notificationSent,
      "isVerifierVerified"         : isVerifierVerified,
      "isAdminVerified"            : isAdminVerified,
      "isReport"            : isReport,
      "isPassed"            : isPassed,
      "additionalInfoFromVerifiers": additionalInfoFromVerifiers,
    };
  }

  set setNotificationSent(bool isNotificationSent) => this.notificationSent = isNotificationSent;

  DateTime _parseUploadDate(date) {
    return DateTime.parse(date.toDate().toString());
  }
}
