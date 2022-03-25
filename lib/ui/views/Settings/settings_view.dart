import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/CustomIcons/custom_icons.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/Settings/settings_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.teal[700], Colors.teal[400]],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var subtitle1 =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16);
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    var iconColor = AppStateNotifier.isDarkModeOn
        ? theme.iconTheme.color
        : Colors.black.withOpacity(0.6);
    return ViewModelBuilder<SettingsViewModel>.reactive(
      onModelReady: (model) {
        model.setUser();
      },
      builder: (context, model, child) {
        return ModalProgressHUD(
          inAsyncCall: model.isBusy,
          opacity: 0.5,
          progressIndicator: circularProgress(),
          child: Scaffold(
            body: ListView(
              children: [
                Container(
                  height: App(context).appHeight(0.15),
                  child: Stack(
                    children: <Widget>[
                      // Container(
                      //   alignment: Alignment.center,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[300],
                      //     shape: BoxShape.circle,
                      //   ),
                      //   height: App(context)
                      //       .appScreenHeightWithOutSafeArea(0.12),
                      //   width: App(context)
                      //       .appScreenWidthWithOutSafeArea(0.32),
                      //   child: Image.asset(
                      //     "assets/images/apnaicon.png",
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                      Positioned(
                        top: -30,
                        left: wp * 0.3,
                        right: wp * 0.3,
                        child: Container(
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            'assets/lottie/intro_book.json',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(top: hp * 0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model.user?.username ?? '',
                                style: theme.textTheme.headline6.copyWith(
                                  fontSize: 20,
                                  foreground: Paint()..shader = linearGradient,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              model.user?.isPremiumUser ?? false
                                  ? Icon(
                                      MdiIcons.crown,
                                      size: 30,
                                      color: Colors.amber,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.brightness_4,
                              color: iconColor,
                            ),
                            SizedBox(
                              width: wp * 0.03,
                            ),
                            Text(
                              "Switch Theme",
                              style: subtitle1,
                            ),
                            Spacer(),
                            ThemeSwitcher(builder: (context) {
                              return Container(
                                height: 45,
                                width: 50,
                                child: DayNightSwitcher(
                                  isDarkModeEnabled:
                                      AppStateNotifier.isDarkModeOn,
                                  onStateChanged: (bool val) async {
                                    await model.updateAppTheme(context, val);
                                  },
                                ),
                              );
                            })
                          ],
                        ),
                        onTap: () {},
                      ),
                      divider(),
                      SettingsTile(
                        icon: SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(
                            MdiIcons.volumeHigh,
                            color: iconColor,
                          ),
                        ),
                        title: 'Feedback',
                        subTitle: "Let us know what you think about our app!",
                        isClickable: true,
                        onPressed: () async {
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
                      // if (model.isAdmin)
                      //   NavItem(Icons.equalizer, "Admin Panel", subtitle1,
                      //       model.navigateToAdminUploadScreen, Document.Drawer),
                      SettingsTile(
                        isClickable: true,
                        onPressed: () {
                          model.navigateToAccountInfoScreen();
                        },
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(Icons.person, color: iconColor),
                        ),
                        title: "Account Settings",
                        subTitle: "Change your semeter, branch etc.",
                      ),
                      SettingsTile(
                        isClickable: true,
                        onPressed: () {
                          model.showRateMyAppDialog(context);
                        },
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(Custom.emo_thumbsup, color: iconColor),
                        ),
                        title: "RATE THIS APP",
                        subTitle: "Donate a 5 star.",
                      ),
                      if (model.isAdmin)
                        SettingsTile(
                          isClickable: true,
                          onPressed: () {
                            model.navigateToAdminUploadScreen();
                          },
                          icon: SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(Icons.equalizer, color: iconColor),
                          ),
                          title: "Admin Panel",
                          subTitle: "Admin tools",
                        ),

                      if (model.isVerifier)
                        SettingsTile(
                          isClickable: true,
                          onPressed: () {
                            model.navigateToVerifierPanelScreen();
                          },
                          icon: SizedBox(
                            height: 30,
                            width: 30,
                            child:
                                Icon(Icons.account_balance, color: iconColor),
                          ),
                          title: "Verifier Panel",
                          subTitle: "Verifier tools",
                        ),

                      SettingsTile(
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(
                            MdiIcons.accountSupervisor,
                            color: iconColor,
                          ),
                        ),
                        title: "About Us",
                        subTitle: "Know more about us!",
                        isClickable: true,
                        onPressed: () {
                          model.navigateToAboutUsScreen();
                        },
                      ),
                      SettingsTile(
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: ClipRRect(
                            child: Image.asset("assets/images/donate-icon.png",
                                color: iconColor),
                          ),
                        ),
                        title: "Support Us",
                        subTitle: "Your support means a lot!",
                        isClickable: true,
                        onPressed: () {
                          model.showBuyPremiumBottomSheet();
                        },
                      ),
                      SettingsTile(
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(Icons.share, color: iconColor),
                        ),
                        title: "Tell a Friend",
                        subTitle: "Share this app with a friend!",
                        isClickable: true,
                        onPressed: () {
                          final RenderBox box = context.findRenderObject();
                          Share.share(
                              'OU Notes is the best App to find all lastest Academic Material for Osmania University including\n 1. Notes (PDF , e-books etc.)\n 2. Syllabus\n 3. Previous Question Papers\n 4. Resources (helpful links for learning online)\n. Check it out on Google Play!\n https://play.google.com/store/apps/details?id=com.notes.ounotes',
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size);
                        },
                      ),
                      SettingsTile(
                        title: "Check us out on Github",
                        subTitle: "Help us out on Github!",
                        isClickable: true,
                        onPressed: () async {
                          const url =
                              'https://github.com/AbdulMalikDev/ounotes';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: ClipRRect(
                            child: Image.asset(
                              "assets/images/github-logo.png",
                              color: iconColor,
                            ),
                          ),
                        ),
                      ),
                      SettingsTile(
                        title: "Join us on telegram",
                        subTitle: "live updates from the admins!",
                        isClickable: true,
                        onPressed: () async {
                          const url = 'https://t.me/ounotes';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        icon: SizedBox(
                          height: 30,
                          width: 30,
                          child: ClipRRect(
                            child: Image.asset(
                              "assets/images/telegram-logo.png",
                              //TODO update telegram logo
                              // color: AppStateNotifier.isDarkModeOn
                              //     ? theme.iconTheme.color
                              //     : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    height: App(context).appHeight(0.12),
                    width: App(context).appWidth(1) - 40,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(16),
                    //   color: theme.scaffoldBackgroundColor,
                    //   border: Border.all(
                    //     color: primary,
                    //     width: 1.5,
                    //   ),
                    // ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Open pdf in",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: DropdownButton(
                            elevation: 15,
                            value: model.userOption,
                            items: model.dropDownOfOpenPDF,
                            onChanged: model.changedDropDownItemOfOpenPdfChoice,
                            dropdownColor:
                                Theme.of(context).colorScheme.background,
                            focusColor:
                                Theme.of(context).colorScheme.background,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: hp * 0.05,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "App Version: ${model.appVersion}",
                        style: theme.textTheme.bodyText2
                            .copyWith(color: iconColor),
                      ),
                      TextButton(
                        onPressed: () {
                          model.handleSignOut(context);
                        },
                        child: Text(
                          "Logout",
                          style: theme.textTheme.bodyText2.copyWith(
                              color: theme.primaryColor, fontSize: 20),
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
      viewModelBuilder: () => SettingsViewModel(),
    );
  }

  Widget divider() {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget icon;
  final bool isClickable;
  final Function onPressed;
  final bool largeSubtitle;
  const SettingsTile({
    Key key,
    @required this.title,
    this.subTitle,
    @required this.icon,
    this.isClickable = false,
    this.onPressed,
    this.largeSubtitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double hp = App(context).appHeight(1);
    double wp = App(context).appWidth(1);
    var theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed ?? () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  icon ?? Container(),
                  SizedBox(
                    width: wp * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headline6.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: largeSubtitle ? hp * 0.032 : hp * 0.02,
                        width: isClickable ? wp * 0.68 : wp * 0.75,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          subTitle ?? "",
                          style:
                              theme.textTheme.bodyText2.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (isClickable)
                    Flexible(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: theme.iconTheme.color.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTextFormFieldView extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget preIcon;
  final Widget postIcon;
  final TextEditingController textEditingController;

  const SettingsTextFormFieldView({
    Key key,
    this.labelText,
    this.hintText,
    this.preIcon,
    this.postIcon,
    @required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('sdsdsdsdsdsd' + textEditingController.text);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        readOnly: true,
        controller: textEditingController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          prefixIcon: preIcon,
          suffixIcon: postIcon,
          hintText: hintText,
          labelText: labelText,
          prefix: Padding(
            padding: const EdgeInsets.all(5),
          ),
          labelStyle: defaultTextStyle.copyWith(
            color: AppStateNotifier.isDarkModeOn
                ? Theme.of(context).colorScheme.primary
                : primary,
            fontSize: 20,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
