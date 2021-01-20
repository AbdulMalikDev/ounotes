import 'package:FSOUNotes/misc/constants.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:confetti/confetti.dart';
import 'thank_you_for_uploading_viewmodel.dart';


class ThankYouForUploadingView extends StatefulWidget {
  @override
  _ThankYouForUploadingViewState createState() => _ThankYouForUploadingViewState();
}

class _ThankYouForUploadingViewState extends State<ThankYouForUploadingView> {
  ConfettiController _controllerCenter;
   @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ThankYouForUploadingViewModel>.reactive(
      viewModelBuilder: () => ThankYouForUploadingViewModel(),
      builder: (
        BuildContext context,
        ThankYouForUploadingViewModel model,
        Widget child,
      ) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
          ),
        ),
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
                      // Text(
                      //   "Congratulations !",
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .headline6
                      //       .copyWith(color: primary),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Text(
                        "Thank you for uploading !",
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
                        "notification from the admins",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Colors.teal.shade400),
                      ),
                      Text(
                        "once the document is verified",
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
                            onPressed: () {
                              model.navigateToHome();
                            },
                            textColor: Colors.white,
                            color: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: new Text(
                              "Done",
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
