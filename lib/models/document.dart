import 'package:FSOUNotes/enums/enums.dart';

abstract class AbstractDocument {
  String id;
  bool isDownloaded = false;
  Document path;
  String subjectName;
  String title;
  String url;
  String size;
  String type;
  String uploader_id;
  

  set setDate(DateTime setDate) {}
  set setSize(String size);
  set setUrl(String url) ;

  set setId(String id) {
    this.id = id;
  }

  set setUploaderId(String id) {
    this.uploader_id = id;
  }

  set setPath(Document path);
  set setIsDownloaded(bool id) {
    this.isDownloaded = id;
  }

  set setTitle(String value);

  Map<String, dynamic> toJson();
}
