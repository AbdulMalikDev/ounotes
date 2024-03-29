import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/CustomIcons/custom_icons.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/services/funtional_services/onboarding_service.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/drawer_header.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/nav_item.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/drawer/drawer_viewmodel.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:wiredash/wiredash.dart';

class DrawerView extends StatefulWidget {
  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  Intro intro;
  List<Map<String, String>> drawerPrompts;
  _DrawerViewState() {
    drawerPrompts = OnboardingService.drawerPrompts;

    /// init Intro
    intro = Intro(
      stepCount: 3,
      padding: EdgeInsets.zero,

      /// use defaultTheme, or you can implement widgetBuilder function yourself
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          ...drawerPrompts[0].keys,
          ...drawerPrompts[1].keys,
          ...drawerPrompts[2].keys,
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1
              ? drawerPrompts[0].values.toList()[0]
              : drawerPrompts[1].values.toList()[0];
        },
      ),
    );
    intro.setStepConfig(
      0,
      padding: EdgeInsets.symmetric(
        horizontal: -1,
        vertical: 5,
      ),
    );
  }

  @override
  void dispose() {
    intro?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var subtitle1 =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16);

    return ViewModelBuilder<DrawerViewModel>.reactive(
        onModelReady: (model) async {
          await model.showIntro(intro, context);
          await model.openDownloadBox();
        },
        builder: (context, model, child) => Container(
              width: App(context).appScreenWidthWithOutSafeArea(0.78),
              child: Drawer(
                child: ListView(
                  children: [
                    DrawerHeaderView(
                      isPremiumUser: model.user?.isPremiumUser ?? false,
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.brightness_4,
                              color: AppStateNotifier.isDarkModeOn
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            title: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "SWITCH THEME",
                                    style: subtitle1,
                                  ),
                                  Spacer(),
                                  Container(
                                    key: intro.keys[0],
                                    height: 45,
                                    width: 50,
                                    child: DayNightSwitcher(
                                      isDarkModeEnabled:
                                          AppStateNotifier.isDarkModeOn,
                                      onStateChanged: (val) {
                                        model.updateAppTheme(val);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          NavItem(
                              Icons.file_upload,
                              "Upload",
                              subtitle1,
                              model.navigateToUserUploadScreen,
                              Document.Drawer),
                          if (!(model.user?.isPremiumUser ?? false))
                            ListTile(
                                leading: SizedBox(
                                  height: 30,
                                  width: 40,
                                  child: ClipRRect(
                                    child: Image.asset(
                                      "assets/images/donate-icon.png",
                                      color: AppStateNotifier.isDarkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "Support Us ",
                                  style: subtitle1,
                                ),
                                onTap: model.navigateToDonateScreen),
                          ListTile(
                              key: intro.keys[1],
                              leading: Icon(
                                Custom.emo_thumbsup,
                                color: AppStateNotifier.isDarkModeOn
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                              title: Text(
                                "RATE THIS APP",
                                style: subtitle1,
                              ),
                              subtitle: Text(
                                "Donate a 5 star.",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 12),
                              ),
                              trailing: Icon(
                                Icons.rate_review,
                                color: AppStateNotifier.isDarkModeOn
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                              onTap: () async {
                                // model.showRateMyAppDialog(context);
                              }),
                          NavItem(
                              Icons.arrow_drop_down_circle,
                              "My Downloads",
                              subtitle1,
                              model.navigateToDownloadScreen,
                              Document.None),
                          ListTile(
                            key: intro.keys[2],
                            leading: Icon(
                              MdiIcons.volumeHigh,
                              size: 30,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Shimmer.fromColors(
                              baseColor: Colors.teal,
                              highlightColor: Colors.yellow,
                              child: Text(
                                'Feedback',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat",
                                  fontSize: 22,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                            onTap: () async {
                              // model.dispatchEmail();
                              await model.getPackageInfo();
                              Wiredash.of(context).setBuildProperties(
                                buildNumber: model.packageInfo.version,
                                buildVersion: model.packageInfo.buildNumber,
                              );
                              Wiredash.of(context).setUserProperties(
                                userEmail: await model.getUserEmail(),
                                userId: await model.getUserId(),
                              );
                              Wiredash.of(context).show();
                            },
                          ),
                          if (model.isAdmin)
                            // NavItem(
                            //     Icons.equalizer,
                            //     "Admin Panel",
                            //     subtitle1,
                            //     model.navigateToAdminUploadScreen,
                            //     Document.Drawer),
                          if (model.isVerifier)
                            NavItem(
                                Icons.account_balance,
                                "Verifier Panel",
                                subtitle1,
                                model.navigateToVerifierPanelScreen,
                                Document.Drawer),
                          Divider(color: Colors.grey.shade600),
                          Row(children: <Widget>[
                            SizedBox(width: 20),
                            Text(" Search", style: subtitle1),
                          ]),
                          NavItem(
                            Icons.description,
                            "Notes",
                            subtitle1,
                            model.navigateToFDIntroScreen,
                            Document.Notes,
                          ),
                          NavItem(
                            Icons.note,
                            "Question Papers",
                            subtitle1,
                            model.navigateToFDIntroScreen,
                            Document.QuestionPapers,
                          ),
                          NavItem(
                            Icons.event_note,
                            "Syllabus",
                            subtitle1,
                            model.navigateToFDIntroScreen,
                            Document.Syllabus,
                          ),
                          NavItem(
                            Icons.link,
                            "Links",
                            subtitle1,
                            model.navigateToFDIntroScreen,
                            Document.Links,
                          ),
                          Divider(color: Colors.grey.shade600),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 20),
                              Text("Others", style: subtitle1),
                            ],
                          ),
                          NavItem(Icons.settings, "Settings", subtitle1,
                              model.navigateToProfileScreen, Document.None),
                          ListTile(
                            leading: Icon(
                              Icons.share,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Tell a Friend",
                              style: subtitle1,
                            ),
                            onTap: () {
                              final RenderBox box = context.findRenderObject();
                              Share.share(
                                  'At OU Notes you can find all lastest Academic Material for Osmania University including\n 1. Notes (PDF , e-books etc.)\n 2. Syllabus\n 3. Previous Question Papers\n 4. Resources (helpful links for learning online)\n. Check it out on Google Play!\n https://play.google.com/store/apps/details?id=com.notes.ounotes',
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                            },
                          ),
                          // NavItem(Icons.import_contacts, "About Us", subtitle1,
                          //     model.navigateToAboutUsScreen, Document.None),
                          ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              "Log out",
                              style: subtitle1,
                            ),
                            onTap: () {
                              // model.handleSignOut(context);
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => DrawerViewModel());
  }
}
