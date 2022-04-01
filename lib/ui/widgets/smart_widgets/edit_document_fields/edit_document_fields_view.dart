import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_document_fields_viewmodel.dart';

class EditDocumentView extends StatefulWidget {
  
  const EditDocumentView({Key key}) : super(key: key);
  @override
  _EditDocumentViewState createState() => _EditDocumentViewState();
}

class _EditDocumentViewState extends State<EditDocumentView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditDocumentViewModel>.reactive(
      viewModelBuilder: () => EditDocumentViewModel(),
      builder: (
        BuildContext context,
        EditDocumentViewModel model,
        Widget child,
      ) {
        return Scaffold(
          body: Column(
            children: [

            ],
          ),
        );
      },
    );
  }
}
