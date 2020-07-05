
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Syllabus extends AbstractDocument{
  Logger log = getLogger("SyllabusModel");
  String id;

  //For Syllabus , the title is the year + branch
  String title;
  String subjectName;
  String size;
  String url;
  DateTime uploadDate;
  bool isDownloaded = false;
  Document note;
  Document path;
  String semester;
  String branch;
  String year;
  String type;
  
  

  Syllabus({
    @required this.subjectName,
    @required this.title,
    this.size,
    this.url,
    this.uploadDate,
    this.isDownloaded =false,
    @required this.path,
    this.branch,
    this.note,
    this.semester,
    this.year,
    @required this.type,
  });

  
  Syllabus.fromData(Map<String,dynamic> data){

    try {
      
    title        = data["title"] ?? (data["semester"]??"") + (data["branch"]??"");
    subjectName  = data['subjectName'];
    url          = data['url'];
    id           = data['id'].toString() ?? "";
    isDownloaded = data['isDownloaded'] ?? false;
    path         = Document.Syllabus;
    semester     = data["semester"];
    branch       = data["branch"];
    type         = Constants.syllabus;
    year         = data["year"] ?? "";

    } catch (e) {
      log.e("While DESERIALIZING syllabus model from Firebase , Error occurred");
      String error;
      if(e is PlatformException)error = e.message;
      error = e.toString();
      log.e(error);
    }

  }

  
  Map<String,dynamic> toJson() {
    return {
      "title"       : title,
      "subjectName" : subjectName,
      "url"         : url,
      "uploadDate"  : uploadDate,
      "id"          : id,
      "isDownloaded": isDownloaded ?? false,
      "semester"    : semester,
      "branch"      : branch,
      "year"        : year,
    };
  }

  

  set setId(String id){this.id = id;}
  set setIsDownloaded(bool id){this.isDownloaded = id;}
  set setDate(DateTime id){this.uploadDate = id;}

  @override
  void set setPath(Document path) {
    this.path = path;
  }

   @override
  void set setSize(String size) {
      this.size =size;
    }

     @override
  set setTitle(String value){this.title = value;}

  
  

  @override
  void set setUrl(String url) {
    this.url = url;
  }

  DateTime _parseUploadDate(date)
  {
    
      return DateTime.parse(date.toDate().toString());
  }
}