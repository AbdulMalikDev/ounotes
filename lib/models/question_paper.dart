
import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class QuestionPaper extends AbstractDocument{
  Logger log = getLogger("QuestionPaper");
  String id;

  //For question papers , the title is the year
  String title;

  String subjectName;
  String size;
  String url;
  DateTime uploadDate;
  bool isDownloaded = false;
  Document note;
  Document path;

  String branch;
  String year;
  String type;
  
  

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
    year         = data["year"].toString() ?? "";
    type         = Constants.questionPapers;
   
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
      "isDownloaded": isDownloaded ?? false,
      
    };
  }

   @override
  void set setSize(String size) {
      this.size =size;
    }
  
  

  @override
  void set setUrl(String url) {
    this.url = url;
  }

  set setId(String id){this.id = id;}
  set setIsDownloaded(bool id){this.isDownloaded = id;}
  set setDate(DateTime id){this.uploadDate = id;}

  @override
  void set setPath(Document path) {
    this.path = path;
  }

  DateTime _parseUploadDate(date)
  {
    
      return DateTime.parse(date.toDate().toString());
  }

   @override
  set setTitle(String value){this.title = value;}

}