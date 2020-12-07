import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:cuid/cuid.dart';

class Link extends AbstractDocument{

  String subjectName;
  String title;
  String description;
  String linkUrl;


  //* variables needed for upload/download related features
  String id;
  Document path;
  String uploader_id;

  Link({this.subjectName, this.title, this.description, this.linkUrl, this.id, this.path});


  Link.fromData(Map<String,dynamic> data)
  {
    
    title        = data['title'];
    description  = data['description'];
    linkUrl      = data['url'];
    subjectName  = data['subjectName'];
    path         = Document.Links;
    id           = data["id"] ?? getNewId();
    type         = Constants.links;
    uploader_id         = data["uploader_id"];
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
    "subjectName" : subjectName,
    "title"       : title,
    "description" : description,
    "url"         : linkUrl,
    "id"          : id,
    "uploader_id" : uploader_id,
    };
  }

  @override
  set setSize(String size) {
      this.size =size;
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
