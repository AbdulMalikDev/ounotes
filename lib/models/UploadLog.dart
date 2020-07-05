import 'package:FSOUNotes/app/logger.dart';
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

  UploadLog(
      {this.id,
      this.subjectName,
      this.type,
      this.fileName,
      this.date,
      this.size,
      this.email});

  UploadLog.fromData(Map<String, dynamic> data) {
    try {
      fileName = data["fileName"] ?? "";
      subjectName = data['subjectName'];
      id = data['id'].toString() ?? "";
      type = data["type"];
      date = _parseUploadDate(data["uploadedAt"]);
      email = data["email"];
      size = data["size"] ?? "0";
    } catch (e) {
      log.e(
          "While DESERIALIZING uploadLog model from Firebase , Error occurred");
      String error;
      if (e is PlatformException) error = e.message;
      error = e.toString();
      log.e(error);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "fileName": fileName,
      "subjectName": subjectName,
      "email": email,
      "type": type,
      "id": id,
      "uploadedAt": date,
      "size" : size??"0",
    };
  }

  DateTime _parseUploadDate(date) {
    return DateTime.parse(date.toDate().toString());
  }
}
