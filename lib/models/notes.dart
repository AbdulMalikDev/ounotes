import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/models/document.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger log = getLogger("Note.dart");

class Note extends AbstractDocument {
  String id;
  String title;
  String subjectName;
  int subjectId;
  String author;
  int view;
  int pages;
  String size;
  String url;
  DateTime uploadDate;
  String firebaseId;
  Map<String, int> bookmarks = {};
  Map<int, bool> units = {};
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

  Note.clone(Note note)
      : this(
          subjectName: note.subjectName,
          title: note.title,
          type: note.type,
          author: note.author,
          size: note.size,
          view: note.view,
          url: note.url,
          uploadDate: note.uploadDate,
          isDownloaded: note.isDownloaded,
          path: note.path,
          GDriveID: note.GDriveID,
          GDriveLink: note.GDriveLink,
          GDriveNotesFolderID: note.GDriveNotesFolderID,
          firebaseId: note.firebaseId,
          id: note.id,
          uploader_id: note.uploader_id,
          subjectId: note.subjectId,
        );

  Note.fromData(Map<String, dynamic> data, [String documentID]) {
    title = data['title'];
    subjectName = data['subjectName'];
    author = data['author'];
    view = data['view'];
    url = data['url'];
    uploadDate = _parseUploadDate(data["uploadDate"]);
    id = data['id']?.toString() ?? "";
    isDownloaded = data['isDownloaded'] ?? false;
    path = Enum.getDocumentFromString(data['path']) ?? Document.Notes;
    type = Constants.notes;
    votes = data["votes"] ?? 0;
    size = data['size'];
    uploader_id = data['uploader_id'];
    GDriveLink = data['GDriveLink'] ?? null;
    GDriveID = data['GDriveID'] ?? null;
    GDriveNotesFolderID = data['GDriveNotesFolderID'] ?? null;
    firebaseId = documentID ?? id;
    pages = data["pages"];
    subjectId = data["subjectId"];
    bookmarks = data["bookmarks"] == null
        ? {}
        : new Map<String, int>.from(data["bookmarks"]);
    units = data["units"] == null ? {} : new Map<int, bool>.from(data["units"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subjectName": subjectName,
      "author": author,
      if (view != null) "view": view,
      if (url != null) "url": url,
      if (uploadDate != null) "uploadDate": uploadDate,
      if (id != null) "id": id,
      if (isDownloaded != null) "isDownloaded": isDownloaded ?? false,
      if (votes != null) "votes": votes,
      if (size != null) "size": size,
      if (uploader_id != null) "uploader_id": uploader_id,
      if (GDriveLink != null) "GDriveLink": GDriveLink,
      if (GDriveID != null) "GDriveID": GDriveID,
      if (GDriveNotesFolderID != null)
        "GDriveNotesFolderID": GDriveNotesFolderID,
      if (pages != null) "pages": pages,
      if (bookmarks != null) "bookmarks": bookmarks,
      if (path != null) "path": path.toString(),
      if (firebaseId != null) "firebaseId": firebaseId ?? "",
      if (subjectId != null) "subjectId": subjectId,
      if(bookmarks!=null)"bookmarks":bookmarks,
      if(units!=null)"units":units
    };
  }

  set setSubjectId(int id) => this.subjectId = id;

  set setBookMarks(Map<String, int> value) => this.bookmarks = value;

  set setPages(int value) => this.pages = value;

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

  setGdriveDownloadLink(String url) {
    this.GDriveLink = url;
  }

  setGdriveID(String url) {
    this.GDriveID = url;
  }

  setGDriveNotesFolderID(String url) {
    this.GDriveNotesFolderID = url;
  }

  DateTime _parseUploadDate(date) {
    return DateTime.parse(
        date?.toDate()?.toString() ?? DateTime.now().toString());
  }
}
