
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/link.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
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
      subjectName = data['subjectName'].toString();
      id = data['id'].toString() ?? "";
      type = data["type"].toString();
      date = _parseUploadDate(data["uploadedAt"]);
      email = data["email"].toString();
      size = data["size"].toString() ?? "0";
      uploader_id = data["uploader_id"];
      uploader_name = data["uploader_name"];

    } catch (e) {
      log.e("While DESERIALIZING uploadLog model from Firebase , Error occurred");
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
