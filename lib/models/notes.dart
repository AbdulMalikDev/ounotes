import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Note extends AbstractDocument {
  String id;
  String title;
  String subjectName;
  String author;
  int view;
  String size;
  String url;
  DateTime uploadDate;
  String firebaseId;
  bool isDownloaded = false;
  //Do not change name of this variable
  Document path;
  String type;
  int votes;

  Note({
    @required this.subjectName,
    @required this.title,
    @required this.type,
    this.author,
    this.size,
    this.view,
    this.url,
    this.uploadDate,
    this.isDownloaded = false,
    @required this.path,
    this.votes,
  });

  Note.fromData(Map<String, dynamic> data) {
    title = data['title'];
    subjectName = data['subjectName'];
    author = data['author'];
    view = data['view'];
    url = data['url'];
    uploadDate = _parseUploadDate(data["uploadDate"]);
    id = data['id'].toString() ?? "";
    isDownloaded = data['isDownloaded'] ?? false;
    path = Document.Notes;
    type = Constants.notes;
    votes = data["votes"];
    size = data['size'];
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subjectName": subjectName,
      "author": author,
      "view": view,
      "url": url,
      "uploadDate": uploadDate,
      "id": id,
      "isDownloaded": isDownloaded ?? false,
      "votes": votes,
      "size":size,
    };
  }

  set setId(String id) {
    this.id = id;
  }

  set setIsDownloaded(bool id) {
    this.isDownloaded = id;
  }

  set setDate(DateTime id) {
    this.uploadDate = id;
  }

  @override
  set setSize(String size) {
    this.size = size;
  }

  @override
  set setTitle(String value) {
    this.title = value;
  }

  @override
  set setUrl(String url) {
    this.url = url;
  }

  @override
  set setPath(Document path) {
    this.path = path;
  }

  DateTime _parseUploadDate(date) {
    return DateTime.parse(date.toDate().toString());
  }
}
