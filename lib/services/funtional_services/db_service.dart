import 'dart:core';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

@lazySingleton
class DBService {
   Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'notes.db'),
        version: 1,
        //we create all the tables in oncreate
        onCreate: (db, version) => _createDb(db),
      //   onUpgrade: (db, oldVersion, newVersion) {
      //     if (oldVersion == 1) {
      //     //we update existing tables or create new table in db
      //       _createTableUserVotedSubjects(db);
      //     }
      //   },
      //  onDowngrade: onDatabaseDowngradeDelete
        );
  }
   void _createDb(Database db) {
    db.execute(
        'CREATE TABLE downloaded_subjects(path TEXT,filename TEXT,subjectname Text,id TEXT PRIMARY KEY,sem TEXT,branch TEXT,year TEXT,type TEXT,title TEXT)');
    _createTableUserVotedSubjects(db);
  }

   void _createTableUserVotedSubjects(Database db) {
    db.execute(
        'CREATE TABLE uservoted_subjects(notename TEXT,subname TEXT,hasupvoted BOOLEAN,hasdownvoted BOOLEAN)');
  }

   Future<void> insert(String table, Map<String, Object> data) async {
    final db = await database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   Future<void> deleteVote(String table, String notesName) async {
    final db = await database();
    db.delete(table, where: 'notename = ?', whereArgs: [notesName]);
  }

   Future<void> deleteDownload(String table, String path) async {
    final db = await database();
    db.delete(table, where: 'path = ?', whereArgs: [path]);
  }

   Future<void> updateVotes(
      String table, Map<String, Object> data, String notename) async {
    final db = await database();
    db.update(table, data, where: 'notename = ?', whereArgs: [notename]);
  }

   Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database();
    return db.query(table);
  }
}
