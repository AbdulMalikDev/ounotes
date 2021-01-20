import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:cuid/cuid.dart';

class Link extends AbstractDocument{

  String subjectName;
  int subjectId;
  String title;
  String description;
  String linkUrl;
  bool uploaded;

  //* variables needed for upload/download related features
  String id;
  Document path;
  String uploader_id;

  Link({this.subjectName, this.title, this.description, this.linkUrl, this.id, this.path,this.uploader_id,this.subjectId,this.uploaded=false});

  Link.clone(Link syllabus):
    this(
      subjectName: syllabus.subjectName,
      subjectId  : syllabus.subjectId,
      title      : syllabus.title,
      description: syllabus.description,
      linkUrl    : syllabus.linkUrl,
      uploaded   : syllabus.uploaded,
      path       : syllabus.path,
      id         : syllabus.id,
      uploader_id: syllabus.uploader_id,
    );

  Link.fromData(Map<String,dynamic> data)
  {
    
    title        = data['title'];
    description  = data['description'];
    linkUrl      = data['url'];
    subjectName  = data['subjectName'];
    path         = Enum.getDocumentFromString(data['path']) ?? Document.Links;
    id           = data["id"] ?? getNewId();
    type         = Constants.links;
    subjectId = data["subjectId"];
    uploader_id         = data["uploader_id"];
    uploaded = data["uploaded"] ?? false;
  }

  getNewId(){
    String id = newCuid();
    return id;
  }

  @override
  set setPath(Document path) {
    this.path = path;
  }

  @override
  Map<String, dynamic> toJson() {
    return 
    {
    if(subjectName!=null)"subjectName": subjectName,
    if(title!=null) "title"           : title,
    if(description!=null)"description": description,
    if(linkUrl!=null)"url"                : linkUrl,
    if(id!=null)"id"                  : id,
    if(subjectId!=null)"subjectId"    : subjectId,
    if(uploader_id!=null)"uploader_id": uploader_id,
    if(uploaded!=null)"uploaded"      : uploaded,
    if(path!=null)"path"              : path.toString(),
    };
  }

  @override
  set setSize(String size) {
      this.size =size;
    }
  
    set setSubjectId(int id){
    this.subjectId = id;
  }

  @override
  set setUrl(String url) {
    this.url = url;
  }
  set setUploaderId(String id) {
    this.uploader_id = id;
  }
  @override
  set setTitle(String value){this.title = value;}

}
