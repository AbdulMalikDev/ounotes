import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/watch_ad/watch_ad_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

class WatchAdToContinueView extends StatefulWidget {
  @override
  _WatchAdToContinueViewState createState() => _WatchAdToContinueViewState();
}

class _WatchAdToContinueViewState extends State<WatchAdToContinueView> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.teal[700], Colors.teal[400]],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<WatchAdToContinueViewModel>.reactive(
      viewModelBuilder: () => WatchAdToContinueViewModel(),
      builder: (
        BuildContext context,
        WatchAdToContinueViewModel model,
        Widget child,
      ) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: App(context).appHeight(1),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/billboard.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: App(context).appHeight(0.32),
                  left: App(context).appWidth(0.2),
                  right: App(context).appWidth(0.2),
                  child: Text(
                    "Watch Ad to Continue",
                    style: theme.textTheme.headline6.copyWith(
                      fontSize: 20,
                      color: theme.primaryColor,
                      //  foreground: Paint()..shader = linearGradient,
                    ),
                  ),
                ),
                Positioned(
                  top: App(context).appHeight(0.38),
                  left: App(context).appWidth(0.3),
                  right: App(context).appWidth(0.3),
                  child: Container(
                    height: 45,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.teal.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () async {
                        await model.showAd();
                      },
                      child: Text("Watch Ad"),
                    ),
                  ),
                ),
                Positioned(
                  top: App(context).appHeight(0.46),
                  left: App(context).appWidth(0.47),
                  right: App(context).appWidth(0.47),
                  child: Text(
                    "Or",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Positioned(
                  top: App(context).appHeight(0.5),
                  left: App(context).appWidth(0.26),
                  right: App(context).appWidth(0.27),
                  child: Container(
                    height: 45,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.teal.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        model.buyPremium();
                      },
                      child: Row(
                        children: [
                          Text("Buy Premium"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            MdiIcons.crown,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
