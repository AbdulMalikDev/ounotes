
import 'dart:io';

import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/enums/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
Logger log = getLogger("FilePickerService");

class FilePickerService{
  Future selectFile({String uploadFileType}) async {
    try {
      if(uploadFileType == Constants.pdf){
        File file;
        
        FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf'],allowMultiple: true);
        
        if(result == null){
          return null;
        }

        // File(result.files.single.path)
        
        List<PlatformFile> files = result.files;
        files.forEach((element) {log.e(element);});

        return files;

      }
    
      
    } catch (e) {
      log.e(e.toString());
      log.e("error file upload");
    }
  }
}