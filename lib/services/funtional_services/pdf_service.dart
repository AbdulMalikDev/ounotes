
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:flutter/painting.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
Logger log = getLogger("PDFService");

/// Class that handles all PDF Manipulations
class PDFService{

  Future<PdfDocument> convertImageToPdf(
                                          List<File> documents, 
                                          String tempPath
                                      ) async {
    try {
      //Create a new PDF document
      PdfDocument document = PdfDocument();

      for (File file in documents) {
        //Adds a page to the document
        PdfPage page = document.pages.add();

        ui.Image image = await decodeImageFromList(file.readAsBytesSync());
        log.e(image.height);
        log.e(image.width);

        //Draw the image
        page.graphics.drawImage(
            PdfBitmap(file.readAsBytesSync()),
            Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height));
      }

      File(tempPath).writeAsBytes(document.save());

      return document;
    } catch (e) {
      log.e(e.toString());
      return null;
    }
  }

  Future<PdfDocument> _convertImageToPdf(
      List<File> documents, String tempPath) async {
    try {
      //Create a new PDF document
      PdfDocument document = PdfDocument();

      for (File file in documents) {
        //Adds a page to the document
        PdfPage page = document.pages.add();

        ui.Image image = await decodeImageFromList(file.readAsBytesSync());
        log.e(image.height);
        log.e(image.width);

        //Draw the image
        page.graphics.drawImage(
            PdfBitmap(file.readAsBytesSync()),
            Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height));
      }

      File(tempPath).writeAsBytes(document.save());

      return document;
      
    } catch (e) {
      log.e(e.toString());
      return null;
    }
  }


}