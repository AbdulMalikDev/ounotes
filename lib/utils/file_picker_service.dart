
import 'dart:io';

import 'package:FSOUNotes/enums/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FilePickerService{
  Future selectFile({String uploadFileType}) async {
    if(uploadFileType == Constants.pdf){
      File file = await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf']);
      return file;
    }else if([Constants.png,Constants.jpg,Constants.jpeg].contains(uploadFileType)){
      List<File> files = await FilePicker.getMultiFile(type: FileType.custom,allowedExtensions: ['jpg','jpeg','png']);
      return files;
    }
  }
}