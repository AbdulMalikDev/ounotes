
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class RecentlyOpenedNotes {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String url;
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

  RecentlyOpenedNotes(this.id, this.url, this.title, this.subjectName, this.author, this.view, this.pages, this.size, this.uploadDate);
}
