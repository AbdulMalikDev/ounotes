import 'package:FSOUNotes/ui/widgets/smart_widgets/thank_you_page/thank_you_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ThankYouView extends StatefulWidget {
  @override
  _ThankYouViewState createState() => _ThankYouViewState();
}

class _ThankYouViewState extends State<ThankYouView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ThankYouViewModel>.reactive(
      viewModelBuilder: () => ThankYouViewModel(),
      builder: (
        BuildContext context,
        ThankYouViewModel model,
        Widget child,
      ) {
        return Scaffold(
          body: Center(
          child: Text(
              'ThankYouView',
            ),
          ),
        );
      },
    );
  }
}