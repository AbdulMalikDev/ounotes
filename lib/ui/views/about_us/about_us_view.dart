import 'package:FSOUNotes/ui/views/about_us/about_us_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/default_app_bar/back_icon_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ViewModelBuilder<AboutUsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: BackIconTitleAppBar(
          title: "About Us",
        ),
        body: Container(
          height: App(context).appScreenHeightWithOutSafeArea(1),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: App(context).appHeight(0.05),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: App(context)
                                .appScreenHeightWithOutSafeArea(0.13),
                            width:
                                App(context).appScreenWidthWithOutSafeArea(0.4),
                            child: Image.asset("assets/images/apnaicon.png"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Text("OU Notes", style: theme.textTheme.headline6),
                          GestureDetector(
                            onTap: () =>
                                model.navigateToTermsAndConditionView(),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              height: 80,
                              width: double.maxFinite,
                              child: Card(
                                color: theme.colorScheme.background,
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    "Terms and condition",
                                    style: theme.textTheme.subtitle1
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => model.navigateToPrivacyPolicyView(),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              height: 80,
                              width: double.maxFinite,
                              child: Card(
                                color: theme.colorScheme.background,
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    "Privacy policy",
                                    style: theme.textTheme.subtitle1
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: App(context).appHeight(0.05)),
                          Container(
                            // height: MediaQuery.of(context).size.height * 0.23,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              "OU Notes is an opensource platform created by two concerned App Developers from MJCET,  Abdul Malik and Syed Wajid. \n\n Do your part and make sure to send us any Academic Material that could be of any help to the students of OU. ",
                              style: theme.textTheme.subtitle1
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: App(context).appHeight(0.03),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "ounotesplatform@gmail.com",
                              style: theme.textTheme.subtitle1
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => AboutUsViewModel(),
    );
  }
}
