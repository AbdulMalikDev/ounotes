import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/views/links/links_view.dart';
import 'package:FSOUNotes/ui/views/notes/notes_view.dart';
import 'package:FSOUNotes/ui/views/question_papers/question_papers_view.dart';
import 'package:FSOUNotes/ui/views/syllabus/syllabus_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FDDocumentDisplayViewModel extends BaseViewModel {
  Widget screen;
  setScreen(Document path, String subjectName) {
    String p = 'fddocumentview';
    if (path == Document.Notes) {
      screen = NotesView(
        subjectName: subjectName,
        path: p,
      );
    } else if (path == Document.QuestionPapers) {
      screen = QuestionPapersView(
        subjectName: subjectName,
        path: p,
      );
    } else if (path == Document.Syllabus) {
      screen = SyllabusView(
        subjectName: subjectName,
        path:p,
      );
    } else {
      screen = LinksView(
        subjectName: subjectName,
        path: p,
      );
    }
  }
}
