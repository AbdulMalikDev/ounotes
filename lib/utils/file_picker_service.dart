
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FilePickerService{
  Future<File> selectFile() async {
    File file = await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf']);
    return file;
  }
}