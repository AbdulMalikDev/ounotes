
import 'dart:io';

import 'package:FSOUNotes/enums/constants.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerService{
  Future selectFile({String uploadFileType}) async {
    bool isImage = false;
    
    if(uploadFileType == Constants.pdf){
      File file;
      
      FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf']);
      
      if(result!=null)file = File(result.files.single.path);
      else return;

      isImage = false;
      return [file,isImage];

    }else if([Constants.png,Constants.jpg,Constants.jpeg].contains(uploadFileType)){

      FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom,allowedExtensions: ['jpg','jpeg','png']);
      List<File> files = result.paths.map((path) => File(path)).toList();
      isImage = true;
      return [files,isImage];

    }
  }
}