import 'package:FSOUNotes/ui/views/upload/upload_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../../enums/enums.dart';
import '../../../widgets/dumb_widgets/document_type_card.dart';

class DocumentTypeSelectionView extends StatefulWidget {

  final UploadViewModel model;
  const DocumentTypeSelectionView({Key key, this.model}) : super(key: key);

  @override
  State<DocumentTypeSelectionView> createState() => _DocumentTypeSelectionViewState();
}

class _DocumentTypeSelectionViewState extends State<DocumentTypeSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            DocumentTypeCard(
              title: "Notes",
              icon: Icon(
                Icons.description,
                color: widget.model.documentType == Document.Notes
                    ? Colors.white
                    : Colors.black,
              ),
              isSelected: widget.model.documentType == Document.Notes,
              onPressed: () {
                widget.model.setDocumentType = Document.Notes;
              },
            ),
            DocumentTypeCard(
              title: "Question Papers",
              icon: Icon(
                Icons.help_center,
                color: widget.model.documentType == Document.QuestionPapers
                    ? Colors.white
                    : Colors.black,
              ),
              isQuestionPaper: true,
              isSelected: widget.model.documentType == Document.QuestionPapers,
              onPressed: () {
                widget.model.setDocumentType = Document.QuestionPapers;
              },
            ),
            DocumentTypeCard(
              title: "Syllabus",
              icon: Icon(
                Icons.event_note,
                color: widget.model.documentType == Document.Syllabus
                    ? Colors.white
                    : Colors.black,
              ),
              isSelected: widget.model.documentType == Document.Syllabus,
              onPressed: () {
                widget.model.setDocumentType = Document.Syllabus;
              },
            ),
            DocumentTypeCard(
              title: "Links",
              icon: Icon(
                Icons.link,
                color: widget.model.documentType == Document.Links
                    ? Colors.white
                    : Colors.black,
              ),
              isSelected: widget.model.documentType == Document.Links,
              onPressed: () {
                widget.model.setDocumentType = Document.Links;
              },
            ),
          ],
        ),
      ],
    );
  }
}
