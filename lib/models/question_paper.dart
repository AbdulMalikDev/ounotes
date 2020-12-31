
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
Logger log = getLogger("QuestionPaper");

class QuestionPaper extends AbstractDocument{
  String id;

  //For question papers , the title is the year
  String title;

  String subjectName;
  int subjectId;
  int pages;
  String size;
  String url;
  DateTime uploadDate;
  bool isDownloaded = false;
  Document note;
  Document path;

  String branch;
  String year;
  String type;

  //GDrive info
  String GDriveID;
  String GDriveLink;
  String GDriveQuestionPaperFolderID;
  
  String uploader_id;
  

  QuestionPaper({
    @required this.subjectName,
    @required this.title,
    this.size,
    this.url,
    this.uploadDate,
    this.isDownloaded =false,
    @required this.path,
    this.note,
    this.branch,
    this.year,
    @required this.type,
    this.GDriveID,
    this.GDriveLink,
    this.GDriveQuestionPaperFolderID,
    this.id,
    this.uploader_id,
    this.subjectId,
  });

  
  QuestionPaper.fromData(Map<String,dynamic> data){
    try
    {

    title        = data["title"] ?? data["year"].toString() ?? "";
    subjectName  = data['subjectName'] ?? "";
    url          = data['url'] ?? "";
    branch       = data['branch'] ?? "";
    id           = data['id']?.toString() ?? "";
    isDownloaded = data['isDownloaded'] ?? false;
    path         = Document.QuestionPapers;
    uploader_id  = data["uploader_id"];
    year         = data["year"].toString() ?? "";
    type         = Constants.questionPapers;
    subjectId = data["subjectId"];
    GDriveID     = data["GDriveID"]; 
    GDriveLink   = data["GDriveLink"];
    GDriveQuestionPaperFolderID   = data["GDriveQuestionPaperFolderID"];
    pages = data["pages"];
   
    }catch(e)
    {
       //log.e("message");
      String error;
      if(e is PlatformException)error = e.message;
      error = e.toString();
      log.e(error);
      
    }


  }

  
  Map<String,dynamic> toJson() {
    return {
      "year"        : year,
      "branch"      : branch,
      "subjectName" : subjectName,
      "url"         : url,
      "uploadDate"  : uploadDate,
      "id"          : id,
      "title"       : title,
      "uploader_id" : uploader_id,
      "isDownloaded": isDownloaded ?? false,
      "subjectId" : subjectId,
      if(GDriveLink!=null)"GDriveLink":GDriveLink,
      if(GDriveID!=null)"GDriveID":GDriveID,
      if(GDriveQuestionPaperFolderID!=null)"GDriveNotesFolderID":GDriveQuestionPaperFolderID,
      if(pages!=null)"pages":pages,
      
    };
  }

   @override
   set setSize(String size) {
      this.size =size;
    }

  set setPages(int value) => this.pages = value;
  
    set setSubjectId(int id){
    this.subjectId = id;
  }

  @override
   set setUrl(String url) {
    this.url = url;
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

  DateTime _parseUploadDate(date)
  {
    
      return DateTime.parse(date.toDate().toString());
  }

   @override
  set setTitle(String value){this.title = value;}

  setGdriveDownloadLink(String url){
    this.GDriveLink = url;
  }
  setGdriveID(String url){
    this.GDriveID = url;
  }
  setGDriveQuestionPapersFolderID(String url){
    this.GDriveQuestionPaperFolderID = url;
  }

}