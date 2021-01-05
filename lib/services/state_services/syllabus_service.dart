import 'package:FSOUNotes/app/logger.dart';
import 'package:FSOUNotes/models/syllabus.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class SyllabusService{
      Logger log = getLogger("SyllabusService");
      List<Syllabus> _syllabus;

      List<Syllabus> get syllabus => _syllabus;

      set setSyllabus(List<Syllabus> syllabus){_syllabus = syllabus;}

      bool get isSyllabusPresent => _syllabus!=null;

      //* This Function will assign name accordingly
      //* in other words it handles duplicates
      assignNameToSyllabus({String title})
      {
        //Decide FileName
        String fileName = title;
        int count = _findNumberOfSyllabusByName(title: title);
        if (count != 0) {
          fileName = fileName + "No." + (count + 1).toString();
          log.w("fileName already taken , changed name to $fileName");

        }
        return fileName;
      }

      _findNumberOfSyllabusByName({String title})
      {
        if(_syllabus==null){
          log.w("Syllabus array is null");
          return 0;
        }
        int count = _syllabus.where((c) => c.title.contains(title)).toList().length;
        return count;
      }
}