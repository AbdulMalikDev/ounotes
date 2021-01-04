
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
Logger log = getLogger("SyllabusModel");

class Syllabus extends AbstractDocument{
  String id;

  //For Syllabus , the title is the year + branch
  String title;
  String subjectName;
  int subjectId;
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

  //GDrive info
  String GDriveID;
  String GDriveLink;
  String GDriveSyllabusFolderID;
  
  String uploader_id;

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
    this.GDriveID,
    this.GDriveLink,
    this.GDriveSyllabusFolderID,
    this.id,
    this.uploader_id,
    this.subjectId,
  });

  
  Syllabus.fromData(Map<String,dynamic> data){

    try {
      
    title        = data["title"] ?? (data["semester"]??"") + (data["branch"]??"");
    subjectName  = data['subjectName'];
    url          = data['url'];
    id           = data['id'].toString() ?? "";
    isDownloaded = data['isDownloaded'] ?? false;
    path         = Enum.getDocumentFromString(data['path']) ?? Document.Syllabus;
    semester     = data["semester"];
    branch       = data["branch"];
    uploader_id  = data["uploader_id"];
    type         = Constants.syllabus;
    year         = data["year"] ?? "";
    subjectId = data["subjectId"];
    GDriveID     = data["GDriveID"];
    GDriveLink   = data["GDriveLink"];
    GDriveSyllabusFolderID   = data["GDriveSyllabusFolderID"];
    pages = data["pages"];

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
      "uploader_id" : uploader_id,
      "subjectId" : subjectId,
      if(GDriveLink!=null)"GDriveLink":GDriveLink,
      if(GDriveID!=null)"GDriveID":GDriveID,
      if(GDriveSyllabusFolderID!=null)"GDriveNotesFolderID":GDriveSyllabusFolderID,
      if(pages!=null)"pages":pages,
      if(path!=null)"path"                              : path.toString(),
    };
  }

  

  set setId(String id){this.id = id;}
  set setUploaderId(String id) {
    this.uploader_id = id;
  }
  set setIsDownloaded(bool id){this.isDownloaded = id;}
  set setDate(DateTime id){this.uploadDate = id;}

  @override
   set setPath(Document path) {
    this.path = path;
  }

    set setSubjectId(int id){
    this.subjectId = id;
  }

   @override
   set setSize(String size) {
      this.size =size;
    }

     @override
  set setTitle(String value){this.title = value;}

  
  

  @override
   set setUrl(String url) {
    this.url = url;
  }

  DateTime _parseUploadDate(date)
  {
    
      return DateTime.parse(date.toDate().toString());
  }

  setGdriveDownloadLink(String url){
    this.GDriveLink = url;
  }
  setGdriveID(String url){
    this.GDriveID = url;
  }
  setGDriveSyllabusFolderID(String url){
    this.GDriveSyllabusFolderID = url;
  }
}