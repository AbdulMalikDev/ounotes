import 'package:flutter/foundation.dart';

class Download {
  String id;
  String path;
  String filename;
  String subjectName;
  String year;
  String title;
  String sem;
  String branch;
  String type;

  Download(
      {this.branch,
      this.sem,
      this.year,
      this.id,
      this.path,
      this.filename,
      this.subjectName,
      this.type,
      @required title,
      });
}
