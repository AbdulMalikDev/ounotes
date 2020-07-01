import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/models/question_paper.dart';
import 'package:FSOUNotes/services/funtional_services/cloud_storage_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class QuestionPaperService{
  
      List<QuestionPaper> _questionPapers;

      List<QuestionPaper> get questionPapers => _questionPapers;

      set setQuestionPapers(List<QuestionPaper> notes){_questionPapers = notes;}

      bool get isQuestionPapersPresent => _questionPapers!=null;

      //* This Function will assign name accordingly
      //* in other words it handles duplicates
      assignNameToQuestionPaper({String title})
      {
        //Decide FileName
        String fileName = title;
        int count = _findNumberOfQuestionPapersByName(title: title);
        if (count != 0) {
          fileName = fileName + "No." + (count + 1).toString();
        }
        return fileName;
      }

      _findNumberOfQuestionPapersByName({String title})
      {
        if(_questionPapers==null){return 0;}
        int count = _questionPapers.where((c) => c.title.contains(title)).toList().length;
        return count;
      }
}