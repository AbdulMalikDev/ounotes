import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/views/Main/main_screen_view.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/thank_you_page/thank_you_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';
import 'package:confetti/confetti.dart';

class ThankYouView extends StatefulWidget {
  final String filePath;
  ThankYouView({this.filePath});
  @override
  _ThankYouViewState createState() => _ThankYouViewState();
}

class _ThankYouViewState extends State<ThankYouView> {
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
                      if (widget.filePath == null)
                        Text(
                          "Congratulations !",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: primary),
                        ),
                      if (widget.filePath == null)
                        SizedBox(
                          height: 20,
                        ),
                      Text(
                        widget.filePath == null
                            ? "You are a Premium User!"
                            : "Thank you for downloading!",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: primary),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (widget.filePath != null)
                        Text(
                          "You will receive a confimation",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.teal.shade400),
                        ),
                      if (widget.filePath != null)
                        Text(
                          "notification about your download.",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.teal.shade400),
                        ),
                      if (widget.filePath != null) SizedBox(height: 5),
                      if (widget.filePath != null)
                        Text(
                          "Access this file in the ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.teal.shade400),
                        ),
                      if (widget.filePath != null)
                        Text(
                          "Internal Storage > Downloads folder ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.teal.shade400),
                        ),
                      if (widget.filePath != null)
                        Text(
                          "of your mobile",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.teal.shade400),
                        ),
                      if (widget.filePath != null)
                        SizedBox(
                          height: 50,
                        ),
                      Container(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            print(widget.filePath);
                            if (widget.filePath == null)
                              Navigator.of(context).pop();
                            else
                              OpenFile.open(widget.filePath);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: new Text(
                              widget.filePath != null ? "Open File" : "Done",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                  )),
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
