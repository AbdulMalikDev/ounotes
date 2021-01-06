import 'package:FSOUNotes/misc/constants.dart';
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
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  left: 0,
                  child: Container(
                    height: 120,
                    width: 120,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login_top.png"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  right: 0,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login_bottom.png"),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          child: Image(
                            image:
                                AssetImage('assets/images/student_jumping.jpg'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Thank you for downloading!",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: primary),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "You will receive a confimation",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.teal.shade400),
                      ),
                      Text(
                        "notification about your download.",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.teal.shade400),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          height: 55,
                          child: RaisedButton(
                            onPressed: () {},
                            textColor: Colors.white,
                            color: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: new Text(
                              "Open File",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
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
