
import 'package:FSOUNotes/app/app.logger.dart';
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

  QuestionPaper.clone(QuestionPaper questionPaper):
    this(
      subjectName                : questionPaper.subjectName,
      title                      : questionPaper.title,
      type                       : questionPaper.type,
      branch                     : questionPaper.branch,
      size                       : questionPaper.size,
      year                       : questionPaper.year,
      url                        : questionPaper.url,
      uploadDate                 : questionPaper.uploadDate,
      isDownloaded               : questionPaper.isDownloaded,
      path                       : questionPaper.path,
      GDriveID                   : questionPaper.GDriveID,
      GDriveLink                 : questionPaper.GDriveLink,
      GDriveQuestionPaperFolderID: questionPaper.GDriveQuestionPaperFolderID,
      id                         : questionPaper.id,
      uploader_id                : questionPaper.uploader_id,
      subjectId                  : questionPaper.subjectId,
    );

  
  QuestionPaper.fromData(Map<String,dynamic> data){
    try
    {

      title        = data["title"] ?? data["year"].toString() ?? "";
      subjectName  = data['subjectName'] ?? "";
      url          = data['url'] ?? "";
      branch       = data['branch'] ?? "";
      id           = data['id']?.toString() ?? "";
      isDownloaded = data['isDownloaded'] ?? false;
      path         = Enum.getDocumentFromString(data['path']) ?? Document.QuestionPapers;
      uploader_id  = data["uploader_id"];
      year         = data["year"].toString() ?? "";
      type         = Constants.questionPapers;
      subjectId = data["subjectId"];
      GDriveID     = data["GDriveID"]; 
      GDriveLink   = data["GDriveLink"];
      GDriveQuestionPaperFolderID   = data["GDriveQuestionPaperFolderID"];
      pages = data["pages"];
   
    }catch(e){
       //log.e("message");
      String error;
      if(e is PlatformException)error = e.message;
      error = e.toString();
      log.e(error);
      
    }


  }

  
  Map<String,dynamic> toJson() {
    return {
      if(year!=null)"year"                                      : year,
      if(branch!=null)"branch"                                  : branch,
      if(subjectName!=null)"subjectName"                        : subjectName,
      if(url!=null)"url"                                        : url,
      if(uploadDate!=null)"uploadDate"                          : uploadDate,
      if(id!=null)"id"                                          : id,
      if(title!=null)"title"                                    : title,
      if(uploader_id!=null)"uploader_id"                        : uploader_id,
      if(isDownloaded!=null)"isDownloaded"                      : isDownloaded ?? false,
      if(subjectId!=null)"subjectId"                            : subjectId,
      if(GDriveLink!=null)"GDriveLink"                          : GDriveLink,
      if(GDriveID!=null)"GDriveID"                              : GDriveID,
      if(GDriveQuestionPaperFolderID!=null)"GDriveNotesFolderID": GDriveQuestionPaperFolderID,
      if(pages!=null)"pages"                                    : pages,
      if(path!=null)"path"                                      : path.toString(),
      
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