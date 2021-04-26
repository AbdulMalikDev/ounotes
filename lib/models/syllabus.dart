
import 'package:FSOUNotes/app/app.logger.dart';
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

   Syllabus.clone(Syllabus syllabus):
    this(
      subjectName                : syllabus.subjectName,
      title                      : syllabus.title,
      type                       : syllabus.type,
      branch                     : syllabus.branch,
      size                       : syllabus.size,
      year                       : syllabus.year,
      url                        : syllabus.url,
      uploadDate                 : syllabus.uploadDate,
      isDownloaded               : syllabus.isDownloaded,
      path                       : syllabus.path,
      GDriveID                   : syllabus.GDriveID,
      GDriveLink                 : syllabus.GDriveLink,
      GDriveSyllabusFolderID: syllabus.GDriveSyllabusFolderID,
      id                         : syllabus.id,
      uploader_id                : syllabus.uploader_id,
      subjectId                  : syllabus.subjectId,
    );

  
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
      if(title!=null)"title"                               : title,
      if(subjectName!=null)"subjectName"                   : subjectName,
      if(url!=null)"url"                                   : url,
      if(uploadDate!=null)"uploadDate"                     : uploadDate,
      if(id!=null)"id"                                     : id,
      if(isDownloaded!=null) "isDownloaded"                : isDownloaded ?? false,
      if(semester!=null) "semester"                        : semester,
      if(branch!=null)"branch"                             : branch,
      if(year!=null)"year"                                 : year,
      if(uploader_id!=null)"uploader_id"                   : uploader_id,
      if(subjectId!=null)"subjectId"                       : subjectId,
      if(GDriveLink!=null)"GDriveLink"                     : GDriveLink,
      if(GDriveID!=null)"GDriveID"                         : GDriveID,
      if(GDriveSyllabusFolderID!=null)"GDriveNotesFolderID": GDriveSyllabusFolderID,
      if(pages!=null)"pages"                               : pages,
      if(path!=null)"path"                                 : path.toString(),
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