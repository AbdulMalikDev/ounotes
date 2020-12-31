import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:flutter/foundation.dart';

class Note extends AbstractDocument {
  String id;
  String title;
  String subjectName;
  int subjectId;
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

  //* GDrive Link
  String GDriveLink;
  String GDriveID;
  String GDriveNotesFolderID;

  String uploader_id;

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
    this.GDriveID,
    this.GDriveLink,
    this.GDriveNotesFolderID,
    this.firebaseId,
    this.id,
    this.uploader_id,
    this.subjectId,
  });

  Note.fromData(Map<String, dynamic> data , String documentID) {
    title = data['title'];
    subjectName = data['subjectName'];
    author = data['author'];
    view = data['view'];
    url = data['url'];
    uploadDate = _parseUploadDate(data["uploadDate"]);
    id = data['id']?.toString() ?? "";
    isDownloaded = data['isDownloaded'] ?? false;
    path = Document.Notes;
    type = Constants.notes;
    votes = data["votes"] ?? 0;
    size = data['size'];
    uploader_id = data['uploader_id'];
    GDriveLink = data['GDriveLink'] ?? null;
    GDriveID = data['GDriveID'] ?? null;
    GDriveNotesFolderID = data['GDriveNotesFolderID'] ?? null;
    firebaseId = documentID;
    subjectId = data["subjectId"];
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
      "uploader_id":uploader_id,
      "GDriveLink":GDriveLink ?? null,
      "GDriveID":GDriveID ?? null,
      "GDriveNotesFolderID":GDriveNotesFolderID ?? null,
      "firebaseId":firebaseId ?? "",
      "subjectId" : subjectId,
    };
  }

  set setSubjectId(int id){
    this.subjectId = id;
  }

  set setId(String id) {
    this.id = id;
    this.firebaseId = id;
  }

  set setUploaderId(String id) {
    this.uploader_id = id;
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

  setGdriveDownloadLink(String url){
    this.GDriveLink = url;
  }
  setGdriveID(String url){
    this.GDriveID = url;
  }
  setGDriveNotesFolderID(String url){
    this.GDriveNotesFolderID = url;
  }

  DateTime _parseUploadDate(date) {
    return DateTime.parse(date.toDate().toString());
  }
}
