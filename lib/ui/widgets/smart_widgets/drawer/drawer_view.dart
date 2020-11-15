import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/CustomIcons/custom_icons.dart';
import 'package:FSOUNotes/enums/enums.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/drawer_header.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/nav_item.dart';
import 'package:FSOUNotes/ui/widgets/smart_widgets/drawer/drawer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subtitle1 =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16);
    return ViewModelBuilder<DrawerViewModel>.reactive(
        builder: (context, model, child) => Container(
              width: App(context).appScreenWidthWithOutSafeArea(0.78),
              child: Drawer(
                child: ListView(
                  children: [
                    DrawerHeaderView(),
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
                            title: Text(
                              "SWITCH THEME",
                              style: subtitle1,
                            ),
                            onTap: () {
                              model.updateAppTheme(context);
                            },
                          ),
                          ListTile(
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
                              onTap: () {
                                OpenAppstore.launch(
                                    androidAppId: 'com.notes.ounotes',
                                    iOSAppId: 'com.notes.ounotes');
                              }),
                          NavItem(
                              Icons.arrow_drop_down_circle,
                              "My Downloads",
                              subtitle1,
                              model.navigateToDownloadScreen,
                              Document.None),
                          NavItem(
                              Icons.file_upload,
                              "Upload",
                              subtitle1,
                              model.navigateToUserUploadScreen,
                              Document.Drawer),
                          if (model.isAdmin)
                            NavItem(
                                Icons.equalizer,
                                "Admin Panel",
                                subtitle1,
                                model.navigateToAdminUploadScreen,
                                Document.Drawer),
                          ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 40,
                              child: ClipRRect(
                                  child: Image.asset(
                                      "assets/images/github-logo.png")
                                  //)
                                  ),
                            ),
                            title: Text(
                              "Check us out on Github",
                              style: subtitle1,
                            ),
                            onTap: () async {
                              const url =
                                  'https://github.com/AbdulMalikDev/ounotes';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 40,
                              child: ClipRRect(
                                  child: Image.asset(
                                      "assets/images/telegram-logo.png")
                                  //)
                                  ),
                            ),
                            title: Text(
                              "Join us on telegram",
                              style: subtitle1,
                            ),
                            onTap: () async {
                              const url =
                                  'https://t.me/ounotes';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          Divider(color: Colors.grey.shade600),
                          Row(children: <Widget>[
                            SizedBox(width: 10),
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
                              SizedBox(width: 10),
                              Text("Others", style: subtitle1),
                            ],
                          ),
                          NavItem(Icons.account_box, "Profile", subtitle1,
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
                                  'OU Notes is probably the best App to find all Academic Material for Osmania University including\n 1. Notes (PDF , e-books etc.)\n 2. Syllabus\n 3. Previous Question Papers\n 4. Resources (helpful links for learning online)\n I\'ve ever used so far.Check it out on Google Play!\n https://play.google.com/store/apps/details?id=com.notes.ounotes',
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.feedback,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(
                              'Feedback',
                              style: subtitle1,
                            ),
                            onTap: () {
                              model.dispatchEmail();
                            },
                          ),
                          NavItem(Icons.import_contacts, "About Us", subtitle1,
                              model.navigateToAboutUsScreen, Document.None),
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
