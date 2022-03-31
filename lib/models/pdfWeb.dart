import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfWeb {
  List<int> bytes;
  String name;
  int size;
  String extension;
  PdfDocument pdf;

  PdfWeb({this.bytes, this.name, this.size, this.extension,this.pdf});

  PdfWeb.from(PlatformFile file,PdfDocument pdf){
    this.bytes = file.bytes;
    this.name = file.name;
    this.extension = file.extension;
    this.pdf = pdf;
    this.size = file.size;
  }

  PdfWeb.fromJson(Map<String, dynamic> json) {
    bytes = json['bytes'];
    name = json['name'];
    size = json['size'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bytes'] = this.bytes;
    data['name'] = this.name;
    data['size'] = this.size;
    data['extension'] = this.extension;
    return data;
  }
}
