import 'package:hive/hive.dart';
part 'download.g.dart';

@HiveType(typeId: 0)
class Download extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String path;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String subjectName;
  @HiveField(4)
  final String author;
  @HiveField(5)
  final int view;
  @HiveField(6)
  final int pages;
  @HiveField(7)
  final String size;
  @HiveField(8)
  final DateTime uploadDate;
  @HiveField(9)
  final String semester;
  @HiveField(10)
  final String branch;
  @HiveField(11)
  final String year;
  @HiveField(12)
  final String type;

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
}
