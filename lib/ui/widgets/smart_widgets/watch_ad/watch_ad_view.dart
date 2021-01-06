import 'package:FSOUNotes/ui/widgets/smart_widgets/watch_ad/watch_ad_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WatchAdToContinueView extends StatefulWidget {
  @override
  _WatchAdToContinueViewState createState() => _WatchAdToContinueViewState();
}

class _WatchAdToContinueViewState extends State<WatchAdToContinueView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WatchAdToContinueViewModel>.reactive(
      viewModelBuilder: () => WatchAdToContinueViewModel(),
      builder: (
        BuildContext context,
        WatchAdToContinueViewModel model,
        Widget child,
      ) {
        return Scaffold(
          body: Stack(
            children: [
              Container(color: Color(0xff0078FF),),
              Text("Watch Ad to continue"),
              Center(
                child: Image(
                  image: AssetImage('assets/images/billboard.jpg'),
                ),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Watch Ad"),
              ),
              Text("Or"),
            RaisedButton(
                onPressed: () {},
                child: Text("Buy Premium"),
              ),
            ],
          ),
        );
      },
    );
  }
}
