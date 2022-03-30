import 'package:FSOUNotes/enums/constants.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:hive/hive.dart';

part 'download.g.dart';

@HiveType(typeId: 0)
class Download extends HiveObject {
  @HiveField(0)
   String id;
  @HiveField(1)
   String path;
  @HiveField(2)
   String title;
  @HiveField(3)
   String subjectName;
  @HiveField(4)
   String author;
  @HiveField(5)
   int view;
  @HiveField(6)
   int pages;
  @HiveField(7)
   String size;
  @HiveField(8)
   DateTime uploadDate;
  @HiveField(9)
   String semester;
  @HiveField(10)
   String branch;
  @HiveField(11)
   String year;
  @HiveField(12)
   String type;
  @HiveField(13)
   String boxName;

  Download({
    this.id,
    this.path,
    this.title,
    this.subjectName,
    this.author,
    this.view,
    this.pages,
    this.size,
    this.uploadDate,
    this.semester,
    this.branch,
    this.year,
    this.type,
  });

  Download.fromNotes(Note note, String filepath){
    this.id = note.id;
    this.subjectName = note.subjectName;
    this.title = note.title;
    this.type = note.type;
    this.author = note.author;
    this.path = filepath;
    this.boxName = Constants.notesDownloads;
  }

  Download.fromQuestionPapers(QuestionPaper note, String filepath){
    this.id = note.id;
    this.subjectName = note.subjectName;
    this.title = note.title;
    this.type = note.type;
    this.year = note.year;
    this.branch= note.branch;
    this.path = filepath;
    this.boxName = Constants.questionPaperDownloads;
  }

  Download.fromSyllabus(Syllabus note, String filepath){
    this.id = note.id;
    this.subjectName = note.subjectName;
    this.title = note.title;
    this.type = note.type;
    this.year = note.year;
    this.semester= note.semester;
    this.branch= note.branch;
    this.path = filepath;
    this.boxName = Constants.syllabusDownloads;
  }
}
