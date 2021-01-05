import 'package:FSOUNotes/AppTheme/AppStateNotifier.dart';
import 'package:FSOUNotes/misc/constants.dart';
import 'package:FSOUNotes/ui/shared/app_config.dart';
import 'package:FSOUNotes/ui/views/Settings/settings_viewmodel.dart';
import 'package:FSOUNotes/ui/widgets/dumb_widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  TextEditingController controllerForEmail = TextEditingController();
  TextEditingController controllerForSem = TextEditingController();
  TextEditingController controllerForBranch = TextEditingController();
  TextEditingController controllerForCollege = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var subtitle1 =
        Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16);
    return ViewModelBuilder<SettingsViewModel>.reactive(
      onModelReady: (model) async {
        await model.setUser();
        controllerForEmail.text = model.user?.email;
        controllerForSem.text = model.user?.semester;
        controllerForBranch.text = model.user?.branch;
        controllerForCollege.text = model.user?.college;
      },
      builder: (context, model, child) {
        return ModalProgressHUD(
          inAsyncCall: model.isBusy,
          opacity: 0.5,
          progressIndicator: circularProgress(),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Settings"),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      Container(
                        height: App(context).appHeight(0.2),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: App(context)
                                  .appScreenHeightWithOutSafeArea(0.12),
                              width: App(context)
                                  .appScreenWidthWithOutSafeArea(0.32),
                              child: Image.asset(
                                "assets/images/apnaicon.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(model.user?.username ?? '',
                                style: theme.textTheme.headline6),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SettingsTextFormFieldView(
                            textEditingController: controllerForEmail,
                            labelText: "Email",
                            preIcon: Icon(Icons.email),
                          ),
                          SettingsTextFormFieldView(
                            textEditingController: controllerForSem,
                            labelText: "Semester",
                            preIcon: Icon(Icons.calendar_today),
                          ),
                          SettingsTextFormFieldView(
                            textEditingController: controllerForBranch,
                            labelText: "Branch",
                            preIcon: Icon(Icons.person),
                          ),
                          SettingsTextFormFieldView(
                            textEditingController: controllerForCollege,
                            labelText: "College",
                            preIcon: Icon(Icons.school_sharp),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: App(context).appHeight(0.12),
                          width: App(context).appWidth(1) - 40,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: theme.scaffoldBackgroundColor,
                            border: Border.all(
                              color: primary,
                              width: 1.5,
                            ),
                          ),
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
                                  onChanged:
                                      model.changedDropDownItemOfOpenPdfChoice,
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
                        height: 10,
                      ),
                      Container(
                        height: App(context).appHeight(0.09),
                        margin:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: theme.scaffoldBackgroundColor,
                          border: Border.all(
                            color: primary,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 40,
                              child: ClipRRect(
                                child: Image.asset(
                                    "assets/images/github-logo.png"),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Check us out on Github",
                                    style: subtitle1,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                              ],
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
                        ),
                      ),
                      Container(
                        height: App(context).appHeight(0.09),
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: theme.scaffoldBackgroundColor,
                          border: Border.all(
                            color: primary,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 40,
                              child: ClipRRect(
                                  child: Image.asset(
                                      "assets/images/telegram-logo.png")
                                  //)
                                  ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Join us on telegram",
                                    style: subtitle1,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            onTap: () async {
                              const url = 'https://t.me/ounotes';
                              if (await canLaunch(url)) {
                                model.recordTelegramVisit();
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: const EdgeInsets.symmetric(horizontal:70),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            "CHANGE INFORMATION",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            model.handleSignOut();
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
          ),
        );
      },
      viewModelBuilder: () => SettingsViewModel(),
    );
  }
}

Widget buildTile(String title, String subtitle, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0),
        child: Icon(
          FontAwesomeIcons.solidCircle,
          size: 12.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontSize: 20, color: Colors.deepOrange),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18),
          ),
        ],
      ),
    ),
  );
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
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
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
