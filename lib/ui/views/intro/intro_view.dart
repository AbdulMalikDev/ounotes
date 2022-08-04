import 'package:FSOUNotes/misc/helper.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/intro/intro_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/selection_card.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key key}) : super(key: key);
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.teal[700], Colors.teal[400]],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<IntroViewModel>.reactive(
      onModelReady: (model) {
        model.initialise();
      },
      builder: (context, model, child) {
        return ModalProgressHUD(
          inAsyncCall: model.isBusy ? true : false,
          opacity: 0.5,
          progressIndicator: circularProgress(),
          child: WillPopScope(
            onWillPop: () => Helper.showWillPopDialog(
              context: context,
            ),
            child: Scaffold(
              body: Stack(
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
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 20,
                      ),
                      child: Text(
                        "Welcome To OUNotes",
                        style: theme.textTheme.headline6.copyWith(
                          fontSize: 25,
                          //  color: theme.primaryColor,
                          foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: App(context).appWidth(0.2),
                    right: App(context).appWidth(0.2),
                    child: Container(
                      height: App(context).appHeight(0.3),
                      width: App(context).appWidth(0.2),
                      child: Lottie.asset(
                        'assets/lottie/intro_book.json',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: App(context).appHeight(0.32),
                    left: 30,
                    right: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SelectionCard(
                          value: model.sem,
                          onChanged: model.changedDropDownItemOfSemester,
                          items: model.dropdownofsem,
                          title: "Select Semester",
                        ),
                        SelectionCard(
                          value: model.br,
                          onChanged: model.changedDropDownItemOfBranch,
                          items: model.dropdownofbr,
                          title: "Select Branch",
                        ),
                        SelectionCard(
                          value: model.clg,
                          onChanged: model.changedDropDownItemOfCollege,
                          items: model.dropdownofclg,
                          title: "Select College",
                          isExpanded: true,
                        ),
                        FittedBox(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            height: App(context)
                                .appScreenHeightWithOutSafeArea(0.07),
                            child: GoogleSignInButton(
                                borderRadius: 10,
                                onPressed: () {
                                  model.handleSignUp();
                                }),
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => IntroViewModel(),
    );
  }
}
